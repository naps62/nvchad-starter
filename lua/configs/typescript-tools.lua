local nvlsp = require "nvchad.configs.lspconfig"

local options = {
  code_lens = "on",
  expose_as_code_action = {
    "fix_all",
    "add_missing_imports",
    -- "remove_unused",
    -- "remove_unused_imports",
    "organize_imports",
  },
  server = {
    on_attach = function(client, buffer)
      client.server_capabilities.documentFormattingProvider = false
      nvlsp.on_attach(client, buffer)
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  },
}

require("typescript-tools").setup(options)
