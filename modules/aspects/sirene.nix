{ den, self, ... }:
{
  den.aspects.sirene = {
    includes = [
      den.aspects.bluetooth
      den.aspects.documentIo
      den.aspects.fonts
      den.aspects.networkManager
      den.aspects.plymouth
      den.aspects.sddm
      den.aspects.niri
      den.aspects.texlive
      den.aspects.zswap
    ];

    nixos =
      { lib, ... }:
      lib.mkMerge [
        (self.lib.mkStandardDisk {
          device = "/dev/disk/by-id/nvme-eui.fd5b42cebc8f9d54ace42e005215b9f8";
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
              "thunderbolt"
              "nvme"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
            kernelModules = [ "kvm-intel" ];
          };

          hardware.cpu.intel.npu.enable = true;
        }
      ];
  };
}
