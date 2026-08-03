{
  den.aspects.wireguardPeer = {
    nixos = { config, host, ... }: {
      sops.secrets."wireguard/privateKey" = {
        sopsFile = ../../secrets/${host.name}/wireguard.yaml;

        owner = "systemd-network";
        group = "systemd-network";
        mode = "0400";
      };

      networking.useNetworkd = true;

      systemd.network = {
        enable = true;

        networks."50-wg0" = {
          matchConfig.Name = "wg0";
        };

        netdevs."50-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
          };

          wireguardConfig = {
            PrivateKeyFile = config.sops.secrets.wgPrivateKey.path;
            RouteTable = "main";
          };
        };
      };
    };
  };
}
