{
  den.aspects.nextcloud = {
    nixos = { config, host, ... }: {
      sops.secrets."nextcloud-admin-pass" = {
        sopsFile = ../../secrets/${host.name}/nextcloud.yaml;
        owner = "nextcloud";
        group = "nextcloud";
        mode = "0400";
      };

      services.nextcloud = {
        enable = true;
        hostName = "cloud.jannikzenker.de";
        https = true;
        database.createLocally = true;
        config = {
          dbtype = "pgsql";
          adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
        };
      };

      services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}
