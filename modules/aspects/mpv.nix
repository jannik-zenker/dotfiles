{
  den.aspects.mpv.homeManager = { pkgs, ... }: {
    # Repo-defined, desktop-environment-agnostic option: wires this app into
    # the XDG default-app associations for video/audio mime types
    # (host-defaults/xdg.nix).
    defaultApps = {
      videoPlayer = {
        command = "mpv";
        desktopFile = "mpv.desktop";
      };

      audioPlayer = {
        command = "mpv";
        desktopFile = "mpv.desktop";
      };
    };

    home.packages = [ pkgs.mpv ];
  };
}
