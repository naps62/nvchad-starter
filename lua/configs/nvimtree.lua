local nvchad_options = require "nvchad.configs.nvimtree"
local api = require "nvim-tree.api"

local options = {
  renderer = {
    icons = {
      git_placement = "after",
    },
  },
  on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del("n", "<C-e>", { buffer = bufnr })
  end,
}

return vim.tbl_deep_extend("force", nvchad_options, options)
