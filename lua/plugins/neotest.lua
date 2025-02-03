return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "rustaceanvim.neotest",
        },
      }
    end,
    keys = {
      {
        "<leader>nt",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        { desc = "Test current file" },
      },
      {
        "<leader>nT",
        function()
          require("neotest").run.run()
        end,
        { desc = "Run test suite" },
      },
      {
        "<leader>ns",
        function()
          require("neotest").summary.toggle()
        end,
        { desc = "Toggle neotest summary" },
      },
      {
        "<leader>nw",
        function()
          require("neotest").watch.watch(vim.fn.expand "%")
        end,
        { desc = "Watch current file" },
      },
      {
        "<leader>nW",
        function()
          require("neotest").watch.watch()
        end,
        { desc = "Watch test suite" },
      },
    },
  },
}
