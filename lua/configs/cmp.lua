local lspkind = require "lspkind"

local nvchad_options = require "nvchad.configs.cmp"

local options = {
  -- Supermaven handles AI completion inline (ghost text, accept with <C-Enter>);
  -- it is not a cmp source, so it is intentionally absent here.
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },

  formatting = {
    format = lspkind.cmp_format {
      mode = "symbol",
      max_width = 50,
    },
  },
}

return vim.tbl_deep_extend("force", nvchad_options, options)
