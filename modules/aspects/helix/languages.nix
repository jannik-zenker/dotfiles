{
  den.aspects.helix = {
    homeManager = { pkgs, ... }: {
      programs.helix = {
        languages = {
          language-server.nixd = {
            command = "${pkgs.nixd}/bin/nixd";
          };
          language-server.texlab = {
            command = "${pkgs.texlab}/bin/texlab";
            config.texlab.build = {
              onSave = true;
              executable = "latexmk";
              args = [
                "-lualatex"
                "-interaction=nonstopmode"
                "-synctex=1"
                "-auxdir=build"
                "%f"
              ];
            };
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
            {
              name = "latex";
              language-servers = [ "texlab" ];
              auto-format = true;
            }
          ];
        };
      };
    };
  };
}
