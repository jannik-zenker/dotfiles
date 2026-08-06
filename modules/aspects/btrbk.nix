{
  den.aspects.btrbk = {
    nixos = {

      services.btrbk.instances.local = {
        onCalendar = null;

        settings = {
          snapshot_preserve = "24h 30d 12m";

          volume."/" = {
            target = "/mnt/backup";
            snapshot_dir = "/snapshots";

            subvolume = {
              "/var/lib/foundry" = { };
              "/var/lib/immich" = { };
              "/var/lib/nextcloud" = { };
              "/var/lib/paperless" = { };
              "/var/lib/postgresql" = { };
            };
          };
        };
      };

      systemd.mounts = [
        {
          what = "/dev/disk/by-id/ata-INTENSO_SSD_AA000000000000000304";
          where = "/mnt/backup";
          type = "btrfs";
          options = "subvol=/";
        }
      ];

      systemd.services.backup-local = {
        description = "Run local backup";

        serviceConfig = {
          Type = "oneshot";
        };

        script = ''
          set -euo pipefail

          cleanup() {
            sync
            systemctl stop mnt-backup.mount
          }

          trap cleanup EXIT

          systemctl start mnt-backup.mount

          sudo -u postgres psql -c "CHECKPOINT;"

          btrbk -c /etc/btrbk/local.conf run
        '';
      };

      systemd.timers.backup-local = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnCalendar = "01:00";
          Persistent = true;
        };
      };
    };
  };
}
