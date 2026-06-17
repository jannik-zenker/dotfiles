{
  den.aspects.office = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        libreoffice
        slack
        teams-for-linux
      ];
    };
  };
}
