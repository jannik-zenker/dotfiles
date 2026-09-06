{ den, self, ... }:
{
  den.aspects.reacher = {
    includes = [
      den.aspects.bluetooth
      den.aspects.documentIo
      den.aspects.fonts
      den.aspects.gaming
      den.aspects.networkManager
      #      den.aspects.plymouth
      den.aspects.sddm
      den.aspects.niri
      den.aspects.texlive
      den.aspects.wireguardPeer
      den.aspects.zswap
    ];

    nixos =
      { lib, ... }:
      lib.mkMerge [
        (self.lib.mkStandardDisk {
          device = "/dev/disk/by-id/nvme-eui.00000000000000000026b76866e30415";
          content = {
            type = "btrfs";
            subvolumes = {
              "@root".mountpoint = "/";
              "@home".mountpoint = "/home";
              "@nix".mountpoint = "/nix";
            };
          };
        })
        {
          system.stateVersion = "26.11";

          boot = {
            initrd.availableKernelModules = [
              "xhci_pci"
              "ahci"
              "nvme"
              "usbhid"
            ];
            kernelModules = [
              "kvm-intel"
              "sg"
            ];
          };

          disko.devices.disk.misc = {
            device = "/dev/disk/by-id/wwn-0x5000c500cf89d9bf";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                MISC = {
                  size = "100%";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/misc";
                  };
                };
              };
            };
          };

          # Add access to /games drive for "gaming" group
          systemd.tmpfiles.rules = [
            "d /games 0775 root gaming - -"
          ];
        }
      ];

    # Provide "gaming" group to users for access to /games drive
    provides.to-users.extraGroups = [ "gaming" ];
  };
}
