{ inputs, ... }:
{
  flake-file.inputs = {
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.plymouth = {
    nixos = { pkgs, ... }: {
      nixpkgs.overlays = [ inputs.mac-style-plymouth.overlays.default ];
      boot = {
        plymouth = {
          enable = true;
          theme = "mac-style";
          themePackages = [ pkgs.mac-style-plymouth ];
        };

        # Enable "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];
      };

    };
  };
}
