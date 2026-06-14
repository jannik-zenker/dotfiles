{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/configuration/input.kdl".text = ''
        input {
            keyboard {
                xkb {
                    layout "de"
                    variant "nodeadkeys"
                }
                repeat-delay 200
                repeat-rate 40
                numlock
            }
            touchpad {
                accel-profile "flat"
                accel-speed 0.0
                disabled-on-external-mouse
                dwt
                natural-scroll
                tap
            }
            mouse {
                accel-profile "flat"
                accel-speed 0.0
            }
            trackpoint {
            }
            // Uncomment this to make the mouse warp to the center of newly focused windows.
            warp-mouse-to-focus
            // Focus windows and outputs automatically when moving the mouse into them.
            // Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
            focus-follows-mouse max-scroll-amount="0%"
        }
      '';
    };
  };
}
