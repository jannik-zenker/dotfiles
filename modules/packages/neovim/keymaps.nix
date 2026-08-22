{
  den.aspects.nvfConfiguration = {
    vim.keymaps = [
      # Fzf-Lua
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>FzfLua files<CR>";
        desc = "Find files";
      }

      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>FzfLua live_grep<CR>";
        desc = "Live grep";
      }

      # Oil
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
        desc = "Open file manager: Oil";
      }

      # Bufferline navigation
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<CR>";
        desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<CR>";
        desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<S-q>";
        action = "<cmd>bdelete<CR>";
        desc = "Close Buffer";
      }

      # Leap
      {
        mode = "n";
        key = "s";
        action = "function() require('leap').leap({ target_windows = { vim.fn.win_getid() } }) end";
        lua = true;
        desc = "Leap";
      }
    ];
  };
}
