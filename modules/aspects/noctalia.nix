{ inputs, ... }:
{
  flake-file = {
    inputs = {
      noctalia = {
        url = "github:noctalia-dev/noctalia";
      };
    };

    nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  den.aspects.noctalia = {
    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
      };
    };
  };
}
