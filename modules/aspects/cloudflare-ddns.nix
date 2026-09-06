{ self, ... }:
{
  den.aspects.cloudflareDdns = {
    nixos =
      { config, host, lib, ... }:
      lib.mkMerge [
        (self.lib.mkRootlessContainerUser {
          name = "cloudflare-ddns";
          id = 990;
          subIdStart = 100000;
        })
        {
          # Get API-Token secret file
          sops.secrets."cloudflare-api-token" = {
            sopsFile = ../../secrets/${host.name}/cloudflare-ddns.yaml;
            owner = "cloudflare-ddns";
            group = "cloudflare-ddns";
            mode = "0400";
          };

          virtualisation.oci-containers = {
            backend = "podman";

            containers.cloudflare-ddns = {
              image = "favonia/cloudflare-ddns:1";
              pull = "newer";

              podman.user = "cloudflare-ddns";

              environment = {
                DOMAINS = "jannikzenker.de,cloud.jannikzenker.de,foundry.jannikzenker.de,jellyfin.jannikzenker.de,lumiere.jannikzenker.de";
              };

              environmentFiles = [
                config.sops.secrets."cloudflare-api-token".path
              ];

              extraOptions = [
                "--cap-drop=all"
                "--security-opt=no-new-privileges:true"
              ];

              autoStart = true;
            };
          };
        }
      ];
  };
}
