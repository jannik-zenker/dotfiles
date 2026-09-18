{
  den.aspects.kde = {
    homeManager = {
      programs.plasma.fonts = {
        general = {
          family = "Inter";
          pointSize = 10;
        };

        menu = {
          family = "Inter";
          pointSize = 10;
        };

        toolbar = {
          family = "Inter";
          pointSize = 10;
        };

        windowTitle = {
          family = "Inter";
          pointSize = 10;
          weight = 600;
        };

        small = {
          family = "Inter";
          pointSize = 8;
        };

        # Patched monospace font for terminal-style UI and Nerd Font glyphs.
        fixedWidth = {
          family = "JetBrainsMono Nerd Font";
          pointSize = 10;
        };
      };
    };

    # Install fonts system-wide instead of per-user home-manager profiles,
    # so they're shared by every user of the host instead of duplicated.
    provides.to-hosts.nixos = { pkgs, ... }: {
      fonts = {
        fontconfig.enable = true;
        packages = with pkgs; [
          inter
          nerd-fonts.jetbrains-mono
          # Fallback glyphs so unpatched fonts (e.g. Inter) can still render
          # Nerd Font icons via fontconfig substitution.
          nerd-fonts.symbols-only
        ];
      };
    };
  };
}
