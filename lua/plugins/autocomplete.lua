return {
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require "configs.cmp"
    end,
  },

  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<C-Enter>",
        },
        -- disable_inline_completion = true,
      }
    end,
  },

  { "onsails/lspkind.nvim", event = "VeryLazy" },

  -- {
  -- 	"zbirenbaum/copilot.lua",
  -- 	cmd = "Copilot",
  -- 	event = "VeryLazy",
  -- 	config = function()
  -- 		require("copilot").setup({
  -- 			suggestion = { enabled = false },
  -- 			panel = { enabled = false },
  -- 		})
  -- 	end,
  -- },
  --
  -- {
  -- 	"zbirenbaum/copilot-cmp",
  -- 	event = "VeryLazy",
  -- 	dependencies = { "hrsh7th/cmp-nvim-lsp" },
  -- 	config = function()
  -- 		require("copilot_cmp").setup()
  -- 	end,
  -- },
}
