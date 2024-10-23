dofile(vim.g.base46_cache .. "telescope")

local open_with_trouble = require("trouble.sources.telescope").open

local options = {
  pickers = {
    colorscheme = { enable_preview = true },
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
      sort_mru = true,
    },
  },
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["<C-q>"] = open_with_trouble, ["t"] = open_with_trouble },
      i = { ["<C-t>"] = open_with_trouble },
    },
  },

  extensions_list = { "themes", "terms" },
  extensions = {},
}

return options
