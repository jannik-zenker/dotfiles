{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/configuration/misc.kdl".text = ''
        hotkey-overlay {
            skip-at-startup
            hide-not-bound
        }
        prefer-no-csd
        screenshot-path "~/Pictures/Screenshots/scrsh_%Y-%m-%d %H-%M-%S.png"
        clipboard {
            disable-primary
        }
      '';
    };
  };
}
