{ self, ... }:
let
  hub = self.data.wireguardNetwork.hub;
  hubIpv4 = self.data.wireguardNetwork.peers.${hub}.ipv4;
in
{
  den.aspects.immich.nixos =
    { config, ... }:
    {
      services.immich = {
        enable = true;

        host = hubIpv4;
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
}
