-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = vim.tbl_extend("force", {
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      }, vim.fn.has "win32" == 1 and {
        shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
        shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
        shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
        shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
        shellquote = "",
        shellxquote = "",
      } or {}),
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["<Leader>th"] = {
          function() vim.cmd(vim.v.count1 .. "ToggleTerm direction=horizontal") end,
          desc = "ToggleTerm horizontal split",
        },
        ["<Leader>tv"] = {
          function() vim.cmd(vim.v.count1 .. "ToggleTerm direction=vertical") end,
          desc = "ToggleTerm vertical split",
        },
        ["<Leader>ta"] = { "<Cmd>ToggleTermToggleAll<CR>", desc = "Toggle all open terminals" },
        ["<Leader>ts"] = { "<Cmd>TermSelect<CR>", desc = "Select terminal from list" },
        ["<Leader>tr"] = { "<Cmd>ToggleTermSetName<CR>", desc = "Rename terminal" },

        -- Create new terminal session
        ["<Leader>tc"] = {
          function()
            local terms = require("toggleterm.terminal").get_all()
            local dir = "vertical"
            for _, t in ipairs(terms) do
              if t:is_open() then
                dir = t.direction
                break
              end
            end
            require("toggleterm.terminal").Terminal:new({ direction = dir }):open()
          end,
          desc = "Create new terminal",
        },
        ["<F7>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" },

        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      t = {
        ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
        ["<F7>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
        ["<C-h>"] = { "<Cmd>wincmd h<CR>", desc = "Move to left window" },
        ["<C-j>"] = { "<Cmd>wincmd j<CR>", desc = "Move to below window" },
        ["<C-k>"] = { "<Cmd>wincmd k<CR>", desc = "Move to above window" },
        ["<C-l>"] = { "<Cmd>wincmd l<CR>", desc = "Move to right window" },
      },
    },
  },
}
