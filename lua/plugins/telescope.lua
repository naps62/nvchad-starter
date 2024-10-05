return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      require "configs.telescope"
    end,
    keys = {
      { "<C-p>", require("telescope.builtin").find_files, desc = "Find Files (root dir)" },
      { "<C-f>", require("telescope.builtin").live_grep, desc = "Fast live grep" },
      { "<C-S-f>", require("telescope.builtin").grep_string, desc = "Fast string grep" },
    },
  },
}
