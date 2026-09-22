{
  den.aspects.gwenview.homeManager = { pkgs, ... }: {
    # Repo-defined, desktop-environment-agnostic option: wires this app into
    # the XDG default-app association for image mime types
    # (host-defaults/xdg.nix).
    defaultApps.imageViewer = {
      command = "gwenview";
      desktopFile = "org.kde.gwenview.desktop";
    };

    home.packages = [ pkgs.kdePackages.gwenview ];
  };
}
