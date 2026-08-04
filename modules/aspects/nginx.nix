{
  den.aspects.nginx = {
    nixos = {
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
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
