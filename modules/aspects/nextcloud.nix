{ self, den, ... }: {
  den.aspects.nextcloud.nixos = { config, pkgs, ... }: {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud35;
      hostName = "cloud.jannikzenker.de";
      https = true;
      database.createLocally = true;
      config.dbtype = "pgsql";

      # Double PHP OPcache
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
      };

      settings = {
        maintenance_window_start = 2;
        trusted_proxies = self.data.cloudflareIpRanges.ipv4 ++ self.data.cloudflareIpRanges.ipv6;
      };
      extraAppsEnable = true;
      extraApps = { inherit (config.services.nextcloud.package.packages.apps) calendar contacts mail; };
    };

    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      enableACME = true;
      forceSSL = true;
    };
  };

  den.aspects.nextcloud.includes = [ den.aspects.nginx ];
}
