{ den, lib, ... }:
{
  den.aspects.lumiere = {
    includes = [
      den.aspects.cloudflareDdns
      den.aspects.foundryVTT
      den.aspects.immich
      den.aspects.nextcloud
      den.aspects.nginx
      den.aspects.openssh
      den.aspects.paperless
      den.aspects.systemdNetworkd
      den.aspects.wireguardPeer
    ];

    nixos =
      {
        config,
        modulesPath,
        pkgs,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          ghostty
        ];

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
                  };
                };
              };
            };
          };
        };

        # Wireguard & Networkd settings
        networking.firewall = {
          allowedUDPPorts = [ 51820 ];
          interfaces.wg0.allowedTCPPorts = [ 22 ]; # allow ssh only via wireguard interface
        };

        services.openssh.listenAddresses = [
          {
            addr = "10.0.0.1";
            port = 22;
          }
          {
            addr = "[fd24:be81:dfe9:1::1]";
            port = 22;
          }
        ];

        systemd.network = {
          networks = {
            "10-lan" = {
              matchConfig.Name = "enp1s0";
              networkConfig = {
                DHCP = "ipv4";
                IPv6AcceptRA = true;
              };
            };

            "50-wg0" = {
              address = [
                "10.0.0.1/32"
                "fd24:be81:dfe9:1::1/128"
              ];
            };
          };

          netdevs."50-wg0".wireguardPeers = [
            {
              # Reacher
              PublicKey = "a78TwYlxGWx6QZed+RP8i4ulmtaJvV/DR9bKQovqZV8=";
              AllowedIPs = [
                "10.0.0.2/32"
                "fd24:be81:dfe9:1::2/128"
              ];
            }
            {
              # Pixel 10
              PublicKey = "9tLdYR3HsOHTbqM29qyH8UpvyMQmCoxm8kbpA2X8OEk=";
              AllowedIPs = [
                "10.0.0.4/32"
                "fd24:be81:dfe9:1::4/128"
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
