{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/configuration/blur.kdl".text = ''
        blur {
            passes 2
            offset 5
            noise 0.02
            saturation 1.0
        }
        window-rule { 
            background-effect {
                blur true
                xray false
            }

            match app-id="zen-beta"
            match app-id="zen-twilight"
        }
        layer-rule {
            match namespace="logout_dialog"
            background-effect {
                blur true
                xray false
            }
        }
      '';
    };
  };
}
