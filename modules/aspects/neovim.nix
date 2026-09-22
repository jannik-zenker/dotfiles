{ self, ... }: {
  den.aspects.neovim.homeManager = { pkgs, ... }: {
    # Repo-defined, desktop-environment-agnostic option: feeds the $EDITOR
    # session variable (host-defaults/environment.nix) and the XDG
    # default-app association for text mime types (host-defaults/xdg.nix).
    defaultApps.editor = {
      command = "nvim";
      desktopFile = "nvim.desktop";
    };

    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
  };
}
