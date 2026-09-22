{
  den.aspects.btrbk.nixos = { pkgs, ... }: {

    services.btrbk.instances.local = {
      # Disable btrbk's own timer; backup-local (below) drives it instead so
      # the backup disk can be mounted and postgresql stopped around the run.
      onCalendar = null;

      settings = {
        snapshot_preserve = "24h 30d 12m";

        volume."/" = {
          target = "/mnt/backup";
          snapshot_dir = "/snapshots";

          subvolume = {
            "/var/lib/booklore" = { };
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
        what = "/dev/disk/by-id/ata-INTENSO_SSD_AA000000000000000304-part1";
        where = "/mnt/backup";
        type = "btrfs";
        options = "subvol=/";
      }
    ];

    systemd.services.backup-local = {
      description = "Run local backup";

      path = with pkgs; [
        sudo
        systemd
        postgresql
        btrbk
        coreutils
      ];

      serviceConfig = {
        Type = "oneshot";
        # Only keep the backup disk mounted for the duration of the run.
        ExecStopPost = "${pkgs.systemd}/bin/systemctl stop mnt-backup.mount";
      };

      script = ''
        set -euo pipefail

        systemctl start mnt-backup.mount

        # Stop postgresql so its data files are quiescent for the snapshot,
        # then always restart it afterwards even if btrbk fails.
        trap 'systemctl start postgresql.service || true' EXIT

        systemctl stop postgresql.service

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
}
