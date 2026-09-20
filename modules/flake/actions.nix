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
      ".github/workflows/update-flake.yaml" = {
        name = "Update flake";

        on = {
          schedule = [ { cron = "0 4 * * *"; } ];

          workflow_dispatch = { };
        };

        permissions = {
          contents = "write";
          pull-requests = "write";
        };

        jobs = {
          update = {
            steps = [
              {
                name = "Checkout";
                uses = "actions/checkout@v6";

                "with" = {
                  ref = "main";
                  token = "\${{ secrets.UPDATE_BOT_TOKEN }}";
                };
              }

              {
                name = "Install Nix";
                uses = "DeterminateSystems/nix-installer-action@main";
              }

              {
                name = "Update flake.lock";
                run = ''
                  nix flake update
                '';
              }

              {
                name = "Check for changes";
                id = "changes";

                run = ''
                  if git diff --quiet -- flake.lock; then
                    echo "changed=false" >> "$GITHUB_OUTPUT"
                  else
                    echo "changed=true" >> "$GITHUB_OUTPUT"
                  fi
                '';
              }

              {
                name = "Configure git";
                "if" = "steps.changes.outputs.changed == 'true'";

                run = ''
                  git config user.name "github-actions[bot]"
                  git config user.email \
                    "41898282+github-actions[bot]@users.noreply.github.com"
                '';
              }

              {
                name = "Commit update";
                "if" = "steps.changes.outputs.changed == 'true'";

                run = ''
                  git add flake.lock
                  git commit -m "chore: update flake.lock"
                '';
              }

              {
                name = "Push update branch";
                "if" = "steps.changes.outputs.changed == 'true'";

                run = ''
                  git fetch origin bot/flake-update \
                    || true

                  git switch -C bot/flake-update
                  git push \
                    --force-with-lease \
                    --set-upstream origin bot/flake-update
                '';
              }

              {
                name = "Create pull request";
                "if" = "steps.changes.outputs.changed == 'true'";

                env.GH_TOKEN = "\${{ secrets.UPDATE_BOT_TOKEN }}";

                run = ''
                  if ! gh pr view bot/flake-update \
                    --repo "$GITHUB_REPOSITORY" \
                    >/dev/null 2>&1
                  then
                    gh pr create \
                      --repo "$GITHUB_REPOSITORY" \
                      --base main \
                      --head bot/flake-update \
                      --title "chore: update flake.lock" \
                      --body "Automated daily flake input update."
                  fi

                  gh pr merge bot/flake-update \
                    --repo "$GITHUB_REPOSITORY" \
                    --auto \
                    --squash
                '';
              }
            ];
          };
        };
      };

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
