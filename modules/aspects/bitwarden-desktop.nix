{
  den.aspects.bitwardenDesktop = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ bitwarden-desktop ];
    };
  };
}
