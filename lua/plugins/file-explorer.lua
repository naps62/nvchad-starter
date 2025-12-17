return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      {
        "<leader>e",
        function()
          local MiniFiles = require "mini.files"
          if not MiniFiles.close() then
            MiniFiles.open(vim.api.nvim_buf_get_name(0))
          end
        end,
        desc = "File explorer (current file)",
      },
      {
        "<leader>E",
        function()
          local MiniFiles = require "mini.files"
          if not MiniFiles.close() then
            MiniFiles.open(vim.uv.cwd())
          end
        end,
        desc = "File explorer (cwd)",
      },
    },
    config = function()
      require("mini.files").setup {
        mappings = {
          close = "q",
          go_in = "l",
          go_in_plus = "<CR>",
          go_out = "h",
          go_out_plus = "H",
          reset = "<BS>",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "=",
          trim_left = "<",
          trim_right = ">",
        },
        windows = {
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 50,
        },
        options = {
          use_as_default_explorer = true,
        },
      }

      -- https://github.com/nvim-mini/mini.nvim/discussions/2173
      -- Window width based on the offset from the center, i.e. center window
      -- is 60, then next over is 20, then the rest are 10.
      -- Can use more resolution if you want like { 60, 20, 20, 10, 5 }
      local widths = { 60, 20, 10 }

      local ensure_center_layout = function(ev)
        local state = MiniFiles.get_explorer_state()
        if state == nil then
          return
        end

        -- Compute "depth offset" - how many windows are between this and focused
        local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match "^minifiles://%d+/(.*)$"
        local depth_this
        for i, path in ipairs(state.branch) do
          if path == path_this then
            depth_this = i
          end
        end
        if depth_this == nil then
          return
        end
        local depth_offset = depth_this - state.depth_focus

        -- Adjust config of this event's window
        local i = math.abs(depth_offset) + 1
        local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
        win_config.width = i <= #widths and widths[i] or widths[#widths]

        win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
        for j = 1, math.abs(depth_offset) do
          local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
          -- widths[j+1] for the negative case because we don't want to add the center window's width
          local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
          -- Add an extra +2 each step to account for the border width
          win_config.col = win_config.col + sign * (prev_win_width + 2)
        end

        win_config.height = depth_offset == 0 and 25 or 20
        win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
        win_config.border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
        vim.api.nvim_win_set_config(ev.data.win_id, win_config)
      end

      vim.api.nvim_create_autocmd("User", { pattern = "MiniFilesWindowUpdate", callback = ensure_center_layout })
    end,
  },
}
