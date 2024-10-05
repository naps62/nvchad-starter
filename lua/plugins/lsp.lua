return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
