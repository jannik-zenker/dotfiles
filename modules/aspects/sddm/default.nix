{ inputs, ... }:
{
  flake-file.inputs = {
    pixie-sddm = {
      url = "github:xCaptaiN09/pixie-sddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.sddm = {
    nixos = { pkgs, ... }: {
      services.displayManager.sddm = {
        enable = true;
        theme = "pixie";
        wayland.enable = true;

        # Crucial for Qt6: Use the KDE/Qt6 build of SDDM to fix missing
        # cursors and module errors.
        package = pkgs.kdePackages.sddm;

        # Required dependencies for Qt6 themes
        extraPackages = [
          pkgs.kdePackages.qtsvg
          pkgs.kdePackages.qtdeclarative
          pkgs.kdePackages.qt5compat
        ];
      };

      environment.systemPackages = [
        # Install and customize the theme. All fields are optional and will
        # fall back to theme defaults if not set.
        (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
          background = ./wallpaper.png;
          avatar = ./avatar.png;
          fontFamily = "Inter Display";
          fontSize = 13;
        })
      ];

      # Install needed font
      fonts.packages = with pkgs; [ inter ];
    };
  };
}
