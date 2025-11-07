local M = {}

-- Track the current element being debugged
local current_debug_element = {
  bufnr = nil,
  start_row = nil,
  start_col = nil,
  end_row = nil,
  end_col = nil,
  has_debug = false, -- Track if we added debug to this element
}

-- Check if the current filetype is JSX/TSX
local function is_jsx_file()
  local ft = vim.bo.filetype
  return ft == "javascriptreact" or ft == "typescriptreact" or ft == "jsx" or ft == "tsx"
end

-- Get the node at cursor position
local function get_node_at_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]

  local parser = vim.treesitter.get_parser(0)
  if not parser then
    return nil
  end

  local tree = parser:parse()[1]
  if not tree then
    return nil
  end

  return tree:root():named_descendant_for_range(row, col, row, col)
end

-- Find the jsx element node (opening tag) from current node
local function find_jsx_element(node)
  if not node then
    return nil
  end

  local current = node
  while current do
    local node_type = current:type()
    if
      node_type == "jsx_opening_element"
      or node_type == "jsx_self_closing_element"
    then
      return current
    end
    current = current:parent()
  end

  return nil
end

-- Check if element has className prop or is a raw HTML element
local function should_debug_element(element_node)
  if not element_node then
    return false, nil
  end

  local element_type = element_node:type()
  local is_raw_html = false
  local class_attr = nil

  -- Check if it's a raw HTML element (lowercase tag name)
  for child in element_node:iter_children() do
    if child:type() == "identifier" or child:type() == "member_expression" then
      local tag_name = vim.treesitter.get_node_text(child, 0)
      -- Raw HTML elements start with lowercase
      if tag_name:match("^[a-z]") then
        is_raw_html = true
      end
      break
    end
  end

  -- Look for className attribute
  for child in element_node:iter_children() do
    if child:type() == "jsx_attribute" then
      local attr_name_node = child:field("name")[1]
      if attr_name_node then
        local attr_name = vim.treesitter.get_node_text(attr_name_node, 0)
        if attr_name == "className" then
          class_attr = child
          break
        end
      end
    end
  end

  return is_raw_html or class_attr ~= nil, class_attr
end

-- Get className attribute value node
local function get_classname_value_node(class_attr)
  if not class_attr then
    return nil
  end

  local value_node = class_attr:field("value")[1]
  if not value_node then
    return nil
  end

  -- Handle string literal
  if value_node:type() == "string" or value_node:type() == "string_fragment" then
    return value_node
  end

  -- Handle jsx_expression (for template literals or expressions)
  if value_node:type() == "jsx_expression" then
    for child in value_node:iter_children() do
      if child:type() == "string" or child:type() == "template_string" then
        return child
      end
    end
  end

  return value_node
end

-- Add "debug" to className
local function add_debug_class(bufnr, class_attr, element_node)
  if class_attr then
    -- className exists, add "debug" to it
    local value_node = get_classname_value_node(class_attr)
    if not value_node then
      return false
    end

    local start_row, start_col, end_row, end_col = value_node:range()
    local text = vim.treesitter.get_node_text(value_node, bufnr)

    -- Remove quotes if present
    local is_quoted = text:match('^["\']') and text:match('["\']$')
    if is_quoted then
      text = text:sub(2, -2)
    end

    -- Check if "debug" is already there (as a whole word)
    local has_debug = false
    for word in text:gmatch("%S+") do
      if word == "debug" then
        has_debug = true
        break
      end
    end

    if has_debug then
      return false
    end

    -- Add "debug" to the className
    local new_text = text == "" and "debug" or (text .. " debug")
    if is_quoted then
      new_text = '"' .. new_text .. '"'
    end

    -- Replace the text
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { new_text })
    return true
  else
    -- className doesn't exist, add it
    -- Find the position to insert (after the tag name)
    local tag_name_node = nil
    for child in element_node:iter_children() do
      if child:type() == "identifier" or child:type() == "member_expression" then
        tag_name_node = child
        break
      end
    end

    if not tag_name_node then
      return false
    end

    local _, _, end_row, end_col = tag_name_node:range()
    local new_text = ' className="debug"'

    vim.api.nvim_buf_set_text(bufnr, end_row, end_col, end_row, end_col, { new_text })
    return true
  end
end

