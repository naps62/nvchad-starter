return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      files = {
        prompt = "Fzf files>",
        git_icons = true,
        previewer = "bat",
        cmd = "rg --hidden --files -g '!.git'",
      },
      grep = { multiline = true },
      actions = {
        files = {
          ["default"] = function(...) require("fzf-lua.actions").file_edit(...) end,
          ["ctrl-s"] = function(...) require("fzf-lua.actions").file_split(...) end,
          ["ctrl-v"] = function(...) require("fzf-lua.actions").file_vsplit(...) end,
          ["ctrl-t"] = function(...) require("fzf-lua.actions").file_tabedit(...) end,
        },
      },
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
      {
        "<C-g>",
        function()
          require("fzf-lua").git_status { winopts = { fullscreen = true } }
        end,
        desc = "Git status",
      },
      {
        "<C-l><C-r>",
        function()
          require("fzf-lua").lsp_references()
        end,
        desc = "LSP References",
      },
    },
  },
}
