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

      # secrets/**/*.yaml: sops-encrypted files aren't meaningfully
      # YAML-structured content — reformatting would just churn the diff.
      # SKILL.md / CLAUDE.md: prettier's markdown reflow (e.g. prose wrap)
      # would rewrite frontmatter and instruction text that must stay intact
      # for skill discovery and Claude's own instruction parsing.
      settings.formatter.prettier.excludes = [
        "secrets/**/*.yaml"
        ".claude/skills/**/SKILL.md"
        "CLAUDE.md"
      ];
    };
  };
}
