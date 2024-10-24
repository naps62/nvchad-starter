return {
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    dependencies = "kyazdani42/nvim-web-devicons",
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xt",
        "<cmd>Trouble todo toggle<cr>",
        desc = "Todos (Trouble)",
      },
      {
        "<leader>o",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols Outline (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "]q",
        function()
          require("trouble").next { jump = true }
        end,
      },
      {
        "[q",
        function()
          require("trouble").prev { jump = true }
        end,
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {
      signs = true,
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:?]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },
}
