{
  den.aspects.nextcloudClient = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ nextcloud-client ];
    };
  };
}
