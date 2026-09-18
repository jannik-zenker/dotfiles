{ den, ... }: {
  den.aspects.gtk = {
    includes = [ den.aspects.papirusIconTheme ];

    homeManager = { pkgs, ... }: {
      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          name = "Papirus-Dark";
        };
        cursorTheme = {
          name = "Breeze_Snow";
          size = 24;
        };
        font = {
          name = "Inter";
          size = 11;
          package = pkgs.inter;
        };
      };

      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Breeze_Snow";
        cursor-size = 24;
        font-name = "Inter 11";
      };
    };

    provides.to-hosts.nixos = { pkgs, ... }: {
      # Fix gtk3 apps not finding schemas
      environment.sessionVariables.XDG_DATA_DIRS = [
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      ];
    };
  };
}
