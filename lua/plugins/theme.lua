return {
  {
    "levouh/tint.nvim",
    config = function()
      require("tint").setup {
        tint = -10,
        tint_background_colors = true,

        window_ignore_function = function(winid)
          local bufid = vim.api.nvim_win_get_buf(winid)
          local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufid })
          return buftype == "nofile"
        end,
      }
    end,
  },
  -- { "nvchad/base46", enabled = false },

  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   enabled = false,
  --   lazy = false,
  --   init = function()
  --     vim.cmd.colorscheme "catppuccin-mocha"
  --     require("catppuccin").setup {
  --       native_lsp = {
  --         enabled = true,
  --         virtual_text = {
  --           errors = { "italic" },
  --           hints = { "italic" },
  --           warnings = { "italic" },
  --           information = { "italic" },
  --         },
  --         underlines = {
  --           errors = { "underline" },
  --           hints = { "underline" },
  --           warnings = { "underline" },
  --           information = { "underline" },
  --         },
  --       },
  --     }
  --   end,
  -- },
}
