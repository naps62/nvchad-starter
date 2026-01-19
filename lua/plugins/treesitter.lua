return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "c_sharp",
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
        "heex",
        "kdl",
        "yuck",
        "sql",
        "typst",
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
      highlight = { enable = true },
      textobjects = {
        lsp_interop = {
          enable = true,
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@function.outer",
            ["ic"] = "@function.inner",
            ["ae"] = "@block.outer",
            ["ie"] = "@block.inner",
            ["as"] = "@statement.outer",
            ["is"] = "@statement.inner",
            ["am"] = "@call.outer",
            ["im"] = "@call.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
          },
        },
      },
    },
  },

  {
    "davidmh/mdx.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
