return {
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      require "configs.cmp"
    end,
  },

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
