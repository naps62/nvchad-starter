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
vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_cursor_animation_length = 0.12
