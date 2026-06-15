{
  den.aspects.texlive = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ texliveFull ];
    };
  };
}
