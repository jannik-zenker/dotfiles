{ self, lib, ... }:
let
  allowedIPsOf = peer: [
    "${peer.ip4}/32"
    "${peer.ip6}/128"
  ];
in
{
  # Merge into a NixOS config to make `name` a fully configured peer of the
  # mesh in `self.data.wireguardNetwork`: its own wg0 address, plus either
  # every other peer (if it is the hub) or just the hub (if it is a spoke).
  # Used from den.aspects.wireguardPeer, e.g.:
  #   self.lib.mkWireguardPeer { name = host.name; }
  config.flake.lib.mkWireguardPeer =
    { name }:
    let
      inherit (self.data.wireguardNetwork) hub peers;
      me = peers.${name};
    in
    {
      systemd.network = {
        networks."50-wg0".address = allowedIPsOf me;

        netdevs."50-wg0".wireguardPeers =
          if name == hub then
            lib.mapAttrsToList (_: peer: {
              PublicKey = peer.publicKey;
              AllowedIPs = allowedIPsOf peer;
            }) (lib.filterAttrs (peerName: _: peerName != hub) peers)
          else
            [
              {
                PublicKey = peers.${hub}.publicKey;
                Endpoint = me.endpoint or "${hub}.jannikzenker.de:51820";
                AllowedIPs = allowedIPsOf peers.${hub};
                PersistentKeepalive = 25;
              }
            ];
      };
    };
}
