local M = {}

-- Debug logging
local log_file = "/tmp/jsx-debug.log"
local function log(msg)
  local f = io.open(log_file, "a")
  if f then
    f:write(os.date("[%H:%M:%S] ") .. msg .. "\n")
    f:close()
  end
end

-- Clear log on init
local function clear_log()
  local f = io.open(log_file, "w")
  if f then
    f:write("=== JSX Debug Plugin Log ===\n")
    f:close()
  end
end

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

  log("  should_debug_element: checking " .. element_type)

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

  -- Look for className attribute - log all children first
  log("  should_debug_element: iterating children:")
  for child in element_node:iter_children() do
    local child_type = child:type()
    local child_text = vim.treesitter.get_node_text(child, 0):sub(1, 50):gsub("\n", "\\n")
    log("    child: type=" .. child_type .. " text=" .. child_text)

    if child_type == "jsx_attribute" then
      -- Try field access first
      local attr_name_node = child:field("name")[1]
      log("      field('name') result: " .. tostring(attr_name_node))

      -- If field access fails, try iterating children
      if not attr_name_node then
        for attr_child in child:iter_children() do
          log("      attr_child: type=" .. attr_child:type())
          if attr_child:type() == "property_identifier" or attr_child:type() == "identifier" then
            attr_name_node = attr_child
            break
          end
        end
      end

      if attr_name_node then
        local attr_name = vim.treesitter.get_node_text(attr_name_node, 0)
        log("      attr_name=" .. attr_name)
        if attr_name == "className" then
          class_attr = child
          log("      Found className attribute!")
        end
      end
    end
  end

  log("  should_debug_element: is_raw_html=" .. tostring(is_raw_html) .. " class_attr=" .. tostring(class_attr))
  return is_raw_html or class_attr ~= nil, class_attr
end

-- Get className attribute value node
local function get_classname_value_node(class_attr)
  if not class_attr then
    log("  get_classname_value_node: no class_attr")
    return nil
  end

  -- Try field access first
  local value_node = class_attr:field("value")[1]
  log("  get_classname_value_node: field('value') = " .. tostring(value_node))

  -- If field access fails, iterate children to find the value
  if not value_node then
    log("  get_classname_value_node: iterating children:")
    for child in class_attr:iter_children() do
      local child_type = child:type()
      log("    child: type=" .. child_type)
      -- Value is typically a string, jsx_expression, or template_string
      if child_type == "string" or child_type == "string_fragment" or
         child_type == "jsx_expression" or child_type == "template_string" then
        value_node = child
        log("    Found value node: " .. child_type)
        break
      end
    end
  end

  if not value_node then
    log("  get_classname_value_node: no value node found")
    return nil
  end

  log("  get_classname_value_node: value_node type=" .. value_node:type())

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
      log("  add_debug_class: No value node found")
      return false
    end

    local start_row, start_col, end_row, end_col = value_node:range()
    local text = vim.treesitter.get_node_text(value_node, bufnr)

    -- Remove quotes if present
    local is_quoted = text:match('^["\']') and text:match('["\']$')
    if is_quoted then
      text = text:sub(2, -2)
    end

    log("  add_debug_class: className exists with value: '" .. text .. "'")

    -- Check if "debug" is already there (as a whole word)
    local has_debug = false
    for word in text:gmatch("%S+") do
      if word == "debug" then
        has_debug = true
        break
      end
    end

    if has_debug then
      log("  add_debug_class: 'debug' already present, skipping")
      return false
    end

    -- Add "debug" to the className
    local new_text = text == "" and "debug" or (text .. " debug")
    if is_quoted then
      new_text = '"' .. new_text .. '"'
    end

    log("  add_debug_class: Adding 'debug', new value: '" .. new_text .. "'")

    -- Replace the text
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { new_text })
    return true
  else
    -- className doesn't exist, add it
    log("  add_debug_class: No className found, creating new one")
    -- Find the position to insert (after the tag name)
    local tag_name_node = nil
    for child in element_node:iter_children() do
      if child:type() == "identifier" or child:type() == "member_expression" then
        tag_name_node = child
        break
      end
    end

    if not tag_name_node then
      log("  add_debug_class: No tag name node found")
      return false
    end

    local _, _, end_row, end_col = tag_name_node:range()
    local new_text = ' className="debug"'

    log("  add_debug_class: Creating className=\"debug\" at row " .. end_row)

    vim.api.nvim_buf_set_text(bufnr, end_row, end_col, end_row, end_col, { new_text })
    return true
  end
end

