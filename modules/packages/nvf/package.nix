{ den, self, ... }: {
  flake.lib.mkNeovim = pkgs: args: den.lib.nvf.package pkgs den.aspects.nvfConfiguration args;

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
