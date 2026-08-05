{
  den.aspects.paperless = {
    nixos = { config, host, ... }: {
      sops.secrets."paperless-admin-pass" = {
        sopsFile = ../../secrets/${host.name}/paperless.yaml;
        owner = "paperless";
        group = "paperless";
        mode = "0400";
      };

      services.paperless = {
        enable = true;
        passwordFile = config.sops.secrets."paperless-admin-pass".path;
        user = "paperless";

        address = "10.0.0.1";
        port = 8000;
        domain = "10.0.0.1";
        configureNginx = false;

        configureTika = true;
        consumptionDirIsPublic = true;

        database.createLocally = true;

        settings = {
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
        };
      };

      networking.firewall.interfaces."wg0".allowedTCPPorts = [ 8000 ];
    };
  };
}
