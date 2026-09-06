{ den, self, ... }:
{
  den.aspects.hauler = {
    includes = [
      den.aspects.bluetooth
      den.aspects.documentIo
      den.aspects.fonts
      den.aspects.networkManager
      den.aspects.plymouth
      den.aspects.sddm
      den.aspects.niri
      den.aspects.texlive
      den.aspects.wireguard
      den.aspects.zswap
    ];

    nixos =
      { lib, ... }:
      lib.mkMerge [
        (self.lib.mkStandardDisk {
          device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4c28d80e";
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
              "nvme"
              "xhci_pci"
              "usb_storage"
              "sd_mod"
            ];
            kernelModules = [ "kvm-amd" ];
          };
        }
      ];
  };
}
