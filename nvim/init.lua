-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Lazy's documentation suggests doing this before loading plugins.
require("opts")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- ZZZ: What to do about this?
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
  rocks = {
  -- Set to true if you want to use the lua package manager luarocks.
  -- Currently I don't use any packages that require luarocks, so disable it to 
  -- avoid needing it as a dependency.
      enabled = false,
      hererocks = false
    },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { vim.g.colors_name } },
  -- Don't automatically check for plugin updates
  checker = { enabled = false },
})

require("keybindings")
require("autocmds")
require("cmds")
require("statusline")

