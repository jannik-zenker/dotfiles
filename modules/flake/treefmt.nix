# Modified from: https://github.com/MrSom3body/dotfiles
{ inputs, ... }: {
  flake-file.inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = {
    treefmt = {
      programs = {
        nixfmt = {
          enable = true;
          strict = true;
        };
        deadnix.enable = true;
        statix.enable = true;

        prettier.enable = true;
      };

      settings.formatter.prettier.excludes = [
        "secrets/**/*.yaml"
        ".claude/skills/**/skill.md"
        "CLAUDE.md"
      ];
    };
  };
}
