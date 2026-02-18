return {
  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      local baleia = require "baleia"
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype == "sh" then
            baleia.setup().once(vim.api.nvim_get_current_buf())
          end
        end,
      })
    end,
  },
}
