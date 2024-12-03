return {
  {
    "levouh/tint.nvim",
    event = "VeryLazy",
    config = function()
      vim.api.nvim_set_hl(0, "NormalNC", { link = "Normal" })
      require("tint").setup {
        tint = -20,
        tint_background_colors = true,

        window_ignore_function = function(winid)
          local bufid = vim.api.nvim_win_get_buf(winid)
          local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufid })
          return buftype == "nofile"
        end,
      }
    end,
  },

  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        relculright = true,
        segments = {
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          { sign = { name = { ".*" }, maxwidth = 1, colwidth = 1 }, click = "v:lua.ScSa" },
        },
      }
    end,
  },
}
