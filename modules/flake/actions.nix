{
  inputs,
  self,
  lib,
  ...
}:
{

  flake-file.inputs.actions-nix = {
    url = "github:nialov/actions.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.actions-nix.flakeModules.default ];

  # Generates .github/workflows/ci.yaml from Nix (instead of hand-written
  # YAML) so the workflow can share data with the rest of the flake, notably
  # deriving its build matrix from every declared `den.hosts` entry below.
  flake.actions-nix = {
    defaultValues.jobs = {
      runs-on = "ubuntu-latest";
      timeout-minutes = 60;
    };

    workflows = {
      ".github/workflows/ci.yaml" =
        let
          attic = {
            endpoint = "https://cache.jannikzenker.de";
            cache = "dotfiles";
            publicKey = "dotfiles:2EaWL5tiEyYzC5KdZeR6f/V9DbVQZUQthxiVg19I3nk=";
          };

          # Secrets are unavailable for PRs originating from forks.
          hasSecrets = ''
            github.event_name != 'pull_request' ||
            github.event.pull_request.head.repo.full_name == github.repository
          '';

          # Let CI substitute from the same Attic cache builds are pushed to,
          # so a host whose toplevel was already built (by another job or
          # locally) doesn't get rebuilt from scratch.
          nixConfig = ''
            extra-substituters = ${attic.endpoint}/${attic.cache}
            extra-trusted-public-keys = ${attic.publicKey}
          '';

          # Derived from self.nixosConfigurations instead of hardcoded so
          # every host declared via den.hosts automatically gets a CI build
          # job with no workflow edit required.
          nixosHosts = lib.mapAttrsToList (name: _: {
            hostname = name;
            output = "nixosConfigurations.${name}.config.system.build.toplevel";
          }) self.nixosConfigurations;

          commonSteps = [
            {
              name = "Checkout";
              uses = "actions/checkout@v7";
            }

            {
              name = "Install Nix";
              uses = "DeterminateSystems/nix-installer-action@main";
            }
          ];
        in
        {
          name = "CI";

          on = {
            pull_request = { };

            workflow_dispatch = { };
          };

          permissions = {
            contents = "read";
          };

          jobs = {
            flake-check = {
              name = "Flake check";
              env.NIX_CONFIG = nixConfig;

              steps = commonSteps ++ [
                {
                  name = "Check flake";
                  run = ''
                    nix flake check
                  '';
                }
              ];
            };

            build = {
              name = "Build \${{ matrix.host.hostname }}";
              env.NIX_CONFIG = nixConfig;

              strategy = {
                fail-fast = false;
                matrix.host = nixosHosts;
              };

              steps = commonSteps ++ [
                {
                  name = "Build";
                  run = ''
                    nix build \
                      ".#''${{ matrix.host.output }}" \
                      --out-link result \
                      --print-build-logs
                  '';
                }

                {
                  name = "Install Attic";
                  run = ''
                    nix profile install nixpkgs#attic-client
                  '';
                }

                {
                  name = "Login to Attic";
                  "if" = hasSecrets;
                  env.ATTIC_TOKEN = "\${{ secrets.ATTIC_TOKEN }}";

                  run = ''
                    attic login \
                      --set-default \
                      ci \
                      ${attic.endpoint} \
                      "$ATTIC_TOKEN"
                  '';
                }

                {
                  name = "Push to Attic";
                  "if" = hasSecrets;

                  run = ''
                    attic push ${attic.cache} result
                  '';
                }
              ];
            };
          };
        };
    };
  };
}
