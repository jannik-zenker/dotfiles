{ self, lib, ... }: {
  den.aspects.nginx = {
    nixos = {
      services.nginx = {
        enable = true;

        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;

        commonHttpConfig =
          let
            inherit (self.data.cloudflareIpRanges) ipv4 ipv6;
            setRealIpFrom = lib.concatMapStringsSep "\n" (range: "set_real_ip_from ${range};");
          in
          ''
            real_ip_header CF-Connecting-IP;
            real_ip_recursive on;

            # Cloudflare IPv4
            ${setRealIpFrom ipv4}

            # Cloudflare IPv6
            ${setRealIpFrom ipv6}
          '';
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "kontakt@jannikzenker.de";
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
