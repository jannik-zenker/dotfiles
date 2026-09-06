{ self, ... }:
{
  den.aspects.wireguardPeer = {
    nixos =
      { config, host, lib, ... }:
      lib.mkMerge [
        (self.lib.mkWireguardPeer { name = host.name; })
        {
          sops.secrets."wireguard/privateKey" = {
            sopsFile = ../../secrets/${host.name}/wireguard.yaml;

            owner = "systemd-network";
            group = "systemd-network";
            mode = "0400";
          };

          networking = {
            useNetworkd = true;

            # Only the hub is ever dialed - spokes have no configured
            # Endpoint on the hub's side, so the hub can't initiate to
            # them, and a spoke's own reply traffic on a flow it started
            # is already allowed by firewall connection tracking without
            # opening this port.
            firewall.allowedUDPPorts = lib.optional (
              host.name == self.data.wireguardNetwork.hub
            ) 51820;
          };

          systemd.network = {
            enable = true;

            networks."50-wg0".matchConfig.Name = "wg0";

            netdevs."50-wg0" = {
              netdevConfig = {
                Kind = "wireguard";
                Name = "wg0";
              };

              wireguardConfig = {
                ListenPort = 51820;
                PrivateKeyFile = config.sops.secrets."wireguard/privateKey".path;
                RouteTable = "main";
              };
            };
          };
        }
      ];
  };
}
