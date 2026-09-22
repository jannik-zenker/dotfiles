{
  den.aspects.okular.homeManager = { pkgs, ... }: {
    # Repo-defined, desktop-environment-agnostic option: wires this app into
    # the XDG default-app association for application/pdf
    # (host-defaults/xdg.nix).
    defaultApps.pdf = {
      command = "okular";
      desktopFile = "org.kde.okular.desktop";
    };

    home.packages = [ pkgs.kdePackages.okular ];
  };
}
