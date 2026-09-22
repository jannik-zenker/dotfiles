{
  den.aspects.nvfConfiguration = {
    # Language support
    vim = { pkgs, ... }: {
      # latexmk/texlab/latexindent back the compiler/lsp/format config below.
      # zathura is vimtex's configured PDF viewer; pstree/xdotool are vimtex
      # dependencies for focusing the editor window back after viewing.
      extraPackages = with pkgs; [
        pstree
        texlivePackages.latexmk
        texlab
        texlivePackages.latexindent
        xdotool
        zathura
      ];

      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
      };
      lsp = {
        enable = true;
        formatOnSave = true;
        presets.tailwindcss-language-server.enable = true;
      };
      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix = {
          enable = true;
          format.type = [ "nixfmt" ];
        };

        python.enable = true;

        css.enable = true;
        html.enable = true;
        tex = {
          enable = true;

          lsp = {
            enable = true;
            servers = [ "texlab" ];
          };

          format = {
            enable = true;
            type = [ "latexindent" ];
          };
        };
        tsx.enable = true;
        typescript.enable = true;
      };

      extraPlugins.vimtex = {
        package = pkgs.vimPlugins.vimtex;

        setup = ''
          vim.g.vimtex_view_method = "zathura"

          vim.g.vimtex_compiler_latexmk = {
            aux_dir = "build",
            out_dir = ".",
            callback = 1,
            continuous = 1,
            executable = "latexmk",
            options = {
              "-lualatex",
              "-verbose",
              "-file-line-error",
              "-synctex=1",
              "-interaction=nonstopmode",
            },
          }
        '';
      };
    };
  };
}
