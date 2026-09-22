{ den, self, ... }: {
  # Host meta-aspect for hauler (a laptop): an includes list of feature
  # aspects, plus this host's own disk layout and hardware specifics below.
  den.aspects.hauler = {
    includes = [
      den.aspects.bluetooth
      den.aspects.documentIo
      den.aspects.fonts
      den.aspects.kde
      den.aspects.networkManager
      den.aspects.plymouth
      den.aspects.plasmaLoginManager
      den.aspects.texlive
      den.aspects.wireguardPeer
      den.aspects.zswap
    ];

    nixos =
      { lib, ... }:
      lib.mkMerge [
        (self.lib.mkStandardDisk {
          device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4c28d80e";
          content = {
            type = "btrfs";
            subvolumes = self.lib.mkSubvolumes {
              "@root" = "/";
              "@home" = "/home";
              "@nix" = "/nix";
            };
          };
        })
        {
          system.stateVersion = "26.11";

          boot = {
            # Needed at initrd time to find the NVMe boot media at all.
            initrd.availableKernelModules = [
              "nvme"
              "xhci_pci"
              "usb_storage"
              "sd_mod"
            ];
            # Hardware virtualization support; hauler's CPU is AMD.
            kernelModules = [ "kvm-amd" ];
          };
        }
      ];
  };
}
