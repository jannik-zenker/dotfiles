{
  den.aspects.nvfConfiguration = {
    # Language support
    vim = {
      lsp = {
        enable = true;
        formatOnSave = true;
      };
      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix = {
          enable = true;
          format.type = [ "nixfmt" ];
        };
        python.enable = true;
      };

      luaConfigRC.nixIndent = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "nix",
          callback = function()
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.expandtab = true
          end,
        })
      '';

      luaConfigRC.pythonIndent = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "python",
          callback = function()
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.expandtab = true
          end,
        })
      '';
    };
  };
}
