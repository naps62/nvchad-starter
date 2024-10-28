local lspkind = require "lspkind"

local nvchad_options = require "nvchad.configs.cmp"

local options = {
  sources = {
    -- { name = "supermaven" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "copilot" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },

  formatting = {
    format = lspkind.cmp_format {
      mode = "symbol",
      max_width = 50,
      symbol_map = { Supermaven = "" },
    },
  },
}

return vim.tbl_deep_extend("force", nvchad_options, options)
