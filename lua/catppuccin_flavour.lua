local M = {}

M.flavours = { "latte", "frappe", "macchiato", "mocha" }
local state_file = vim.fn.stdpath "state" .. "/catppuccin-flavour"

function M.get()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  return ok and vim.tbl_contains(M.flavours, lines[1]) and lines[1] or "frappe"
end

function M.set(flavour)
  if not vim.tbl_contains(M.flavours, flavour) then
    vim.notify("Choose a Catppuccin flavour: " .. table.concat(M.flavours, ", "), vim.log.levels.ERROR)
    return
  end

  vim.cmd.colorscheme("catppuccin-" .. flavour)
  local ok, err = pcall(function()
    vim.fn.mkdir(vim.fn.stdpath "state", "p")
    vim.fn.writefile({ flavour }, state_file)
  end)
  if not ok then vim.notify("Could not save Catppuccin flavour: " .. tostring(err), vim.log.levels.WARN) end
end

function M.select(flavour)
  if flavour and flavour ~= "" then
    M.set(flavour)
    return
  end

  vim.ui.select(M.flavours, { prompt = "Catppuccin flavour" }, function(choice)
    if choice then M.set(choice) end
  end)
end

return M
