local M = {}

local nvlsp = require "nvchad.configs.lspconfig"
local map = vim.keymap.set

M.defaults = function()
  -- load defaults i.e lua_lsp
  require("nvchad.configs.lspconfig").defaults()

  local lspconfig = vim.lsp.config
  local servers = { "html", "lua_ls", "biome", "solidity_ls_nomicfoundation", "tinymist" }

  vim.lsp.inlay_hint.enable()
  -- vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.handlers.code_action
  --   border = "rounded", -- You can also use 'single', 'double', 'solid', etc.
  -- })
  -- vim.diagnostic.config { virtual_text = true }
  -- vim.lsp.handlers["textDocument/publishDiagnostics"] =
  --   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

  for _, lsp in ipairs(servers) do
    lspconfig(lsp, {
      on_attach = M.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
      inlay_hints = { enable = true },
    })
  end

  vim.diagnostic.config {
    virtual_text = false,
  }
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
end

M.rustacean = {
  server = {
    -- cmd = function()
    --   return { "ra-multiplex" }
    -- end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
        checkOnSave = true,
        cargo = {
          targetDir = true,
          extraArgs = { "--edition=2024" },
        },
        diagnostics = {
          disabled = { "inactive-code", "macro-error" },
        },
      },
    },
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
      end

      map("n", "ga", function()
        vim.cmd.RustLsp "codeAction"
      end, opts "Rust Code Actions")
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
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.diagnostic.config { virtual_text = false },
  },
}

return M
