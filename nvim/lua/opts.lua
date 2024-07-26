-- Set leader
vim.g.mapleader = " "

-- Stop the creation of swap files.
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Stop beeping.
vim.opt.visualbell = false

-- Allow buffer switching without saving
vim.opt.hidden = true

-- Always have 5 lines visible above and below the cursor.
vim.opt.scrolloff = 5

-- Set syntax highlighting
vim.opt.syntax = "on"

--Prevent lines from wrapping.
vim.opt.wrap = false

vim.opt.encoding = "utf-8"

-- Make selecting text with a mouse ignore numbers on the side.
vim.opt.mouse = "a"

-- Increase the speed nvim updates itself.
vim.opt.updatetime = 100

-- Searching defaults to case insensitive unless uppercase character is used.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Sensible tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.relativenumber = true

vim.opt.termguicolors = true
vim.g.base16colorspace = 256

-- Don't show mode in status ine
vim.opt.showmode = false

-- Hide the header in netrw
vim.g.netrw_banner = false

-- Prevent the sign bar from having its own background colour.
vim.cmd("highlight clear SignColumn")

-- For the light version Prevent the gutter from having it's own colour.
vim.opt.background = "light"

-- Highlight the current cursor line.
vim.opt.cursorline = true

--Set the number of auto complete options.
vim.opt.pumheight = 6

-- Make sure the signcolum is always visible.
vim.opt.signcolumn = "yes"

-- Use global status line.
vim.opt.laststatus = 3

-- set smartindent
vim.opt.preserveindent = true
vim.opt.shiftwidth = 4

-- Netr doesn't behave like other buffers and causes problems by getting locked as a tab.
-- See: https://github.com/tpope/vim-vinegar/issues/13 and https://vi.stackexchange.com/questions/14622/how-can-i-close-the-netrw-buffer
-- This should help to fix that:
vim.cmd("autocmd FileType netrw setl bufhidden=delete")

-- Hide the quickfix list from the buffer list
vim.cmd([[
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
]])
