{
  den.aspects.cloudflareDdns = {
    nixos = { config, ... }: {
      # Create user for rootless implementation
      users.groups.cloudflare-ddns = {
        gid = 990;
      };

      users.users.cloudflare-ddns = {
        isSystemUser = true;
        uid = 990;
        group = "cloudflare-ddns";
        linger = true;

        home = "/var/lib/cloudflare-ddns";
        createHome = true;

        subUidRanges = [
          {
            startUid = 100000;
            count = 65536;
          }
        ];

        subGidRanges = [
          {
            startGid = 100000;
            count = 65536;
          }
        ];
      };

      # Get API-Token secret file
      sops.secrets."cloudflare-api-token" = {
        sopsFile = ../../secrets/cloudflare-ddns.yaml;
        owner = "cloudflare-ddns";
        group = "cloudflare-ddns";
        mode = "0400";
      };

      virtualisation.oci-containers = {
        backend = "podman";

        containers.cloudflare-ddns = {
          image = "favonia/cloudflare-ddns:1";

          podman.user = "cloudflare-ddns";

          environment = {
            DOMAINS = "jannikzenker.de,cloud.jannikzenker.de,lumiere.jannikzenker.de";
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
    };
  };
}
