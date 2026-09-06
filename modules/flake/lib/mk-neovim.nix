{ den, ... }:
{
  # Builds a neovim package from an nvf configuration, e.g.:
  #   self.lib.mkNeovim pkgs { theme.name = "tokyonight"; }
  config.flake.lib.mkNeovim = pkgs: args: den.lib.nvf.package pkgs den.aspects.nvfConfiguration args;
}
