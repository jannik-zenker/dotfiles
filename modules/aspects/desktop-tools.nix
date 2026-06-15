{
  den.aspects.desktopTools = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        gthumb # image viewer & editor
        mpv # Audio & video-player
        papers # PDF-viewer
      ];
    };
  };
}
