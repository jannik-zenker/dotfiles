{ den, ... }: {
  den.aspects.qt = {
    includes = [ den.aspects.gtk ];

    homeManager = _: {
      qt = {
        enable = true;
        platformTheme.name = "gtk3";
      };

      home.file.".config/qt6ct/qt6ct.conf".text = ''
        [Appearance]
        style=Fusion
        icon_theme=Papirus-Dark
      '';

      home.file.".config/kdeglobals".text = ''
        [Icons]
        Theme=Papirus-Dark
      '';
    };
  };
}
