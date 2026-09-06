{ den, self, ... }:
{
  den.aspects.lumiere = {
    includes = [
      den.aspects.btrbk
      den.aspects.cloudflareDdns
      den.aspects.foundryVTT
      den.aspects.immich
      den.aspects.jellyfin
      den.aspects.nextcloud
      den.aspects.nginx
      den.aspects.openssh
      den.aspects.paperless
      den.aspects.systemdNetworkd
      den.aspects.wireguardPeer
    ];

    nixos =
      { lib, pkgs, ... }:
      lib.mkMerge [
        (self.lib.mkStandardDisk {
          device = "/dev/disk/by-id/nvme-eui.0026b76874b6e5f5";
          content = {
            type = "btrfs";
            subvolumes = {
              "@root" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@varlib" = {
                mountpoint = "/var/lib";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@snapshots" = {
                mountpoint = "/snapshots";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@varlib/foundry" = {
                mountpoint = "/var/lib/foundry";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@varlib/immich" = {
                mountpoint = "/var/lib/immich";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@varlib/paperless" = {
                mountpoint = "/var/lib/paperless";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@varlib/nextcloud" = {
                mountpoint = "/var/lib/nextcloud";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@varlib/postgresql" = {
                mountpoint = "/var/lib/postgresql";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        })
        {
          environment.systemPackages = with pkgs; [
            ghostty
          ];

          system.stateVersion = "26.05";

          boot = {
            initrd.availableKernelModules = [
              "nvme"
              "xhci_pci"
              "uas"
              "usbhid"
              "sd_mod"
            ];
            kernelModules = [ "kvm-amd" ];
          };

          # allow ssh only via the wireguard interface
          networking.firewall.interfaces.wg0.allowedTCPPorts = [ 22 ];

          services.openssh.listenAddresses = [
            {
              addr = self.data.wireguardNetwork.peers.lumiere.ip4;
              port = 22;
            }
            {
              addr = "[${self.data.wireguardNetwork.peers.lumiere.ip6}]";
              port = 22;
            }
          ];

          systemd.network.networks."10-lan" = {
            matchConfig.Name = "enp1s0";
            # Manually setup ip adress since lumiere is the dhcp server
            address = [
              "192.168.0.2/24"
            ];

            routes = [
              {
                Gateway = "192.168.0.1";
              }
            ];

            networkConfig = {
              DNS = "127.0.0.1";
              IPv6AcceptRA = true;
            };
          };
        }
      ];
  };
}
