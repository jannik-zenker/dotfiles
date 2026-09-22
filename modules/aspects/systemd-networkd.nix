{
  # wireguardPeer hosts already get useNetworkd/systemd.network for the wg0
  # interface on its own; this aspect is for hosts that need the rest of
  # their networking (a statically-addressed LAN interface, e.g.) fully on
  # systemd-networkd too, hence also disabling classic DHCP and enabling
  # resolved.
  den.aspects.systemdNetworkd.nixos = {
    networking.useDHCP = false;
    networking.useNetworkd = true;
    systemd.network.enable = true;
    services.resolved.enable = true;
  };
}
