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
          # Single-node deployment: garbage collection, database and API all
          # run in this one process, so no separate services to wire up.
          mode = "monolithic";

          user = "atticd";
          group = "atticd";

          environmentFile = config.sops.secrets."attic.env".path;
        };

        services.nginx.virtualHosts.${cacheDomain} = {
          enableACME = true;
          forceSSL = true;

          # Nix store paths pushed to the cache can exceed nginx's default
          # 1M body-size limit; disable the limit entirely.
          extraConfig = ''
            client_max_body_size 0;
          '';

          locations."/" = {
            proxyPass = "http://127.0.0.1:8081";
            proxyWebsockets = true;
          };
        };
      };

    # Pulls in nginx's shared enable/ACME/firewall baseline so the
    # virtualHost above just works, instead of repeating it here.
    includes = [ den.aspects.nginx ];
  };
}
