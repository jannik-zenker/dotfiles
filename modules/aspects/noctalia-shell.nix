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

  den.aspects.noctaliaShell = {
    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
      };
    };
  };
}
