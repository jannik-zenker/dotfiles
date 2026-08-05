{
  den.aspects.immich = {
    nixos = {
      services.immich = {
        enable = true;

        host = "10.0.0.1";
        port = 2283;
        openFirewall = false;

        mediaLocation = "/var/lib/immich";

        database = {
          enable = true;
          createDB = true;
          name = "immich";
          user = "immich";
        };

        user = "immich";
        group = "immich";

        machine-learning.enable = true;

        redis.enable = true;

        settings.newVersionCheck.enabled = false;
      };

      networking.firewall.interfaces."wg0".allowedTCPPorts = [ 2283 ];
    };
  };
}
