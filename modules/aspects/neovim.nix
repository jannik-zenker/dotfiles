{ self, ... }: {
  den.aspects.neovim.homeManager = { pkgs, ... }: {
    defaultApps.editor = {
      command = "nvim";
      desktopFile = "nvim.desktop";
    };

    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
  };
}
