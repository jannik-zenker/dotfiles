{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/configuration/monitors.kdl".text = ''
        output "ASUSTek COMPUTER INC VG27A R7LMQS113801" {
            mode "2560x1440@164.999"
            scale 1
            position x=1920 y=0
            focus-at-startup
        }
        output "LG Electronics 24GM79G 0x0008040D" {
            mode "1920x1080@144.001"
            scale 1
            position x=0 y=150
        }
      '';
    };
  };
}
