return {
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disable_mouse = false,
      restricted_keys = {
        ["w"] = { "n", "x" },
        ["W"] = { "n", "x" },
        ["b"] = { "n", "x" },
        ["B"] = { "n", "x" },
      },
    },
  },

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
  --   "tzachar/local-highlight.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("local-highlight").setup()
  --   end,
  -- },
}
