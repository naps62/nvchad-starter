-- Sync Neovim theme with system (darkman)

local M = {}

-- Theme mappings
M.themes = {
  light = "onenord_light",
  dark = "onenord",        -- Change to your preferred dark theme
}

-- Get current system theme from darkman
function M.get_system_mode()
  local handle = io.popen("darkman get 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    result = result and result:gsub("%s+$", "") or nil
    if result == "light" then
      return "light"
    end
  end
  return "dark"
end

-- Apply theme based on mode (mirrors NvChad's toggle_theme logic)
function M.apply_theme(mode)
  local theme = M.themes[mode] or M.themes.dark
  local opts = require("nvconfig").base46

  -- Update in-memory config so base46.compile() picks up the new theme
  opts.theme = theme

  -- Bust chadrc cache, read old theme from file, then replace it
  package.loaded.chadrc = nil
  local old_theme = require("chadrc").base46.theme
  require("nvchad.utils").replace_word('theme = "' .. old_theme, 'theme = "' .. theme)

  require("base46").load_all_highlights()
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
