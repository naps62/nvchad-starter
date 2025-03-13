local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "biome" },
    typescript = { "biome" },
    yaml = { "biome" },
    solidity = { "forge_fmt" },
    nix = { "nixfmt" },
    toml = { "taplo" },
    typst = { "typstyle" },
    csharp = { "csharpier" },
  },
  formatters = {
    biome = { require_cwd = true },
  },

  format_on_save = function()
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path:find "/contrib/" then
      return nil
    end

    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
}

return options
