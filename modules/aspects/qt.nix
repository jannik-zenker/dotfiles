{
  den.aspects.qtTheming = {
    homeManager = { config, ... }: {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
      };

      home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

      home.file.".config/qt6ct/qt6ct.conf".text = ''
        [Appearance]
        style=Fusion
        icon_theme=Papirus-Dark
        custom_palette=true
        color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf
      '';

      home.file.".config/kdeglobals".text = ''
        [Icons]
        Theme=Papirus-Dark
      '';
    };
  };
}
