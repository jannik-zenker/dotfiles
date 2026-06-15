{
  den.aspects.helix = {
    homeManager = { pkgs, ... }: {
      programs.helix = {
        enable = true;

        settings = {
          editor = {
            line-number = "absolute";
            lsp.display-messages = true;
            cursor-shape = {
              normal = "block";
              insert = "bar";
            };

            end-of-line-diagnostics = "hint";
          };

          keys.normal = {
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
          };

          theme = "base16_transparent";
        };
      };
    };
  };
}
