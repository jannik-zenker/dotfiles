{ self, ... }:
let
  hub = self.data.wireguardNetwork.hub;
  hubIpv4 = self.data.wireguardNetwork.peers.${hub}.ip4;
in
{
  den.aspects.paperless.nixos = { config, host, ... }: {
    sops.secrets."paperless-admin-pass" = {
      sopsFile = ../../secrets/${host.name}/paperless.yaml;
      owner = "paperless";
      group = "paperless";
      mode = "0400";
    };

    services.paperless = {
      enable = true;
      passwordFile = config.sops.secrets."paperless-admin-pass".path;
      user = "paperless";

      # Bind directly to the WireGuard tunnel address rather than fronting
      # with nginx like the other lumiere services; reachable only over the
      # mesh, never the LAN or public internet.
      address = hubIpv4;
      port = 8000;
      domain = hubIpv4;
      configureNginx = false;

      configureTika = true;
      # Let other users/scripts drop files into the consumption dir for OCR
      # ingestion without needing the paperless group.
      consumptionDirIsPublic = true;

      database.createLocally = true;

      settings = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
      };
    };

    # Reachable only over the WireGuard network, not publicly.
    networking.firewall.interfaces."wg0".allowedTCPPorts = [ 8000 ];
  };
}
