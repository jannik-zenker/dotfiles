{
  den.aspects.office.homeManager = { pkgs, ... }: {
    defaultApps = {
      office = {
        command = "onlyoffice-desktopeditors";
        desktopFile = "onlyoffice-desktopeditors.desktop";
      };

      spreadsheet = {
        command = "onlyoffice-desktopeditors";
        desktopFile = "onlyoffice-desktopeditors.desktop";
      };

      presentation = {
        command = "onlyoffice-desktopeditors";
        desktopFile = "onlyoffice-desktopeditors.desktop";
      };
    };

    home.packages = with pkgs; [
      onlyoffice-desktopeditors
      slack
      teams-for-linux
    ];
  };
}
