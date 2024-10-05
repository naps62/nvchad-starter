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

  {"pmizio/typescript-tools.nvim",dependencies={"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}, config=function()
    require "configs.typescript-tools"
  end}
}