-- Remove "debug" from className
local function remove_debug_class(bufnr, class_attr)
  if not class_attr then
    return false
  end

  local value_node = get_classname_value_node(class_attr)
  if not value_node then
    return false
  end

  local start_row, start_col, end_row, end_col = value_node:range()
  local text = vim.treesitter.get_node_text(value_node, bufnr)

  -- Remove quotes if present
  local is_quoted = text:match('^["\']') and text:match('["\']$')
  if is_quoted then
    text = text:sub(2, -2)
  end

  -- Check if "debug" is present (as a whole word)
  local has_debug = false
  for word in text:gmatch("%S+") do
    if word == "debug" then
      has_debug = true
      break
    end
  end

  if not has_debug then
    return false
  end

  -- Remove "debug" from the className (as a whole word)
  local classes = {}
  for word in text:gmatch("%S+") do
    if word ~= "debug" then
      table.insert(classes, word)
    end
  end
  local new_text = table.concat(classes, " ")

  -- If className becomes empty, remove the entire attribute
  if new_text == "" then
    local attr_start_row, attr_start_col, attr_end_row, attr_end_col = class_attr:range()
    -- Also remove the space before className if present
    if attr_start_col > 0 then
      attr_start_col = attr_start_col - 1
    end
    vim.api.nvim_buf_set_text(bufnr, attr_start_row, attr_start_col, attr_end_row, attr_end_col, { "" })
  else
    if is_quoted then
      new_text = '"' .. new_text .. '"'
    end
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { new_text })
  end

  return true
end

-- Remove debug from the previously tracked element
local function cleanup_previous_element()
  if not current_debug_element.bufnr or not current_debug_element.has_debug then
    return
  end

  -- Re-parse to get fresh tree after potential modifications
  local parser = vim.treesitter.get_parser(current_debug_element.bufnr)
  if not parser then
    return
  end

  local tree = parser:parse()[1]
  if not tree then
    return
  end

  local root = tree:root()
  local prev_elem_node = root:named_descendant_for_range(
    current_debug_element.start_row,
    current_debug_element.start_col,
    current_debug_element.start_row,
    current_debug_element.start_col
  )

  if prev_elem_node then
    local prev_jsx_element = find_jsx_element(prev_elem_node)
    if prev_jsx_element then
      local _, prev_class_attr = should_debug_element(prev_jsx_element)
      if remove_debug_class(current_debug_element.bufnr, prev_class_attr) then
        vim.cmd("silent! write")
      end
    end
  end
end

-- Main cursor handler
local function on_cursor_moved()
  if not is_jsx_file() then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()
  local element_node = find_jsx_element(node)

  local should_debug, class_attr = should_debug_element(element_node)

  if should_debug and element_node then
    -- Get element position
    local start_row, start_col, end_row, end_col = element_node:range()

    -- Check if we're on the same element (approximately, allowing for small shifts)
    local same_element = current_debug_element.bufnr == bufnr
      and current_debug_element.start_row == start_row
      and math.abs(current_debug_element.start_col - start_col) <= 20 -- Allow some tolerance

    if not same_element then
      -- Clean up previous element
      cleanup_previous_element()

      -- Add debug to new element
      local did_add = add_debug_class(bufnr, class_attr, element_node)
      if did_add then
        vim.cmd("silent! write")
      end

      -- Update current element
      current_debug_element = {
        bufnr = bufnr,
        start_row = start_row,
        start_col = start_col,
        end_row = end_row,
        end_col = end_col,
        has_debug = did_add,
      }
    end
  else
    -- Not on a debuggable element, remove debug from previous
    cleanup_previous_element()

    -- Reset tracking
    current_debug_element = {
      bufnr = nil,
      start_row = nil,
      start_col = nil,
      end_row = nil,
      end_col = nil,
      has_debug = false,
    }
  end
end

-- Setup function
function M.setup()
  -- Create autocmd for cursor movement in JSX/TSX files
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    pattern = { "*.jsx", "*.tsx", "*.js", "*.ts" },
    callback = function()
      -- Debounce to avoid too frequent calls
      vim.defer_fn(on_cursor_moved, 50)
    end,
  })

  -- Also handle buffer leave to clean up
  vim.api.nvim_create_autocmd("BufLeave", {
    pattern = { "*.jsx", "*.tsx", "*.js", "*.ts" },
    callback = function()
      cleanup_previous_element()
      current_debug_element = {
        bufnr = nil,
        start_row = nil,
        start_col = nil,
        end_row = nil,
        end_col = nil,
        has_debug = false,
      }
    end,
  })
end

return M
