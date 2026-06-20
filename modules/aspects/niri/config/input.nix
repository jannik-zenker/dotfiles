{
  den.aspects.niri = {
    homeManager = {
      programs.niri.settings.input = {
        keyboard = {
          xkb = {
            layout = "de";
            variant = "nodeadkeys";
          };
          repeat-delay = 200;
          repeat-rate = 40;
          numlock = true;
        };

        touchpad = {
          accel-profile = "flat";
          accel-speed = 0.0;
          disabled-on-external-mouse = true;
          dwt = true;
          natural-scroll = true;
          tap = true;
        };

        mouse = {
          accel-profile = "flat";
          accel-speed = 0.0;
        };
        warp-mouse-to-focus.enable = true;
      };
    };
  };
}
