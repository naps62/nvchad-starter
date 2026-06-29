require "nvchad.mappings"

local map = vim.keymap.set

-- remove nvim-tree mappings (nvim-tree disabled; using yazi instead, see plugins/yazi.lua)
vim.keymap.del("n", "<leader>e")
vim.keymap.del("n", "<C-n>")
vim.keymap.del("n", "<leader>rn")
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })

map("n", ";", ":", { desc = "CMD enter command mode" })

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
