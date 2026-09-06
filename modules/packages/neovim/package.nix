{ self, ... }: {
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
