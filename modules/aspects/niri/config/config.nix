{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/config.kdl".text = ''
        //-----------------------------------------------//
        //---------------ROOT CONFIG FILE----------------//
        //-----------------------------------------------//
        include "./configuration/animations.kdl"
        include "./configuration/blur.kdl"
        include "./configuration/cursor.kdl"
        include "./configuration/environment.kdl"
        include "./configuration/input.kdl"
        include "./configuration/keymaps.kdl"
        include "./configuration/layout.kdl"
        include "./configuration/misc.kdl"
        include "./configuration/monitors.kdl"
        include "./configuration/windowrules.kdl"
        include "./configuration/workspaces.kdl"
      '';
    };
  };
}
