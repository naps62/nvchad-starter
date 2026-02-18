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

  -- Update in-memory config so base46.compile() picks up the new theme
  require("nvconfig").base46.theme = theme

  require("base46").load_all_highlights()
end

-- Sync with system theme
function M.sync()
  local mode = M.get_system_mode()
  M.apply_theme(mode)
end

return M
