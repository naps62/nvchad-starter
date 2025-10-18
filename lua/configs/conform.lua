local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt", require_cwd = true },
    javascript = { "biome-check" },
    typescript = { "biome-check", "biome", "biome-organize-imports" },
    yaml = { "biome-check" },
    solidity = { "forge_fmt" },
    nix = { "nixfmt" },
    toml = { "taplo" },
    typst = { "typstyle" },
    csharp = { "csharpier" },
    elixir = { "mix" },
    cpp = { "clang-format" },
  },
  formatters = {
    biome = { require_cwd = true },
    rustfmt = {
      args = { "--edition", "2024" },
    },
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
