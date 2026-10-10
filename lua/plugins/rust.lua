---@type LazySpec
return {
  "mrcjkb/rustaceanvim",
  init = function()
    -- GUI launches may not inherit the Rust toolchain path from the shell.
    local cargo_home = vim.env.CARGO_HOME or vim.fn.expand "~/.cargo"
    local cargo_bin = vim.fs.joinpath(cargo_home, "bin")
    local separator = vim.fn.has "win32" == 1 and ";" or ":"
    local path = vim.env.PATH or ""
    if
      vim.fn.isdirectory(cargo_bin) == 1
      and not vim.tbl_contains(vim.split(path, separator, { plain = true }), cargo_bin)
    then
      vim.env.PATH = cargo_bin .. separator .. path
    end
  end,
}
