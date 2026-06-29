-- Reload buffers when their file changes on disk (e.g. edited by a coding agent).
-- `autoread` (set in options.lua) only takes effect when something triggers a check,
-- so we run `checktime` on focus/movement/buffer events. Event-based only: no idle
-- polling, so there's zero overhead when nvim is sitting still.
local grp = vim.api.nvim_create_augroup("auto_reload", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" }, {
  group = grp,
  callback = function()
    -- skip while typing a command or in the command-line window
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd "silent! checktime"
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = grp,
  callback = function()
    vim.notify("File reloaded (changed on disk)", vim.log.levels.INFO)
  end,
})
