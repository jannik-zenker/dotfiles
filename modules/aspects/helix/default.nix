{
  den.aspects.helix = {
    homeManager = { pkgs, ... }: {
      programs.helix = {
        enable = true;
      };
    };
  };
}
