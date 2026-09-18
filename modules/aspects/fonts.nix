{
  den.aspects.fonts = {
    nixos = { pkgs, ... }: {
      # Install fallback fonts to cover all symbols
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        nerd-fonts.symbols-only
        noto-fonts-color-emoji
      ];
    };
  };
}
