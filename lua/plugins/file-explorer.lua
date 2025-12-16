return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "echasnovski/mini.files",
    version = false,
    lazy = false,
    config = function()
      require("mini.files").setup {
        mappings = {
          close = "q",
          go_in = "l",
          go_in_plus = "<CR>",
          go_out = "h",
          go_out_plus = "H",
          reset = "<BS>",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "=",
          trim_left = "<",
          trim_right = ">",
        },
        windows = {
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 50,
        },
        options = {
          use_as_default_explorer = true,
        },
      }

      local map = vim.keymap.set
      map("n", "<leader>e", function()
        local MiniFiles = require "mini.files"
        if not MiniFiles.close() then
          MiniFiles.open(vim.api.nvim_buf_get_name(0))
        end
      end, { desc = "File explorer (current file)" })

      map("n", "<leader>E", function()
        local MiniFiles = require "mini.files"
        if not MiniFiles.close() then
          MiniFiles.open(vim.uv.cwd())
        end
      end, { desc = "File explorer (cwd)" })
    end,
  },
}
