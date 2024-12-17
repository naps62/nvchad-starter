local nvchad_options = require "nvchad.configs.nvimtree"

local options = {
  renderer = {
    icons = {
      git_placement = "after",
    },
  },
  on_attach = function(bufnr)
    vim.keymap.del("n", "<C-e>", { buffer = bufnr })
  end,
}

return vim.tbl_deep_extend("force", nvchad_options, options)
