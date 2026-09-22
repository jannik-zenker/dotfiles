{ self, ... }: {
  # Consumed by aspects/neovim.nix via self.packages.<system>.neovim, so this
  # is the actual neovim every user gets.
  perSystem = { pkgs, ... }: {
    packages.neovim = self.lib.mkNeovim pkgs {
      theme = {
        name = "tokyonight";
        style = "moon";
        transparent = false;
      };
    };
  };
}
