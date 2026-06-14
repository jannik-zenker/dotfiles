{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/configuration/environment.kdl".text = ''
        environment {
            QT_QPA_PLATFORM "wayland"
            QT_QPA_PLATFORMTHEME "gtk3"
        }
      '';
    };
  };
}
