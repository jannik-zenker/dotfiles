{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/configuration/layout.kdl".text = ''
        layout {
            gaps 10
            center-focused-column "never"
            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }
            // preset-window-heights { }
            default-column-width { proportion 0.5; }
            focus-ring {
                off
                width 4
                active-color "#7fc8ff"
                inactive-color "#505050"
            }
            border {
                off
                width 4
                active-color "#ffc87f"
                inactive-color "#505050"
                urgent-color "#9b0000"
            }
            shadow {
                softness 30
                spread 7
                offset x=0 y=0
                // color "#0007"
            }
            struts {
                left 10
                right 10
                top 10
                bottom 10
            }
        }
        window-rule {
            geometry-corner-radius 20
            clip-to-geometry true
        }
      '';
    };
  };
}
