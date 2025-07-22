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

  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- optional picker via telescope
      { "nvim-telescope/telescope.nvim" },
      -- optional picker via fzf-lua
      -- { "ibhagwan/fzf-lua" },
      -- .. or via snacks
      -- { "folke/snacks.nvim", opts = { terminal = {} } },
    },
    event = "LspAttach",
    opts = {
      picker = { backend = "delta", "buffer", opts = { hotkeys = true, auto_accept = true } },
    },
    keys = {
      {
        "ga",
        function()
          require("tiny-code-action").code_action()
        end,
      },
    },
  },

  -- {
  --   "aznhe21/actions-preview.nvim",
  --   config = function()
  --     local hl = require "actions-preview.highlight"
  --     require("actions-preview").setup {
  --       backend = { "nui" },
  --       highlight_command = { hl.delta() },
  --
  --       nui = {
  --         keymap = { "q", "<C-c>" },
  --       },
  --     }
  --   end,
  --   keys = {
  --     {
  --       "ga",
  --       function()
  --         require("actions-preview").code_actions()
  --       end,
  --     },
  --   },
  -- },
}