-- Remove "debug" from className
local function remove_debug_class(bufnr, class_attr)
  if not class_attr then
    log("  remove_debug_class: No class_attr provided")
    return false
  end

  local value_node = get_classname_value_node(class_attr)
  if not value_node then
    log("  remove_debug_class: No value node found")
    return false
  end

  local start_row, start_col, end_row, end_col = value_node:range()
  local text = vim.treesitter.get_node_text(value_node, bufnr)

  -- Remove quotes if present
  local is_quoted = text:match('^["\']') and text:match('["\']$')
  if is_quoted then
    text = text:sub(2, -2)
  end

  log("  remove_debug_class: className value: '" .. text .. "'")

  -- Check if "debug" is present (as a whole word)
  local has_debug = false
  for word in text:gmatch("%S+") do
    if word == "debug" then
      has_debug = true
      break
    end
  end

  if not has_debug then
    log("  remove_debug_class: 'debug' not found, skipping")
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

  log("  remove_debug_class: Removing 'debug', new value: '" .. new_text .. "'")

  -- If className becomes empty, remove the entire attribute
  if new_text == "" then
    log("  remove_debug_class: className empty, removing entire attribute")
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
  log("cleanup_previous_element: Called")
  log("  has_debug=" .. tostring(current_debug_element.has_debug))
  log("  bufnr=" .. tostring(current_debug_element.bufnr))
  log("  start_row=" .. tostring(current_debug_element.start_row))

  if not current_debug_element.bufnr or not current_debug_element.has_debug then
    log("  Skipping cleanup (no bufnr or we didn't add debug)")
    return
  end

  -- Re-parse to get fresh tree after potential modifications
  local parser = vim.treesitter.get_parser(current_debug_element.bufnr)
  if not parser then
    log("  No parser available")
    return
  end

  local tree = parser:parse()[1]
  if not tree then
    log("  No tree available")
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
    log("  Found previous element node")
    local prev_jsx_element = find_jsx_element(prev_elem_node)
    if prev_jsx_element then
      log("  Found previous JSX element")
      local _, prev_class_attr = should_debug_element(prev_jsx_element)
      if remove_debug_class(current_debug_element.bufnr, prev_class_attr) then
        log("  Removed debug, saving file")
        vim.cmd("silent! write")
      end
    else
      log("  No JSX element found")
    end
  else
    log("  No previous element node found")
  end
end

-- Main cursor handler
local function on_cursor_moved()
  log("\n>>> on_cursor_moved: Called")

  if not is_jsx_file() then
    log("  Not a JSX file, skipping")
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()
  local element_node = find_jsx_element(node)

  log("  bufnr=" .. bufnr)
  log("  element_node=" .. tostring(element_node))

  local should_debug, class_attr = should_debug_element(element_node)
  log("  should_debug=" .. tostring(should_debug))

  if should_debug and element_node then
    -- Get element position
    local start_row, start_col, end_row, end_col = element_node:range()
    log("  Element at row=" .. start_row .. " col=" .. start_col)

    -- Check if we're on the same element (use row as primary identifier)
    local same_element = current_debug_element.bufnr == bufnr
      and current_debug_element.start_row == start_row

    log("  Tracked element: bufnr=" .. tostring(current_debug_element.bufnr) ..
        " row=" .. tostring(current_debug_element.start_row) ..
        " has_debug=" .. tostring(current_debug_element.has_debug))
    log("  same_element=" .. tostring(same_element))

    if not same_element then
      log("  Different element detected, switching...")

      -- Clean up previous element
      cleanup_previous_element()

      -- Add debug to new element
      log("  Calling add_debug_class")
      local did_add = add_debug_class(bufnr, class_attr, element_node)
      log("  did_add=" .. tostring(did_add))

      if did_add then
        log("  Writing file after add")
        vim.cmd("silent! write")

        -- Re-parse tree to get updated positions after adding debug
        vim.schedule(function()
          log("  Re-parsing tree to update positions")
          local parser = vim.treesitter.get_parser(bufnr)
          if parser then
            local tree = parser:parse()[1]
            if tree then
              local cursor = vim.api.nvim_win_get_cursor(0)
              local row = cursor[1] - 1
              local col = cursor[2]
              local updated_node = tree:root():named_descendant_for_range(row, col, row, col)
              local updated_element = find_jsx_element(updated_node)
              if updated_element then
                local new_start_row, new_start_col, new_end_row, new_end_col = updated_element:range()
                log("  Updated positions: row=" .. new_start_row .. " col=" .. new_start_col)
                current_debug_element = {
                  bufnr = bufnr,
                  start_row = new_start_row,
                  start_col = new_start_col,
                  end_row = new_end_row,
                  end_col = new_end_col,
                  has_debug = true,
                }
                log("  Stored element with has_debug=true")
              else
                log("  WARNING: Could not find updated element")
              end
            end
          end
        end)
      else
        log("  Debug not added (already exists), tracking element with has_debug=false")
        -- Debug was already there, just update tracking
        current_debug_element = {
          bufnr = bufnr,
          start_row = start_row,
          start_col = start_col,
          end_row = end_row,
          end_col = end_col,
          has_debug = false, -- We didn't add it
        }
      end
    else
      log("  Same element, no action needed")
    end
  else
    log("  Not on a debuggable element")
    -- Not on a debuggable element, remove debug from previous
    cleanup_previous_element()

    -- Reset tracking
    log("  Resetting tracking")
    current_debug_element = {
      bufnr = nil,
      start_row = nil,
      start_col = nil,
      end_row = nil,
      end_col = nil,
      has_debug = false,
    }
  end
  log("<<< on_cursor_moved: Done\n")
end

-- Debounce timer
local timer = nil

-- Setup function
function M.setup()
  -- Clear log file on setup
  clear_log()
  log("Plugin initialized")

  -- Create autocmd for cursor movement in JSX/TSX files
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
      if not is_jsx_file() then
        return
      end

      -- Debounce to avoid too frequent calls
      if timer then
        vim.fn.timer_stop(timer)
      end
      timer = vim.fn.timer_start(100, function()
        on_cursor_moved()
        timer = nil
      end)
    end,
  })

  -- Also handle buffer leave to clean up
  vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
      if timer then
        vim.fn.timer_stop(timer)
        timer = nil
      end
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
