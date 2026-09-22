{ den, ... }: {
  den.aspects.gtk = {
    # Pulls in the Papirus-Dark icon package referenced by name below.
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

      # Duplicates the theme above for apps/portals that read the GNOME
      # interface schema directly instead of GTK's own settings.ini.
      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Breeze_Snow";
        cursor-size = 24;
        font-name = "Inter 11";
      };
    };

    # gtk is a user aspect; host-level config must be routed to the host via
    # provides.to-hosts rather than a flat nixos key here.
    provides.to-hosts.nixos = { pkgs, ... }: {
      # Fix gtk3 apps not finding schemas
      environment.sessionVariables.XDG_DATA_DIRS = [
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      ];
    };
  };
}
