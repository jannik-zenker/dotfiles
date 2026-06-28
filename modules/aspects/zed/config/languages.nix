{
  den.aspects.zedEditor = {
    homeManager = {
      programs.zed-editor.userSettings = {
        #--- Nix ---#
        languages = {
          Nix = {
            tab_size = 2;
            language_servers = [
              "nixd"
              "!nil"
            ];
            formatter.external = {
              command = "nixfmt";
              arguments = [
                "--quiet"
                "--"
              ];
            };
          };
          #--- LaTeX ---#
          LaTeX = {
            tab_size = 2;
          };
        };
        lsp.texlab.settings.texlab = {
          latexindent.modifyLineBreaks = true;
          build = {
            onSave = true;
            executable = "latexmk";
            args = [
              "-lualatex"
              "-synctex=1"
              "-outdir=build"
              "%f"
            ];
          };
        };
      };
    };
  };
}
