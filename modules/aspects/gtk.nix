{
  den.aspects.gtk = {
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
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
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
        cursor-theme = "Bibata-Modern-Classic";
        cursor-size = 24;
        font-name = "Inter 11";
      };
    };
  };
}
