require "nvchad.mappings"

-- remove nvim-tree mappings (using mini.files instead)
vim.keymap.del("n", "<leader>e")
vim.keymap.del("n", "<C-n>")

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

-- remove search highlight
map("n", "<leader>,", ":noh<cr>")
