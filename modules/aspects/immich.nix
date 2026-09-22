{ self, ... }:
let
  hub = self.data.wireguardNetwork.hub;
  hubIpv4 = self.data.wireguardNetwork.peers.${hub}.ip4;
in
{
  den.aspects.immich.nixos = {
    services.immich = {
      enable = true;

      # Bind only to the WireGuard tunnel address, not 0.0.0.0: reachable
      # only over the mesh, never the LAN or public internet.
      host = hubIpv4;
      port = 2283;
      openFirewall = false;

      mediaLocation = "/var/lib/immich";

      database = {
        enable = true;
        createDB = true;
        name = "immich";
        user = "immich";
      };

      user = "immich";
      group = "immich";

      machine-learning.enable = true;

      redis.enable = true;

      # Updates are managed via nixpkgs, not Immich's own updater.
      settings.newVersionCheck.enabled = false;
    };

    # Reachable only over the WireGuard network, not publicly.
    networking.firewall.interfaces."wg0".allowedTCPPorts = [ 2283 ];
  };
}
