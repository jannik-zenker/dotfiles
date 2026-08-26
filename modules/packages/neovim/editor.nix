{
  den.aspects.nvfConfiguration = { theme, ... }: {
    vim = { pkgs, ... }: {
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

      # Language-specific indentation
      luaConfigRC.indentation = ''
        -- Default indentation for unknown filetypes
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.softtabstop = 4
        vim.opt.expandtab = true


        local indent = vim.api.nvim_create_augroup("indentation", {
          clear = true,
        })

        local function set_indent(filetypes, size, expandtab)
          vim.api.nvim_create_autocmd("FileType", {
            group = indent,
            pattern = filetypes,
            callback = function()
              vim.opt_local.tabstop = size
              vim.opt_local.shiftwidth = size
              vim.opt_local.softtabstop = size
              vim.opt_local.expandtab = expandtab
            end,
          })
        end

        -- 2 spaces

        set_indent({
          -- JavaScript / TypeScript ecosystem
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",

          -- Web
          "html",
          "css",
          "scss",
          "less",

          -- Data / configuration
          "json",
          "jsonc",
          "yaml",

          -- Nix
          "nix",

          -- Lua / StyLua
          "lua",

          -- Shell
          "sh",
          "bash",
          "zsh",

          -- Google-style JVM / native languages
          "java",
          "c",
          "cpp",

        }, 2, true)

        -- 4 spaces

        set_indent({
          -- PEP 8
          "python",

          -- rustfmt / Rust Style Guide
          "rust",

          -- Common .NET convention
          "cs",

        }, 4, true)


        -- Real tabs, width 8

        set_indent({
          -- gofmt uses tabs for indentation
          "go",

          -- Make recipes require real tab characters
          "make",

        }, 8, false)
      '';

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
