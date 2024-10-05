return {
  {
  	"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
  	opts = {
  		ensure_installed = {
  			"vim",
        "lua",
        "vimdoc",
        "html",
        "css",
				"rust",
				"regex",
				"javascript",
				"typescript",
				"tsx",
				"solidity",
				"toml",
				"bash",
				"markdown",
				"markdown_inline",
				"json",
				"elixir",
				"erlang",
				"eex",
				"kdl",
				"yuck",
				"sql",
        "typst"
  		},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				select = { enable = true },
			},
  	},
  },
}
