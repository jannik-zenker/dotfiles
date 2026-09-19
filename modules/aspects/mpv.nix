{
  den.aspects.mpv.homeManager = { pkgs, ... }: {
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
