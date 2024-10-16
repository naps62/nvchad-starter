return {

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
    keys = {
      {
        "<C-p>",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "File files",
      },
      {
        "<C-S-f>",
        function()
          require("telescope.builtin").grep_string { search = "" }
        end,
        desc = "Fuzzy search",
      },
      {
        "<C-f>",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Grep string",
      },
      {
        "<leader>b",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },
    },
  },
}
