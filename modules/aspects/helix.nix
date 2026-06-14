{
  den.aspects.helix = {
    homeManager = { pkgs, ... }: {
      programs.helix = {
        enable = true;

        settings = {
          editor = {
            line-number = "relative";
            lsp.display-messages = true;
            modes.insert.line-number = "absolute";
          };

          keys.normal = {
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
          };

          theme = "base16";

          languages = {
            language-server.nixd = {
              command = "${pkgs.nixd}/bin/nixd";
            };

            language = [
              {
                name = "nix";
                language-servers = [ "nixd" ];
                formatter = {
                  command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
                };
                auto-format = true;
              }
            ];
          };
        };
      };
    };
  };
}
