local configs = require "configs.lspconfig"

vim.g.rustaceanvim = configs.rustacean

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      configs.defaults()
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
  },

  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup(configs.typescript)
    end,
  },

  -- lazy.nvim
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {}, -- required, even if empty
  },
}
