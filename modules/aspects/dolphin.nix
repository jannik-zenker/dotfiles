{
  den.aspects.dolphin.homeManager = { pkgs, ... }: {
    defaultApps = {
      fileManager = {
        command = "dolphin";
        desktopFile = "org.kde.dolphin.desktop";
      };

      archiveManager = {
        command = "ark";
        desktopFile = "org.kde.ark.desktop";
      };
    };

    home.packages = with pkgs.kdePackages; [
      dolphin
      ark
    ];
  };
}
