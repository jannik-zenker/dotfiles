{
  den.aspects.nvfConfiguration = { theme, ... }: {
    vim = {
      theme = {
        enable = true;
        name = theme.name;
        style = theme.style;
        transparent = theme.transparent;
      };

      # Fuzzy finder
      fzf-lua = {
        enable = true;
        setupOpts.winopts.border = "rounded";
      };

      # File manager
      utility.oil-nvim = {
        enable = true;
        gitStatus.enable = true;
      };

      # Statusline: lualine
      statusline.lualine.enable = true;

      # Autocompletion
      autocomplete.nvim-cmp.enable = true;

      # Motions
      utility.motion.leap.enable = true;

      # Bufferline
      tabline.nvimBufferline = {
        enable = true;

        setupOpts.options = {
          # Slanted tabs
          separator_style = "slant";

          # No underline indicator
          indicator.style = "none";

          # Show LSP diagnostics in bufferline
          diagnostics = "nvim_lsp";

          # Turn on numbers on buffers
          numbers = "none";

          # Only show close icons on hover
          hover = {
            enabled = true;
            delay = 200;
            reveal = [ "close" ];
          };
        };
      };

      # Modern command line
      ui.noice.enable = true;

      # Mini plugins
      mini = {
        indentscope.enable = true;
      };

      # Icons
      visuals.nvim-web-devicons.enable = true;

      # Diagnostics
      diagnostics = {
        enable = true;

        config = {
          virtual_text = true;
          virtual_lines = false;
        };
      };

      luaConfigRC.diagnosticVirtualLines = ''
        local function update_virtual_lines()
          vim.diagnostic.config({
            virtual_text = true,
            virtual_lines = {
              current_line = true,
            },
          })
        end

        vim.api.nvim_create_autocmd(
          { "CursorMoved", "CursorMovedI", "DiagnosticChanged", "BufEnter" },
          {
            callback = update_virtual_lines,
          }
        )

        update_virtual_lines()
      '';
    };
  };
}
