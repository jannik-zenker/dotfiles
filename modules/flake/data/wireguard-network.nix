{ ... }:
{
  # Single source of truth for the WireGuard mesh: a hub-and-spoke network
  # where every spoke peers only with the hub (`hub`), and the hub peers
  # with everyone else. Add a device by adding one entry to `peers` below -
  # no existing host needs to change, since both the hub's peer list and
  # each spoke's peer-of-hub entry are derived from this table by
  # `self.lib.mkWireguardPeer`.
  #
  # `endpoint` is how a spoke reaches the hub (e.g. a LAN address when
  # they share a network); omit it to fall back to the hub's public DDNS
  # hostname. `managed = false` marks a peer that isn't a NixOS host built
  # by this flake (e.g. a phone configured by hand in the WireGuard app).
  config.flake.data.wireguardNetwork = {
    hub = "lumiere";

    peers = {
      lumiere = {
        ip4 = "10.0.0.1";
        ip6 = "fd24:be81:dfe9:1::1";
        publicKey = "C4ThvVyYO6lloK4/BH4V9lMlkwodUUqUQ4qLHl0JKAE=";
      };

      reacher = {
        ip4 = "10.0.0.2";
        ip6 = "fd24:be81:dfe9:1::2";
        publicKey = "B3gPKfSf2gozG2MVBiPImClHTaCZnf7KHz3Mi16VTik=";
        endpoint = "192.168.0.2:51820"; # on the same LAN as lumiere
      };

      hauler = {
        ip4 = "10.0.0.3";
        ip6 = "fd24:be81:dfe9:1::3";
        publicKey = "LPaI6fh+Q0yxa0/rOl7j5sGudqnytW3Cnc7SgrvgogQ=";
      };

      pixel10 = {
        ip4 = "10.0.0.4";
        ip6 = "fd24:be81:dfe9:1::4";
        publicKey = "9tLdYR3HsOHTbqM29qyH8UpvyMQmCoxm8kbpA2X8OEk=";
        managed = false;
      };
    };
  };
}
