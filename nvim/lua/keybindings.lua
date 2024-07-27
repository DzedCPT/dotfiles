require("helpers")

bind("i", "jk", "<Esc>")

-- Maybe remove?
-- Not sure why this is required but the esc key was acting up without this
bind("n", "<Esc>", "")

-- Avoid accidently doing this when running code from wezterm.
bind("n", ".", "<Nop>")

-- Automatically record macros into @w
bind("n", "q", "qw_")

-- In visual mode apply macro @w to each line
bind("v", "q", ":'<,'>normal @w<Cr>")

-- Make j and g work more naturally when lines are wrapped
bind("n", "j", "gj")
bind("n", "k", "gk")

-- Tab and shift tab to indent and unindent
bind("n", "<Tab>", ">>_")
bind("n", "<S-Tab>", "<<_")
bind("v", "<Tab>", ">gv")
bind("v", "<S-Tab>", "<gv")

-- Move back to previous buffer
bind("n", "<Leader>a", ":b#<Cr>")

bind("n", "<leader>w", ":bd<Cr>")
-- Close all buffers apart from the current one
bind("n", "<leader>W", ":%bd|e#|bd#<Cr>")

-- Jump around the quickfix list
-- Maybe c-n c-p make sense for this?
--
bind("n", "<c-n>", ":cnext<Cr>")
bind("n", "<c-p>", ":cprevious<Cr>")

-- Open File explorer
bind("n", "<Leader>e", ":Ex<Cr>")

-- Search results centered please
bind("n", "n", "nzz")
bind("n", "N", "Nzz")
bind("n", "*", "*zz")
bind("n", "#", "Nzz")
bind("n", "g*", "g*zz")

-- Bash bindings for insert mode.
bind("i", "<c-s>", "<esc>:w<Cr>")
bind("n", "<c-s>", ":w<Cr>")
bind("i", "<c-e>", "<esc>$a")
bind("n", "<c-e>", "$")
bind("n", "<c-a>", "_")

bind("i", "<c-c>", "<esc>:noh<Cr>li")
bind("n", "<c-c>", ":noh<Cr>")

-- Jump to previous/next location
bind("n", "[j", "<c-o>zz")
bind("n", "]j", "<c-i>zz")

-- Jump to start and end of line using the home row keys
bind("", "H", "^")
bind("", "L", "$")
-- Jump to next open spaces using the home row keys
bind("", "J", "}")
bind("", "K", "{")


-- Don't need an entire plugin just for formatting.
-- Plus doing it like this prints the command output,
-- Which is helpful to see issues
function format()
        if vim.bo.filetype == "lua" then
                vim.cmd(":!stylua %")
        elseif vim.bo.filetype == "python" then
                vim.cmd(":!black %")
        elseif vim.bo.filetype == "cpp" then
                vim.cmd(":!clang-format --style=file -i %")
        else
                vim.cmd(":echo 'No formatter configue for filetype'")
        end
end

bind("n", "<leader>ef", format)
