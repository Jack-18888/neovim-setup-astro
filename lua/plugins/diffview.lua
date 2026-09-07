return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<Leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
      { "<Leader>gD", "<Cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    },
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local old_on_attach = opts.on_attach
      opts.on_attach = function(bufnr)
        if old_on_attach then old_on_attach(bufnr) end
        vim.keymap.set("n", "<Leader>gd", "<Cmd>DiffviewOpen<CR>", { buffer = bufnr, desc = "Open Diffview" })
        vim.keymap.set("n", "<Leader>gD", "<Cmd>DiffviewClose<CR>", { buffer = bufnr, desc = "Close Diffview" })
      end
    end,
  },
}
