{
  den.aspects.office.homeManager = { pkgs, ... }: {
    # Repo-defined, desktop-environment-agnostic option: wires this app into
    # the XDG default-app associations for office/spreadsheet/presentation
    # mime types (host-defaults/xdg.nix).
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
