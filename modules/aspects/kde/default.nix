{ inputs, den, ... }: {
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";

    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  den.aspects.kde = {
    includes = [ den.aspects.papirusIconTheme ];

    nixos = { pkgs, ... }: {
      services.desktopManager.plasma6.enable = true;
      # Trim the default Plasma bundle to what this setup actually uses;
      # several defaults are covered by dedicated aspects instead.
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        plasma-workspace-wallpapers
        konsole
        kwin-x11
        elisa
        gwenview
        okular
        kate
        ktexteditor
        khelpcenter

        krdp

        plasma-keyboard
        qtvirtualkeyboard

        union
        qrca
        qtsensors
        discover # package management is declarative via Nix, not a GUI store
      ];
    };

    homeManager = {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
      programs.plasma = {
        enable = true;
        overrideConfig = false;
        immutableByDefault = true;
      };

      # To avoid homeManager activation fail
      gtk.gtk2.force = true;
      xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
    };
  };
}
