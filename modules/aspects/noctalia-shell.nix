{ inputs, ... }:
{
  flake-file = {
    inputs = {
      noctalia = {
        url = "github:noctalia-dev/noctalia/legacy-v4";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  den.aspects.noctaliaShell = {
    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
      };
    };
  };
}
