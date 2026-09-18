{
  den.aspects.ghostty.homeManager = { pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      systemd.enable = true;
      settings = {
        # Font settings
        font-family = "MonaspiceNe Nerd Font Mono";
        font-size = 14;
        # Behaviour
        mouse-scroll-multiplier = 3;
        # Styling
        background-opacity = 0.7;
        window-padding-x = 23;
        window-padding-y = 20;
        # Cursor
        cursor-style = "block";
        cursor-style-blink = false;
        custom-shader = "shaders/cursor_warp.glsl";
      };
    };

    fonts.fontconfig.enable = true;
    home.packages = [ pkgs.nerd-fonts.monaspace ];

    xdg.configFile."ghostty/shaders".source = ./shaders;
  };
}
