{ self, ... }:
{
  den.aspects.neovim.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
      ];
    };
}
