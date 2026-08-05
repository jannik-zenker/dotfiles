{
  den.aspects.foundryVTT = {
    nixos = { config, host, ... }: {
      users.groups.foundry = {
        gid = 300;
      };

      users.users.foundry = {
        isSystemUser = true;
        uid = 300;
        group = "foundry";
        linger = true;

        home = "/var/lib/foundry";
        createHome = true;

        subUidRanges = [
          {
            startUid = 165536;
            count = 65536;
          }
        ];

        subGidRanges = [
          {
            startGid = 165536;
            count = 65536;
          }
        ];
      };

      # Get username and password from secret file
      sops.secrets."foundry-username" = {
        sopsFile = ../../secrets/${host.name}/foundry.yaml;
        owner = "foundry";
        group = "foundry";
        mode = "0400";
      };

      sops.secrets."foundry-password" = {
        sopsFile = ../../secrets/${host.name}/foundry.yaml;
        owner = "foundry";
        group = "foundry";
        mode = "0400";
      };

      sops.secrets."foundry-admin-key" = {
        sopsFile = ../../secrets/${host.name}/foundry.yaml;
        owner = "foundry";
        group = "foundry";
        mode = "0400";
      };

      virtualisation.oci-containers = {
        backend = "podman";

        containers.foundry = {
          image = "ghcr.io/felddy/foundryvtt:14";
          hostname = "podman-foundry";
          podman.user = "foundry";

          volumes = [ "${config.users.users.foundry.home}:/data:U" ];

          environment = {
            CONTAINER_CACHE = "/data/container_cache";
            CONTAINER_CACHE_SIZE = "3";
            CONTAINER_PRESERVE_CONFIG = "true";
            CONTAINER_VERBOSE = "false";
            FOUNDRY_COMPRESS_WEBSOCKET = "true";
            FOUNDRY_CSS_THEME = "fantasy";

            FOUNDRY_HOSTNAME = "foundry.jannikzenker.de";

            FOUNDRY_HOT_RELOAD = "false"; # Only recommended for developers
            FOUNDRY_IP_DISCOVERY = "false";
            FOUNDRY_LANGUAGE = "en.core";

            FOUNDRY_LOG_SIZE = "64m";
            FOUNDRY_MAX_LOGS = "7";

            FOUNDRY_MINIFY_STATIC_FILES = "true";
            FOUNDRY_NO_BACKUPS = "true"; # since the server does external backups
            FOUNDRY_PROXY_PORT = "443";
            FOUNDRY_PROXY_SSL = "true";

            FOUNDRY_TELEMETRY = "true";
          };

          environmentFiles = [
            config.sops.secrets."foundry-username".path
            config.sops.secrets."foundry-password".path
            config.sops.secrets."foundry-admin-key".path
          ];

          ports = [
            "127.0.0.1:30000:30000"
            "[::1]:30000:30000"
          ];

          extraOptions = [
            "--cap-drop=all"
            "--security-opt=no-new-privileges:true"
            "--replace"
          ];

          autoStart = true;
        };
      };

      services.nginx.virtualHosts."foundry.jannikzenker.de" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:30000";
          proxyWebsockets = true;
        };
      };
    };
  };
}

So?
