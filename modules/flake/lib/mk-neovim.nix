{ den, ... }: {
  # Builds a standalone neovim package from `den.aspects.nvfConfiguration`
  # (see modules/packages/neovim/nvf-den-integration.nix), which is resolved
  # through a one-off "nvf" class outside the normal host/user pipeline. That
  # lets neovim be built and used directly as a package (e.g. from a flake
  # output or devShell) without needing a home-manager user to attach it to.
  # e.g.:
  #   self.lib.mkNeovim pkgs { theme.name = "tokyonight"; }
  config.flake.lib.mkNeovim = pkgs: args: den.lib.nvf.package pkgs den.aspects.nvfConfiguration args;
}
