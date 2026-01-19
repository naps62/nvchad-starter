local M = {}

-- Set to true to enable debug logging
local DEBUG = false

local function log(msg)
  if not DEBUG then return end
  local f = io.open("/tmp/jsx-debug.log", "a")
  if f then
    f:write(os.date("[%H:%M:%S] ") .. msg .. "\n")
    f:close()
  end
end

-- Track state
local current_debug_element = {
  bufnr = nil,
  start_row = nil,
}

local debounce_timer = nil
local cached_project_root = nil
local cached_project_root_for = nil

-- Find project root (with caching)
local function find_project_root()
  local current_file = vim.fn.expand("%:p")
  if cached_project_root_for == current_file then
    return cached_project_root
  end

  local current = vim.fn.expand("%:p:h")
  while current ~= "/" do
    if vim.fn.filereadable(current .. "/package.json") == 1 then
      cached_project_root = current
      cached_project_root_for = current_file
      return current
    end
    current = vim.fn.fnamemodify(current, ":h")
  end

  cached_project_root = nil
  cached_project_root_for = current_file
  return nil
end

-- Simple file write
local function write_file(path, content)
  local f = io.open(path, "w")
  if f then
    f:write(content)
    f:close()
  end
end

-- Write debug target to json file
local function write_debug_target(file, row, col)
  local root = find_project_root()
  if not root then return end

  local json_path = root .. "/jsx-debug.json"
  local content = file
    and string.format('{"file":"%s","row":%d,"col":%d}', file, row, col)
    or '{}'

  write_file(json_path, content)
  log("Wrote: " .. content)
end

-- Check if JSX/TSX file
local function is_jsx_file()
  local ft = vim.bo.filetype
  return ft == "javascriptreact" or ft == "typescriptreact" or ft == "jsx" or ft == "tsx"
end

-- Get treesitter node at cursor
local function get_node_at_cursor()
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok or not parser then return nil end

  local ok2, tree = pcall(function() return parser:parse()[1] end)
  if not ok2 or not tree then return nil end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  return tree:root():named_descendant_for_range(row, col, row, col)
end

-- Find JSX element node
local function find_jsx_element(node)
  local current = node
  while current do
    local node_type = current:type()

    if node_type == "jsx_opening_element" or node_type == "jsx_self_closing_element" then
      return current
    end

    if node_type == "jsx_element" then
      for child in current:iter_children() do
        if child:type() == "jsx_opening_element" then
          return child
        end
      end
    end

    current = current:parent()
  end
  return nil
end

-- Check if element should be debugged
local function should_debug_element(element_node)
  if not element_node then return false end

  for child in element_node:iter_children() do
    local child_type = child:type()

    -- Check for raw HTML element (lowercase)
    if child_type == "identifier" then
      local tag_name = vim.treesitter.get_node_text(child, 0)
      if tag_name:match("^[a-z]") then
        return true
      end
    end

    -- Check for className attribute
    if child_type == "jsx_attribute" then
      for attr_child in child:iter_children() do
        if attr_child:type() == "property_identifier" or attr_child:type() == "identifier" then
          if vim.treesitter.get_node_text(attr_child, 0) == "className" then
            return true
          end
          break
        end
      end
    end
  end

  return false
end

-- Find nearest debuggable element
local function find_debuggable_jsx_element(node)
  local element = find_jsx_element(node)
  local max_iterations = 50
  local i = 0
  while element and i < max_iterations do
    i = i + 1
    if should_debug_element(element) then
      return element
    end
    local parent = element:parent()
    if not parent or parent == element then
      break
    end
    element = find_jsx_element(parent)
  end
  return nil
end

-- Main handler
local function on_cursor_moved()
  if not is_jsx_file() then return end

  local bufnr = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()
  local element = find_debuggable_jsx_element(node)

  if element then
    local start_row = element:range()
    local same = current_debug_element.bufnr == bufnr and current_debug_element.start_row == start_row

    if not same then
      write_debug_target(vim.fn.expand("%:p"), start_row, 0)
      current_debug_element = { bufnr = bufnr, start_row = start_row }
    end
  else
    if current_debug_element.bufnr then
      write_debug_target(nil)
    end
    current_debug_element = { bufnr = nil, start_row = nil }
  end
end

-- Debounced cursor handler
local function debounced_cursor_moved()
  if debounce_timer then
    vim.fn.timer_stop(debounce_timer)
  end
  debounce_timer = vim.fn.timer_start(150, function()
    debounce_timer = nil
    vim.schedule(on_cursor_moved)
  end)
end

function M.setup()
  if DEBUG then
    local f = io.open("/tmp/jsx-debug.log", "w")
    if f then f:write("=== JSX Debug Plugin ===\n"); f:close() end
  end

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = debounced_cursor_moved,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
      if debounce_timer then
        vim.fn.timer_stop(debounce_timer)
        debounce_timer = nil
      end
      if current_debug_element.bufnr then
        write_debug_target(nil)
      end
      current_debug_element = { bufnr = nil, start_row = nil }
    end,
  })
end

return M
