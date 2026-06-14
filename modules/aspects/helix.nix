{
  den.aspects.helix = {
    homeManager = { pkgs, ... }: {
      programs.helix = {
        enable = true;

        settings = {
          editor = {
            line-number = "absolute";
            lsp.display-messages = true;
          };

          keys.normal = {
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
          };

          theme = "base16";
        };
        languages = {
          language-server.nixd = {
            command = "${pkgs.nixd}/bin/nixd";
          };

          language = [
            {
              name = "nix";
              language-servers = [ "nixd" ];
              formatter = {
                command = "${pkgs.nixfmt}/bin/nixfmt";
              };
              auto-format = true;
            }
          ];
        };

      };
    };
  };
}
