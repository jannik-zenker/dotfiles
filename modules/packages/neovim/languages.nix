{
  den.aspects.nvfConfiguration = {
    # Language support
    vim = {
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
        tsx.enable = true;
        typescript.enable = true;
      };
    };
  };
}
