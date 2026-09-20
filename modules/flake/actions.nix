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

          nixConfig = ''
            extra-substituters = ${attic.endpoint}/${attic.cache}
            extra-trusted-public-keys = ${attic.publicKey}
          '';

          nixosHosts = lib.mapAttrsToList (name: config: {
            hostname = name;
            output = "nixosConfigurations.${name}.config.system.build.toplevel";
          }) self.nixosConfigurations;

          commonSteps = [
            {
              name = "Checkout";
              uses = "actions/checkout@v6";
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
