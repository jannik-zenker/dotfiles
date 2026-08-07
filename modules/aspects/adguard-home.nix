{
  den.aspects.adguardHome = {
    nixos = { pkgs, ... }: {
      services.adguardhome = {
        enable = true;
        host = "10.0.0.1";
        port = 3000;
        settings = {
          dhcp = {
            enabled = true;
            interface_name = "enp1s0";

            dhcpv4 = {
              gateway_ip = "192.168.0.1";
              subnet_mask = "255.255.255.0";
              range_start = "192.168.0.53";
              range_end = "192.168.0.253";

              lease_duration = 86401; # 1 Tag bis Adressen erneuert werden
            };
          };

          dns = {
            bind_hosts = [
              "192.168.0.2"
            ];

            upstream_dns = [
              "tls://dns.quad9.net"
            ];
          };

          filtering = {
            protection_enabled = true;
            filtering_enabled = true;

            parental_enabled = false; # Parental control-based DNS requests filtering.
            safe_search = {
              enabled = false; # Enforcing "Safe search" option for search engines, when possible.
            };

            rewrites_enabled = true;
            rewrites = [
              {
                enabled = true;
                domain = "jannikzenker.de";
                answer = "192.168.0.2";
              }
              {
                enabled = true;
                domain = "cloud.jannikzenker.de";
                answer = "192.168.0.2";
              }
              {
                enabled = true;
                domain = "foundry.jannikzenker.de";
                answer = "192.168.0.2";
              }
              {
                enabled = true;
                domain = "lumiere.jannikzenker.de";
                answer = "192.168.0.2";
              }
            ];
          };
          filters =
            map
              (url: {
                enabled = true;
                url = url;
              })
              [
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
                "https://small.oisd.nl" # adblock
              ];
        };
      };

      networking.firewall.interfaces."enp1s0".allowedTCPPorts = [ 53 ];
      networking.firewall.interfaces."enp1s0".allowedUDPPorts = [ 53 ];

      networking.firewall.interfaces."wg0".allowedTCPPorts = [ 3000 ];

      systemd.services.adguardhome.path = [ pkgs.iproute2 ];
    };
  };
}
