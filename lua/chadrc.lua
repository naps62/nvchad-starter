-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

-- Get system theme from darkman
local function get_system_theme()
  local handle = io.popen("darkman get 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result:match("light") then
      return "onenord_light"
    end
  end
  return "onenord"  -- default dark theme
end

---@type ChadrcConfig
local M = {
  ui = {
    tabufline = {
      enabled = false,
    },
  },
  base46 = {
    theme = get_system_theme(),
  },

  nvdash = {
    load_on_startup = true,
  },
}

return M
