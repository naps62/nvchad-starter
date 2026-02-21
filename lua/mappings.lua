require "nvchad.mappings"

local map = vim.keymap.set

-- remove nvim-tree mappings (using mini.files instead)
vim.keymap.del("n", "<leader>e")
vim.keymap.del("n", "<C-n>")
vim.keymap.del("n", "<leader>rn")

-- mini.files
map("n", "<leader>e", function()
  local MiniFiles = require "mini.files"
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = "File explorer (current file)" })

map("n", "<leader>E", function()
  local MiniFiles = require "mini.files"
  if not MiniFiles.close() then
    MiniFiles.open(vim.uv.cwd())
  end
end, { desc = "File explorer (cwd)" })

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
