{
  den.aspects.firefox.homeManager = { config, ... }: {
    defaultApps.browser = {
      command = "firefox";
      desktopFile = "firefox.desktop";
    };

    programs.firefox = {
      enable = true;

      languagePacks = [
        "de-DE"
        "en-GB"
      ];
      policies = {
        # Updates & Background Services
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;

        # Feature Disabling
        DisableBuiltinPDFViewer = true;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisableFormHistory = false;
        DisablePasswordReveal = true;

        # Access Restrictions
        BlockAboutConfig = false;
        BlockAboutProfiles = true;
        BlockAboutSupport = true;

        # UI and Behavior
        DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        HardwareAcceleration = true;
        OfferToSaveLogins = false;
        DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";

        # Extensions
        ExtensionSettings =
          let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
            extension = short: {
              install_url = moz short;
              installation_mode = "force_installed";
              updates_disabled = true;
            };
          in
          {
            "*".installation_mode = "blocked";

            "uBlock0@raymondhill.net" = extension "ublock-origin";

            "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = extension "github-file-icons";

            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = extension "return-youtube-dislikes";

            "sponsorBlocker@ajay.app" = extension "sponsorblock";

            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = extension "bitwarden-password-manager";

            "{74145f27-f039-47ce-a470-a662b129930a}" = extension "clearurls";

            "jid1-BoFifL9Vbdl2zQ@jetpack" = extension "decentraleyes";
          };
      };
      profiles.default = {
        search = {
          default = "startpage";

          engines = {
            startpage = {
              name = "Startpage";

              urls = [
                {
                  template = "https://www.startpage.com/sp/search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              definedAliases = [ "@sp" ];
            };
          };

          order = [
            "startpage"
            "ddg"
            "google"
          ];
        };
      };
    };
  };
}
