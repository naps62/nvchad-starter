require "nvchad.options"

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.cursorlineopt = "both"

-- line numbering
o.number = true
o.relativenumber = true

-- search options
o.showmatch = true
o.smartcase = true
o.gdefault = true

o.fillchars = "eob: ,diff: "
o.scrolloff = 5

vim.o.guifont = "FiraCode Nerd Font Mono:h12"
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_cursor_animation_length = 0.11

vim.o.swapfile = false

-- Command to manually sync theme with system
vim.api.nvim_create_user_command("ThemeSync", function()
  require("theme-sync").sync()
  vim.notify("Theme synced with system", vim.log.levels.INFO)
end, { desc = "Sync theme with system (darkman)" })
