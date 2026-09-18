{
  den.aspects.kde.homeManager = { user, ... }: {
    programs.plasma = {
      shortcuts = {
        kwin = {
          # Remove default hotkey to be able to use it elsewhere
          "Show Desktop" = [ ];

          "Window Close" = "Meta+Q";

          "Window Maximize" = "Meta+F";
          "Window Fullscreen" = "Meta+Shift+F";

          "Switch to Desktop 1" = "Meta+1";
          "Switch to Desktop 2" = "Meta+2";
          "Switch to Desktop 3" = "Meta+3";
          "Switch to Desktop 4" = "Meta+4";
          "Switch to Desktop 5" = "Meta+5";
          "Switch to Desktop 6" = "Meta+6";
        };

        krunner = {
          "run command" = "Meta+D";
        };

        plasmashell = {
          # Remove default hotkeys to be able to use them elsewhere
          "manage activities" = [ ];

          "activate task manager entry 1" = [ ];
          "activate task manager entry 2" = [ ];
          "activate task manager entry 3" = [ ];
          "activate task manager entry 4" = [ ];
          "activate task manager entry 5" = [ ];
          "activate task manager entry 6" = [ ];
        };
      };

      hotkeys.commands = {
        terminal = {
          name = "Open Terminal";
          key = "Meta+Return";
          command = "${user.defaultTerminal}";
        };

        browser = {
          name = "Open Browser";
          key = "Meta+B";
          command = "${user.defaultBrowser}";
        };

        fileManager = {
          name = "Open File Manager";
          key = "Meta+E";
          command = "dolphin";
        };
      };
      configFile.kwinrc.Desktops.Number = {
        value = 6;
        immutable = true;
      };
    };
  };
}
