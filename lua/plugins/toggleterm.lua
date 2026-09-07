---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  opts = {
    shell = "pwsh",
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.3) -- or fixed line height (20 for example)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4) -- 40% width of the editor
      end
    end,
  },
}
