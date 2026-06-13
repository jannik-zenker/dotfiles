{
  den.aspects.ghostty = {
    homeManager = {
      programs.ghostty = {
        enable = true;
        systemd.enable = true;
        settings = ''
          # Import color file if existent
          config-file = ?colors.ghostty

          # Font settings
          font-family = MonaspiceNe Nerd Font Mono
          font-size = 12

          # Behaviour
          mouse-scroll-multiplier = 3

          # Styling
          background-opacity = 0.7
          window-padding-x = 23
          window-padding-y = 20

          # Cursor
          cursor-style = block
          cursor-style-blink = false
          custom-shader = shaders/cursor_warp.glsl
        '';
      };
    };
  };
}
