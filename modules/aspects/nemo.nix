{
  den.aspects.nemo = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ nemo ];
    };
  };
}
