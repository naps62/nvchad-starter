return {
  -- {
  --   "m4xshen/hardtime.nvim",
  --   lazy = false,
  --   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  --   opts = {
  --     disable_mouse = false,
  --     restricted_keys = {
  --       ["w"] = { "n", "x" },
  --       ["W"] = { "n", "x" },
  --       ["b"] = { "n", "x" },
  --       ["B"] = { "n", "x" },
  --     },
  --   },
  -- },

  {
    "smoka7/hop.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    keys = {
      {
        "ff",
        function()
          local dir = require("hop.hint").HintDirection
          require("hop").hint_char1 { direction = dir.AFTER_CURSOR }
        end,
        desc = "go to char (forward)",
      },
      {
        "FF",
        function()
          local dir = require("hop.hint").HintDirection
          require("hop").hint_char1 { direction = dir.BEFORE_CURSOR }
        end,
        desc = "go to char (backward)",
      },
      { "2ff", "<cmd>HopChar2<cr>", desc = "go to bigram" },
      { "<leader>fl", "<cmd>HopLineStart<cr>" },
      { "<leader>fp", "<cmd>HopPattern<cr>" },
      { "<leader>fw", "<cmd>HopWord<cr>" },
    },
  },

  -- {
  --   "kevinhwang91/nvim-ufo",
  --   dependencies = { "kevinhwang91/promise-async" },
  --   lazy = false,
  --   config = function()
  --     vim.o.foldcolumn = "1" -- '0' is not bad
  --     vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  --     vim.o.foldlevelstart = 99
  --     vim.o.foldenable = true
  --
  --     local capabilities = vim.lsp.protocol.make_client_capabilities()
  --     capabilities.textDocument.foldingRange = {
  --       dynamicRegistration = false,
  --       lineFoldingOnly = true,
  --     }
  --     local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
  --     for _, ls in ipairs(language_servers) do
  --       require("lspconfig")[ls].setup {
  --         capabilities = capabilities,
  --         -- you can add other fields for setting up lsp server in this table
  --       }
  --     end
  --     require("ufo").setup()
  --   end,
  --
  --   keys = {
  --     {
  --       "zR",
  --       function()
  --         require("ufo").openAllFolds()
  --       end,
  --       desc = "Open all folds",
  --     },
  --     {
  --       "zM",
  --       function()
  --         require("ufo").closeAllFolds()
  --       end,
  --       desc = "Close all folds",
  --     },
  --   },
  -- },

  -- {
  --   "tzachar/local-highlight.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("local-highlight").setup()
  --   end,
  -- },
}
