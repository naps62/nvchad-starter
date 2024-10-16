require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- close current buffer
map("n", "<leader>q", ":q<cr>")

-- go back to normal mode
map("i", "jj", "<Esc>")
map("i", "jk", "<Esc>")

--save file
map("n", "<C-s>", ":update<CR>")
map("i", "<C-s>", "<C-o>:update<CR><Esc>")

-- switch between last two files
-- map("n", "<tab>", ":b#<cr>", { desc = "switch between last two files" })

-- remove search highlight
map("n", "<leader>,", ":noh<cr>")
