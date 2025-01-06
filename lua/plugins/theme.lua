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
}
