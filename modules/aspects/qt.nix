{ lib, ... }:
{
  den.aspects.qt = {
    homeManager = { pkgs, config, ... }: {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
      };

      home.packages = [
        (pkgs.kdePackages.qt6ct.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./qt6ct-0.11.patch ];
        }))
      ];

      home.sessionVariables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";

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
