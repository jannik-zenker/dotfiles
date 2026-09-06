{ self, ... }:
{
  den.aspects.booklore = {
    nixos =
      {
        config,
        host,
        lib,
        ...
      }:
      lib.mkMerge [
        (self.lib.mkRootlessContainerUser {
          name = "booklore";
          id = 301;
          subIdStart = 231072;
        })
        {
          # Populate with:
          #   booklore-db-password:            "DATABASE_PASSWORD=<password>"
          #   booklore-mariadb-password:       "MYSQL_PASSWORD=<same password as above>"
          #   booklore-mariadb-root-password:  "MYSQL_ROOT_PASSWORD=<root password>"
          sops.secrets."booklore-db-password" = {
            sopsFile = ../../secrets/${host.name}/booklore.yaml;
            owner = "booklore";
            group = "booklore";
            mode = "0400";
          };

          sops.secrets."booklore-mariadb-password" = {
            sopsFile = ../../secrets/${host.name}/booklore.yaml;
            owner = "booklore";
            group = "booklore";
            mode = "0400";
          };

          sops.secrets."booklore-mariadb-root-password" = {
            sopsFile = ../../secrets/${host.name}/booklore.yaml;
            owner = "booklore";
            group = "booklore";
            mode = "0400";
          };

          virtualisation.oci-containers = {
            backend = "podman";

            containers.booklore-mariadb = {
              image = "lscr.io/linuxserver/mariadb:11.4.5";
              pull = "newer";
              hostname = "podman-booklore-mariadb";

              # Podman itself still runs rootless as the booklore host user.
              podman.user = "booklore";

              volumes = [
                "${config.users.users.booklore.home}/mariadb/config:/config"
              ];

              environment = {
                # MariaDB ultimately runs as UID/GID 301. With keep-id this
                # maps directly to the booklore user on the host.
                PUID = "0";
                PGID = "0";

                TZ = config.time.timeZone;
                MYSQL_DATABASE = "booklore";
                MYSQL_USER = "booklore";
              };

              environmentFiles = [
                config.sops.secrets."booklore-mariadb-password".path
                config.sops.secrets."booklore-mariadb-root-password".path
              ];

              extraOptions = [
                # Capabilities required by the linuxserver MariaDB image.
                "--cap-drop=all"
                "--cap-add=CHOWN"
                "--cap-add=SETUID"
                "--cap-add=SETGID"
                "--cap-add=FOWNER"

                "--security-opt=no-new-privileges:true"
                "--replace"
                "--network=host"
              ];

              autoStart = true;
            };

            containers.booklore = {
              image = "ghcr.io/booklore-app/booklore:latest";
              pull = "newer";
              hostname = "podman-booklore";

              # Podman itself still runs rootless as the booklore host user.
              podman.user = "booklore";

              dependsOn = [ "booklore-mariadb" ];

              volumes = [
                "${config.users.users.booklore.home}/data:/app/data"
                "${config.users.users.booklore.home}/books:/books"
                "${config.users.users.booklore.home}/bookdrop:/bookdrop"
              ];

              environment = {
                # BookLore's entrypoint switches to this UID/GID after
                # initialization. keep-id maps 301 -> host UID/GID 301.
                USER_ID = "0";
                GROUP_ID = "0";

                TZ = config.time.timeZone;

                DATABASE_URL = "jdbc:mariadb://127.0.0.1:3306/booklore";
                DATABASE_USERNAME = "booklore";

                DISK_TYPE = "LOCAL";
              };

              environmentFiles = [
                config.sops.secrets."booklore-db-password".path
              ];

              extraOptions = [
                "--security-opt=no-new-privileges:true"
                "--replace"
                "--network=host"
              ];

              autoStart = true;
            };
          };

          # Reachable only over the WireGuard network, not publicly.
          networking.firewall.interfaces."wg0".allowedTCPPorts = [ 6060 ];
        }
      ];
  };
}
