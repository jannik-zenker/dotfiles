{
  den.aspects.systemdNetworkd = {
    nixos = {
      systemd.network = {
        enable = true;
        networks."10-lan" = {
          matchConfig.Name = "lan";
          networkConfig.DHCP = "ipv4";
        };
      };
    };
  };
}
