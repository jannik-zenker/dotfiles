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
            firewall.allowedUDPPorts = [ 51820 ];
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
