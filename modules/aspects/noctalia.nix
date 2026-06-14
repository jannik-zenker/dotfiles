{ inputs, ... }:
{
  flake-file = {
    inputs = {
      noctalia = {
        url = "github:noctalia-dev/noctalia";
        inputs.nixpkgs.follows = "nixpkgs";
      };
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
