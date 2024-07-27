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

-- Autocmd to disable folding always.
vim.cmd([[autocmd BufWritePost,BufEnter * set nofoldenable foldmethod=manual foldlevelstart=99]])
