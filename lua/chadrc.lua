-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {
  ui = {
    tabufline = {
      enabled = false,
    },
  },
  base46 = {
    theme = "jabuti",
  },

  nvdash = {
    load_on_startup = true,
  },
}

return M
