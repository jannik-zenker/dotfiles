{
  den.aspects.dolphin = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ dolphin ];
    };
  };
}
