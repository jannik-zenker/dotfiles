{ den, lib, ... }:
{
  den.aspects.reacher = {
    includes = [
      den.aspects.bluetooth
      den.aspects.documentIo
      den.aspects.fonts
      den.aspects.gaming
      den.aspects.networkManager
      den.aspects.plymouth
      den.aspects.sddm
      den.aspects.niri
      den.aspects.texlive
      den.aspects.zswap
    ];

    nixos =
      {
        config,
        modulesPath,
        ...
      }:
      {
        system.stateVersion = "26.11";

        # Hardware Configuration
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
        boot = {
          initrd.availableKernelModules = [
            "xhci_pci"
            "ahci"
            "nvme"
            "usbhid"
          ];
          kernelModules = [ "kvm-intel" ];
        };

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        # Filesystem configuration with disko
        disko.devices = {
          disk = {
            system = {
              device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b46dff49d";
              type = "disk";
              content = {
                type = "gpt";
                partitions = {
                  EFI = {
                    type = "EF00";
                    size = "1G";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0077" ];
                    };
                  };
                  SWAP = {
                    size = "4G";
                    content = {
                      type = "swap";
                    };
                  };
                  NIXOS = {
                    size = "100%";
                    content = {
                      type = "btrfs";
                      subvolumes = {
                        "@root".mountpoint = "/";
                        "@home".mountpoint = "/home";
                        "@nix".mountpoint = "/nix";
                      };
                    };
                  };
                };
              };
            };

            games = {
              device = "/dev/disk/by-id/nvme-eui.00000000000000000026b76866e30415";
              type = "disk";
              content = {
                type = "gpt";
                partitions = {
                  GAMES = {
                    size = "100%";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/games";
                    };
                  };
                };
              };
            };

            misc = {
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
          };
        };

        # Add access to /games drive for "gaming" group
        systemd.tmpfiles.rules = [
          "d /games 0775 root gaming - -"
        ];

        # Add local adress for server to /etc/hosts
        networking.hosts = {
          "192.168.0.2" = [ "cloud.jannikzenker.de" ];
        };
      };

    # Set home.stateVersion to system.Stateversion since hm is a nixos module
    provides.to-users = {
      homeManager.home.stateVersion = "26.11";

      # Provide "gaming" group to users for access to /games drive
      extraGroups = [ "gaming" ];
    };
  };
}
