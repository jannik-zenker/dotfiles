{
  den.aspects.kde.homeManager = {
    programs.plasma.kwin = {
      borderlessMaximizedWindows = true;
      # Barriers add cursor resistance at screen corners/edges (useful for
      # precise multi-monitor edge crossing); disabled here.
      cornerBarrier = false;
      edgeBarrier = 0;

      effects = {
        blur = {
          enable = true;
          noiseStrength = 2;
          strength = 13;
        };

        cube.enable = false;

        desktopSwitching.animation = "slide";

        dimAdminMode.enable = true;
        dimInactive.enable = false;

        fallApart.enable = false;
        fps.enable = false;
        hideCursor = {
          enable = true;
          hideOnInactivity = 60;
          hideOnTyping = true;
        };
        magnifier.enable = false;

        minimization = {
          animation = "magiclamp";
          duration = 200;
        };

        shakeCursor.enable = false;
        slideBack.enable = false;
        snapHelper.enable = true;
        translucency.enable = true;

        windowOpenClose.animation = "scale";
        wobblyWindows.enable = false;
      };

      nightLight = {
        enable = true;
        mode = "times";

        temperature = {
          day = 6500;
          night = 2700;
        };

        time = {
          morning = "07:00";
          evening = "22:00";
        };

        transitionTime = 300;
      };

      # Disable tiling window management, maybe add later for laptops
      scripts.polonium.enable = false;

      titlebarButtons = {
        left = [ "application-menu" ];
        right = [
          "minimize"
          "maximize"
          "close"
        ];
      };

      virtualDesktops = {
        names = [
          "General"
          "Work"
          "Gaming"
          "Multimedia"
        ];

        rows = 1;
      };
    };
  };
}
