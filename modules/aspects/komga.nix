{ self, ... }:
let
  hub = self.data.wireguardNetwork.hub;
  hubIpv4 = self.data.wireguardNetwork.peers.${hub}.ip4;
in
{
  den.aspects.komga.nixos = {
    services.komga = {
      enable = true;

      # Bind only to the WireGuard tunnel address, not 0.0.0.0: reachable
      # only over the mesh, never the LAN or public internet.
      settings.server = {
        address = hubIpv4;
        port = 8080;
      };
    };

    # Reachable only over the WireGuard network, not publicly.
    networking.firewall.interfaces."wg0".allowedTCPPorts = [ 8080 ];
  };
}
