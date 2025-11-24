return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      files = {
        prompt = "Fzf files>",
        git_icons = true,
        previewer = "bat",
        cmd = "rg --files",
      },
      grep = { multiline = true },
    },
    cmd = "FzfLua",
    keys = {
      {
        "<C-p>",
        function()
          require("fzf-lua").files()
        end,
        desc = "Files",
      },
      {
        "<C-f>",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Grep string",
      },
      {
        "<leader>b",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "Buffers",
      },
    },
  },
}
