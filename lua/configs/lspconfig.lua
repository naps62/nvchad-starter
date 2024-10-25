local M = {}

local nvlsp = require "nvchad.configs.lspconfig"
local map = vim.keymap.set

M.defaults = function()
  -- load defaults i.e lua_lsp
  require("nvchad.configs.lspconfig").defaults()

  local lspconfig = require "lspconfig"
  local servers = { "html", "cssls", "lua_ls", "biome", "solidity_ls_nomicfoundation", "tinymist" }

  vim.lsp.inlay_hint.enable()
  vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded", -- You can also use 'single', 'double', 'solid', etc.
  })

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = M.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
      inlay_hints = { enable = true },
    }
  end
end

M.on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "<leader>rn", require "nvchad.lsp.renamer", opts "NvRenamer")

  map("n", "gd", function()
    require("telescope.builtin").lsp_definitions()
  end, opts "LSP Definitions")
  map("n", "gv", function()
    require("telescope.builtin").lsp_definitions { jump_type = "vsplit" }
  end, opts "LSP Definitions (vertical split)")
  map("n", "gr", function()
    require("telescope.builtin").lsp_references()
  end, opts "LSP References")

  -- map("n", "ga", function()
  --   vim.lsp.buf.code_action { async = true }
  -- end, opts "Code Actions")
end

M.rustacean = {
  server = {
    cmd = function()
      return { "/home/naps62/.cargo/bin/ra-multiplex" }
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
      end

      -- map("n", "ga", function()
      --   vim.cmd.RustLsp "codeAction"
      -- end, opts "Rust Code Actions")
    end,
  },
  tools = {
    float_win_config = {
      border = "rounded",
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      relative = "cursor",
      borderhighlight = "RenamerBorder",
      titlehighlight = "RenamerTitle",
      focusable = true,
    },
  },
}

M.typescript = {
  code_lens = "on",
  expose_as_code_action = "all",
  server = {
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
    end,
  },
}

return M
