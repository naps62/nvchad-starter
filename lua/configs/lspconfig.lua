local M = {}

local nvlsp = require "nvchad.configs.lspconfig"
local map = vim.keymap.set

M.defaults = function()
  -- load defaults i.e lua_lsp
  require("nvchad.configs.lspconfig").defaults()

  vim.lsp.inlay_hint.enable()

  vim.lsp.config("biome", {
    cmd = {
      -- prefer local binary if exists
      vim.fn.filereadable "./node_modules/.bin/biome" == 1 and "./node_modules/.bin/biome" or "biome",
      "lsp-proxy",
    },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
    root_dir = vim.fs.root(0, { "biome.json", "biome.jsonc", "biome.config.ts", "package.json", ".git" }),
    settings = {}, -- add Biome-specific settings if needed
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(client, _bufnr)
      -- disable formatting if you want Conform or another tool to handle formatting
      client.server_capabilities.documentFormattingProvider = false
    end,
  })
  vim.lsp.enable "biome"

  vim.lsp.config("lua_ls", {
    on_attach = M.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    inlay_hints = { enable = true },
  })
  vim.lsp.enable "lua_ls"

  vim.lsp.config("wgsl-analyzer", {
    on_attach = M.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    inlay_hints = { enable = true },
  })
  vim.lsp.enable "wgsl-analyzer"

  vim.lsp.config("solidity_ls_nomicfoundation", {
    on_attach = M.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    inlay_hints = { enable = true },
  })
  vim.lsp.enable "solidity_ls_nomicfoundation"

  vim.diagnostic.config {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    virtual_text = false,
    float = {
      focusable = false,
      style = "minimal",
      border = "single",
      header = "",
      prefix = "",
      suffix = "",
    },
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
    -- on_init = nvlsp.on_init,
    -- capabilities = nvlsp.capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
        checkOnSave = true,
        cargo = {
          targetDir = true,
          -- extraArgs = { "--edition=2024" },
        },
        diagnostics = {
          disabled = { "inactive-code", "macro-error" },
        },
      },
    },
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      map("n", "ga", function()
        vim.cmd.RustLsp "codeAction"
      end, { buffer = bufnr })
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
  -- handlers = {
  --   ["textDocument/publishDiagnostics"] = vim.diagnostic.config { virtual_text = false },
  -- },
}

return M
