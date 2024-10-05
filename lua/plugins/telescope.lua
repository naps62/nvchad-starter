return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      require "configs.telescope"
    end,
    keys = {
      { "<C-p>", require("telescope.builtin").find_files, desc = "Find Files (root dir)" },
      { "<C-f>", require("telescope.builtin").grep_string, desc = "Fast string grep" },
      {
        "<C-f>",
        function()
          local selection = vim.fn.getregion(vim.fn.getpos ".", vim.fn.getpos "v", { mode = vim.fn.mode() })
          require("telescope.builtin").live_grep { default_text = table.concat(selection) }
        end,
        desc = "fuzzy find selection",
        mode = "v",
      },
    },
  },
}
