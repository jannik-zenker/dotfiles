{
  den.aspects.fzf = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ fzf ];
    };
  };
}
