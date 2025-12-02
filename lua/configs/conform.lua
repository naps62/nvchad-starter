local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt", require_cwd = true },
    javascript = { "biome-check", "biome", "biome-organize-imports" },
    typescript = { "biome-check", "biome", "biome-organize-imports" },
    json = { "biome-check", "biome" },
    yaml = { "biome-check" },
    solidity = { "forge_fmt" },
    nix = { "nixfmt" },
    toml = { "taplo" },
    elixir = { "mix" },
    cpp = { "clang-format" },
    kotlin = { "ktlint" },
  },
  formatters = {
    biome = { require_cwd = true },
    rustfmt = {
      args = { "--edition", "2024" },
    },
  },

  format_after_save = function()
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path:find "/contrib/" then
      return nil
    end

    return {
      timeout_ms = 1000,
      lsp_format = "fallback",
    }
  end,
}

return options
