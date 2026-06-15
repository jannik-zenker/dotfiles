{ lib, ... }:
{
  den.aspects.qt = {
    homeManager = { ... }: {
      qt = {
        enable = true;
      };

      home.sessionVariables = {
        QT_QPA_PLATFORMTHEME = lib.mkDefault "gtk3";
      };
    };
  };
}
