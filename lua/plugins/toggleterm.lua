---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  opts = function(_, opts)
    opts = opts or {}
    local old_on_create = opts.on_create
    local old_on_open = opts.on_open

    local function get_folder_name(dir)
      local folder = vim.fs.basename(dir)
      if not folder or folder == "" then folder = dir end
      return folder
    end

    -- Hook open_split to guarantee single-split container behavior
    local ui = require "toggleterm.ui"
    if not ui.__orig_open_split then
      ui.__orig_open_split = ui.open_split
      ui.open_split = function(size, term)
        local has_open, windows = ui.find_open_windows()
        if has_open and #windows > 0 then
          local split_win = windows[#windows].window
          vim.api.nvim_set_current_win(split_win)
          for _, t in ipairs(require("toggleterm.terminal").get_all(true)) do
            if t.window == split_win then t.window = nil end
          end
          ui.resize_split(term, size)
          local valid_win = term.window and vim.api.nvim_win_is_valid(term.window)
          local window = valid_win and term.window or split_win
          local valid_buf = term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr)
          local bufnr = valid_buf and term.bufnr or vim.api.nvim_create_buf(false, false)
          vim.api.nvim_win_set_buf(window, bufnr)
          term.window, term.bufnr = window, bufnr
          term:__set_options()
          vim.api.nvim_set_current_buf(bufnr)
          return
        end
        ui.__orig_open_split(size, term)
      end
    end

    -- Clicking a tab in winbar switches the single window to that session
    function _G.___toggleterm_winbar_click(id)
      if id then
        local terms_module = require "toggleterm.terminal"
        local term = terms_module.get(id)
        if term then term:open() end
      end
    end

    local function cycle_terminal(step)
      local terms_module = require "toggleterm.terminal"
      local all_terms = terms_module.get_all()
      if #all_terms <= 1 then return end

      local has_open, windows = ui.find_open_windows()
      local current_id = nil
      if has_open and #windows > 0 then
        local cur_buf = vim.api.nvim_win_get_buf(windows[1].window)
        for _, t in ipairs(all_terms) do
          if t.bufnr == cur_buf then
            current_id = t.id
            break
          end
        end
      end

      local current_idx = 1
      for i, t in ipairs(all_terms) do
        if t.id == current_id then
          current_idx = i
          break
        end
      end

      local next_idx = ((current_idx - 1 + step) % #all_terms) + 1
      all_terms[next_idx]:open()
    end

    return vim.tbl_deep_extend("force", opts, {
      shell = "pwsh",
      direction = "horizontal",
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.3) -- or fixed line height (20 for example)
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4) -- 40% width of the editor
        end
      end,
      winbar = {
        enabled = true,
        name_formatter = function(term)
          local title = term.display_name
          if not title or title == "" then title = get_folder_name(term.dir) end
          return string.format("%d: %s", term.count or term.id, title)
        end,
      },
      responsiveness = {
        horizontal_breakpoint = 135,
      },
      on_create = function(term)
        if old_on_create then old_on_create(term) end
        if not term.display_name or term.display_name == "" then term.display_name = get_folder_name(term.dir) end
      end,
      on_open = function(term)
        if old_on_open then old_on_open(term) end
        if not term.display_name or term.display_name == "" then term.display_name = get_folder_name(term.dir) end
        vim.keymap.set("n", ">", function() cycle_terminal(1) end, {
          buffer = term.bufnr,
          desc = "Next terminal session",
          silent = true,
        })
        vim.keymap.set("n", "<", function() cycle_terminal(-1) end, {
          buffer = term.bufnr,
          desc = "Previous terminal session",
          silent = true,
        })
        vim.keymap.set("n", "+", function()
          local Terminal = require("toggleterm.terminal").Terminal
          local new_term = Terminal:new { direction = term.direction or "horizontal" }
          new_term:open()
        end, {
          buffer = term.bufnr,
          desc = "Create new terminal in same window",
          silent = true,
        })
      end,
    })
  end,
}
