{
  den.aspects.nvfConfiguration = { theme, ... }: {
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

      theme = {
        enable = true;
        inherit (theme) name;
        inherit (theme) style;
        inherit (theme) transparent;
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

          # No numbers on buffers
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

      # Show available keybinds interactively
      binds.whichKey.enable = true;

      # Mini plugins
      mini = {
        indentscope.enable = true;
      };

      # Icons
      visuals.nvim-web-devicons.enable = true;

      # VimTeX (for LaTeX support)
      extraPlugins.vimtex = {
        package = pkgs.vimPlugins.vimtex;

        setup = ''
          vim.g.vimtex_view_method = "zathura"
          vim.g.vimtex_view_automatic = 1
          vim.g.vimtex_view_forward_search_on_start = 0

          vim.g.vimtex_compiler_latexmk = {
            aux_dir = "build",
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

          vim.g.vimtex_compiler_latexmk_engines = {
            ["_"] = "-lualatex",
          }
        '';
      };

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
