local nvchad_options = require "nvchad.configs.nvimtree"

local options = {
  renderer = {
    icons = {
      git_placement = "after",
    },
  },
}

return vim.tbl_deep_extend("force", nvchad_options, options)
