{ inputs, ... }: {
  flake-file.inputs = {
    obsidian-extensions = {
      url = "github:karaolidis/nix-obsidian-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.obsidian = {
    # obsidian is a user aspect, but overlays apply to nixpkgs at host scope,
    # so this is routed via provides.to-hosts. Provides the
    # pkgs.obsidianThemes/obsidianPlugins sets referenced below.
    provides.to-hosts = {
      nixos.nixpkgs.overlays = [ inputs.obsidian-extensions.overlays.default ];
    };

    homeManager = { pkgs, ... }: {
      programs.obsidian = {
        enable = true;

        defaultSettings = {
          app = {
            alwaysUpdateLinks = true;
            spellcheck = true;
          };

          corePlugins = [
            "backlink"
            "file-explorer"
            "file-recovery"
            "global-search"
            "outgoing-link"
            "page-preview"
            "templates"
            "webviewer"
          ];
        };

        vaults.dnd = {
          target = "Documents/TTRPG/DnD";

          settings = {
            appearance.theme = "moonstone";

            themes = with pkgs.obsidianThemes; [ its-theme ];

            corePlugins = [
              "backlink"
              "canvas"
              "file-explorer"
              "file-recovery"
              "global-search"
              "graph"
              "outgoing-link"
              "page-preview"

              {
                name = "templates";
                settings = {
                  folder = "Templates";
                };
              }

              "webviewer"
            ];

            communityPlugins = with pkgs.obsidianPlugins; [
              aprils-automatic-timelines
              dataview
              heraldry-weaver
              {
                pkg = home-base;

                settings = {
                  homeBaseType = "File";
                  homeBaseValue = "Home.md";

                  openOnStartup = true;
                  openViewMode = "preview";

                  replaceNewTab = true;
                  newTabMode = "always";

                  openWhenAllTabsClosed = true;

                  useDifferentFileForNewTab = false;
                };
              }

              image-window
              initiative-tracker

              {
                pkg = obsidian-custom-frames;

                settings = {
                  padding = 0;

                  frames = [
                    {
                      url = "https://foundry.jannikzenker.de";
                      displayName = "Foundry VTT";
                      icon = "dices";

                      hideOnMobile = true;
                      addRibbonIcon = true;
                      openInCenter = true;

                      zoomLevel = 1;
                      forceIframe = false;

                      customCss = "";
                      customJs = "";
                    }
                  ];
                };
              }
              made-up-words
              obsidian-5e-statblocks
              obsidian-admonition
              obsidian42-brat
              obsidian-excalidraw-plugin
              pexels-banner
              randomness
              relations
              {
                pkg = supercharged-links-obsidian;

                settings = {
                  targetAttributes = [ "type" ];

                  targetTags = true;
                  getFromInlineField = false;
                  activateSnippet = true;

                  enableEditor = true;
                  enableTabHeader = true;
                  enableFileList = true;
                  enableBacklinks = true;
                  enableQuickSwitcher = true;
                  enableSuggestor = true;
                  enableBases = true;

                  selectors = [
                    {
                      type = "attribute";
                      name = "type";
                      value = "npc";
                      matchCaseSensitive = false;
                      match = "exact";
                      uid = "dnd-npc";

                      selectText = false;
                      selectBackground = false;
                      selectAppend = false;
                      selectPrepend = true;
                    }

                    {
                      type = "attribute";
                      name = "type";
                      value = "location";
                      matchCaseSensitive = false;
                      match = "exact";
                      uid = "dnd-location";

                      selectText = false;
                      selectBackground = false;
                      selectAppend = false;
                      selectPrepend = true;
                    }

                    {
                      type = "attribute";
                      name = "type";
                      value = "faction";
                      matchCaseSensitive = false;
                      match = "exact";
                      uid = "dnd-faction";

                      selectText = false;
                      selectBackground = false;
                      selectAppend = false;
                      selectPrepend = true;
                    }

                    {
                      type = "attribute";
                      name = "type";
                      value = "deity";
                      matchCaseSensitive = false;
                      match = "exact";
                      uid = "dnd-deity";

                      selectText = false;
                      selectBackground = false;
                      selectAppend = false;
                      selectPrepend = true;
                    }

                    {
                      type = "attribute";
                      name = "type";
                      value = "quest";
                      matchCaseSensitive = false;
                      match = "exact";
                      uid = "dnd-quest";

                      selectText = false;
                      selectBackground = false;
                      selectAppend = false;
                      selectPrepend = true;
                    }

                    {
                      type = "attribute";
                      name = "type";
                      value = "item";
                      matchCaseSensitive = false;
                      match = "exact";
                      uid = "dnd-item";

                      selectText = false;
                      selectBackground = false;
                      selectAppend = false;
                      selectPrepend = true;
                    }

                    {
                      type = "attribute";
                      name = "type";
                      value = "session";
                      matchCaseSensitive = false;
                      match = "exact";
                      uid = "dnd-session";

                      selectText = false;
                      selectBackground = false;
                      selectAppend = false;
                      selectPrepend = true;
                    }
                  ];
                };
              }

              {
                pkg = obsidian-style-settings;

                settings = {
                  # ITS Theme
                  "ITS@@select" = "wotc-beyond";

                  # Supercharged Links
                  "supercharged-links@@dnd-npc-before" = "👤 ";
                  "supercharged-links@@dnd-location-before" = "🏰 ";
                  "supercharged-links@@dnd-faction-before" = "⚔️ ";
                  "supercharged-links@@dnd-deity-before" = "✨ ";
                  "supercharged-links@@dnd-quest-before" = "📜 ";
                  "supercharged-links@@dnd-item-before" = "🗡️ ";
                  "supercharged-links@@dnd-session-before" = "🎲 ";
                };
              }

              various-complements
            ];
          };
        };
      };
    };
  };
}
