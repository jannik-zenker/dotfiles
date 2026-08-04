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

        # Double PHP OPcache
        phpOptions = {
          "opcache.interned_strings_buffer" = "16";
        };

        settings = {
          maintenance_window_start = 2;

          trusted_proxies = [
            "173.245.48.0/20"
            "103.21.244.0/22"
            "103.22.200.0/22"
            "103.31.4.0/22"
            "141.101.64.0/18"
            "108.162.192.0/18"
            "190.93.240.0/20"
            "188.114.96.0/20"
            "197.234.240.0/22"
            "198.41.128.0/17"
            "162.158.0.0/15"
            "104.16.0.0/13"
            "104.24.0.0/14"
            "172.64.0.0/13"
            "131.0.72.0/22"

            "2400:cb00::/32"
            "2606:4700::/32"
            "2803:f800::/32"
            "2405:b500::/32"
            "2405:8100::/32"
            "2a06:98c0::/29"
            "2c0f:f248::/32"
          ];
        };

        extraAppsEnable = true;
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps) calendar contacts mail;
        };
      };

      services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}
