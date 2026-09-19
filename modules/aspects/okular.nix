{
  den.aspects.okular.homeManager = { pkgs, ... }: {
    defaultApps.pdf = {
      command = "okular";
      desktopFile = "org.kde.okular.desktop";
    };

    home.packages = [ pkgs.kdePackages.okular ];
  };
}
