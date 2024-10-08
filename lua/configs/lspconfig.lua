-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "lua_ls", "biome" }
local nvlsp = require "nvchad.configs.lspconfig"

vim.lsp.inlay_hint.enable()

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    inlay_hints = { enable = true },
  }
end
