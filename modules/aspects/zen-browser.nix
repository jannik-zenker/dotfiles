{ inputs, ... }:
{
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.zenBrowser = {
    homeManager = {
      # Import zens home-manager module
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;

        policies =
          let
            mkExtensionSettings = builtins.mapAttrs (
              _: pluginId: {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
                installation_mode = "force_installed";
              }
            );
          in
          {
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };

            Preferences = {
              "browser.startup.homepage" = {
                Value = "about:blank";
                Status = "locked";
              };
              "browser.tabs.warnOnClose" = {
                Value = true;
                Status = "locked"; # User cannot change this
              };
            };

            ExtensionSettings = mkExtensionSettings {
              "uBlock0@raymondhill.net" = "ublock-origin";
              "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
              "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
              "sponsorBlocker@ajay.app" = "sponsorblock";
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
              "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
              "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";
            };
          };

        profiles.default = {
          settings = {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.view.compact.hide-tabbar" = true;
            "zen.urlbar.behavior" = "float";
            "zen.welcome-screen.seen" = true;
            "zen.mods.AudioIndicatorEnhanced.audioWave.enabled" = true;
          };

          mods = [
            "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
            "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
            "2317fd93-c3ed-4f37-b55a-304c1816819e" # Audio Indicator Enhanced
            "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
            "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
          ];

          search = {
            force = true; # force these settings every rebuild
            default = "ddg";
          };

          containersForce = true; # Delete containers not declared here
          containers = {
            Personal = {
              color = "purple";
              icon = "fingerprint";
              id = 1;
            };
            Work = {
              color = "blue";
              icon = "briefcase";
              id = 2;
            };
            Shopping = {
              color = "yellow";
              icon = "dollar";
              id = 3;
            };
          };

          spacesForce = true; # Delete spaces not declared here
          spaces = {
            "Personal" = {
              id = "c6de089c-410d-4206-961d-ab11f988d40a";
              position = 1000;
              icon = "🏠";
            };
            "Work" = {
              id = "cdd10fab-4fc5-494b-9041-325e5759195b";
              position = 2000;
              icon = "💼";
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 100;
                    green = 150;
                    blue = 200;
                    algorithm = "floating";
                    type = "explicit-lightness";
                    lightness = 50;
                  }
                ];
                opacity = 0.8;
                texture = 0.5;
              };
            };
            "Shopping" = {
              id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
              position = 3000;
              icon = "💸";
            };
          };
        };
      };
    };
  };
}
