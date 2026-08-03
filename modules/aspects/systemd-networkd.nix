{
  den.aspects.systemdNetworkd = {
    nixos = {
      networking.useDHCP = false;
      networking.useNetworkd = true;
      systemd.network.enable = true;
      services.resolved.enable = true;
    };
  };
}
