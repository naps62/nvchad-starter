-- Sync Neovim theme with system (darkman)

local M = {}

-- Theme mappings
M.themes = {
  light = "github_light",  -- Change to your preferred light theme
  dark = "onenord",        -- Change to your preferred dark theme
}

-- Get current system theme from darkman
function M.get_system_mode()
  local handle = io.popen("darkman get 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result:match("light") then
      return "light"
    end
  end
  return "dark"
end

-- Apply theme based on mode
function M.apply_theme(mode)
  local theme = M.themes[mode] or M.themes.dark

  -- Update the theme using NvChad's base46
  require("nvchad.utils").replace_word('theme = "' .. vim.g.nvchad_theme .. '"', 'theme = "' .. theme .. '"')
  require("base46").load_all_highlights()

  vim.g.nvchad_theme = theme
end

-- Sync with system theme
function M.sync()
  local mode = M.get_system_mode()
  M.apply_theme(mode)
end

-- Watch for theme changes (checks periodically)
function M.watch()
  local timer = vim.loop.new_timer()
  local last_mode = M.get_system_mode()

  timer:start(0, 5000, vim.schedule_wrap(function()
    local current_mode = M.get_system_mode()
    if current_mode ~= last_mode then
      M.apply_theme(current_mode)
      last_mode = current_mode
    end
  end))
end

return M
