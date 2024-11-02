return {

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "cljoly/telescope-repo.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup(require "configs.telescope")
      require("telescope").load_extension "repo"
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
      {
        "<leader>p",
        function()
          require("telescope").extensions.repo.list {}
        end,
      },
    },
  },
}
