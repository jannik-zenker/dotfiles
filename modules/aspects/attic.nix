{ den, ... }: {
  den.aspects.attic = {
    nixos =
      {
        config,
        host,
        pkgs,
        ...
      }:
      let
        cacheDomain = "cache.jannikzenker.de";
      in
      {
        environment.systemPackages = [ pkgs.attic-server ];

        sops.secrets."attic.env" = {
          sopsFile = ../../secrets/${host.name}/attic.env;
          format = "dotenv";
          key = "";
          mode = "0400";
        };

        services.atticd = {
          enable = true;
          settings.listen = "127.0.0.1:8081";
          mode = "monolithic";

          user = "atticd";
          group = "atticd";

          environmentFile = config.sops.secrets."attic.env".path;
        };

        services.nginx.virtualHosts.${cacheDomain} = {
          enableACME = true;
          forceSSL = true;

          extraConfig = ''
            client_max_body_size 0;
          '';

          locations."/" = {
            proxyPass = "http://127.0.0.1:8081";
            proxyWebsockets = true;
          };
        };
      };

    includes = [ den.aspects.nginx ];
  };
}
