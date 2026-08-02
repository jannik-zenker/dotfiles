{
  den.aspects.systemdNetworkd = {
    nixos = {
      networking.useDHCP = false;
      networking.useNetworkd = true;
      systemd.network.enable = true;
      services.resolved.enable = true;

      systemd.network.networks."10-lan" = {
        matchConfig.Name = "lan";

        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
      };
    };
  };
}
