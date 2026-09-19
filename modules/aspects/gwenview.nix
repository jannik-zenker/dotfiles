{
  den.aspects.gwenview.homeManager = { pkgs, ... }: {
    defaultApps.imageViewer = {
      command = "gwenview";
      desktopFile = "org.kde.gwenview.desktop";
    };

    home.packages = [ pkgs.kdePackages.gwenview ];
  };
}
