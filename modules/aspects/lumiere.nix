{ den, lib, ... }:
{
  den.aspects.lumiere = {
    includes = [
      den.aspects.systemdNetworkd
      den.aspects.wireguardPeer
    ];

    nixos =
      {
        config,
        modulesPath,
        ...
      }:
      {
        system.stateVersion = "26.05";

        # Hardware Configuration
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
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

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        # Filesystem configuration with disko
        disko.devices = {
          disk = {
            system = {
              device = "/dev/disk/by-id/nvme-eui.0026b76874b6e5f5";
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
                        "@nix".mountpoint = "/nix";
                        "@varlib".mountpoint = "/var/lib";
                      };
                    };
                  };
                };
              };
            };
          };
        };

        # Systemd-Networkd settings
        systemd.network.networks."10-lan" = {
          matchConfig.Name = "enp1s0";

          networkConfig = {
            DHCP = "ipv4";
            IPv6AcceptRA = true;
          };
        };

        # Wireguard settings
        networking.firewall.allowedUDPPorts = [ 51820 ];

        systemd.network.networks."50-wg0" = {
          address = [
            "10.0.0.1/32"
            "fd00::1/128"
          ];

          wireguardConfig.wireguardPeers = [
            {
              # Reacher
              PublicKey = "a78TwYlxGWx6QZed+RP8i4ulmtaJvV/DR9bKQovqZV8=";
              AllowedIPs = [
                "10.0.0.2/128"
                "fd00::2/128"
              ];
            }
          ];
        };
      };

    # Set home.stateVersion to system.Stateversion since hm is a nixos module
    provides.to-users = {
      homeManager.home.stateVersion = "26.05";
    };
  };
}
