-- ================================================================================
-- General Settings
-- ================================================================================
-- Note: set ==> vim.opt.
-- let ==> vim.g

local function bind(mode, src, dest, opts)
	opts = opts or { silent = true, noremap = true }
	vim.keymap.set(mode, src, dest, opts)
end

local function change_theme(theme)
	local cmd = string.format("colorscheme %s", theme)
	return function()
		vim.cmd(cmd)
	end
end

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

vim.opt.relativenumber = true

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

vim.g.mapleader = " "

vim.opt.relativenumber = true

-- Netr doesn't behave like other buffers and causes problems by getting locked as a tab.
-- See: https://github.com/tpope/vim-vinegar/issues/13 and https://vi.stackexchange.com/questions/14622/how-can-i-close-the-netrw-buffer
-- This should help to fix that:
vim.cmd("autocmd FileType netrw setl bufhidden=delete")

-- ================================================================================
-- General Appearance
-- ================================================================================

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

-- ================================================================================
-- Install Plugins
-- ================================================================================

-- Install LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Basic util plugins:
	-- Always root the workdir
	"DzedCPT/nvim-rooter",
	-- tab bar
	"DzedCPT/mini.tabline",
	-- Some icons to make things looks nicer:
	"nvim-tree/nvim-web-devicons",
	-- Add surround actions
	"echasnovski/mini.surround",
	-- Need this for copying text from remotes to local clipboard
	"ojroques/nvim-osc52",
	-- Subsitute text plugin
	"gbprod/substitute.nvim",
	-- Toggle comments
	"numToStr/Comment.nvim",
	-- Highlight the text that got yanked
	"machakann/vim-highlightedyank",
	-- Theme
	"rebelot/kanagawa.nvim",
	{
		"smoka7/hop.nvim",
		version = "2.4.1",
		-- opts = {},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- Move this to the plugin config section
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"lua",
					"python",
					"fish",
					"dockerfile",
					"c",
					"cpp",
					"sql",
					"markdown",
					"yaml",
					"go",
					"cmake",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				-- Use v to increase the size of your selection in visual mode.
				incremental_selection = {
					enable = true,
					keymaps = {
						node_incremental = "v",
						-- Might be nice to map this to something else, but V is too useful in visual mode.
						-- node_decremental = "V",
					},
				},
			})
		end,
	},

	-- Git plugins
	-- Show signs in the columns
	"lewis6991/gitsigns.nvim",
	-- Deal with git conflicts
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		-- TODO move this to git plugin config section
		config = {
			-- This will disable the diagnostics in a buffer whilst it is conflicted
			disable_diagnostics = true,
			default_mappings = false, -- disable buffer local mapping created by this plugin
			highlights = { -- They must have background color, otherwise the default color will be used
				-- incoming = "DiffAdd",
				-- Settings these to false makes the colours looks better
				incoming = false,
				current = false,
			},
		},
	},
	-- Git Interface
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
		},
	},

	-- Linting and code completion
	{
		"github/copilot.vim", -- REQUIRES: NodeJS
		init = function()
			-- Needed to distable using tab for completion.
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
		end,
	},
	"neovim/nvim-lspconfig",
	-- Auto complete plugins
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"dcampos/nvim-snippy",
	"dcampos/cmp-snippy",
})

-- ================================================================================
-- Configure Plugins
-- ================================================================================

require("mini.tabline").setup()

require("mini.surround").setup(
	-- This is the default config, but I changed the mappings.
	-- No need to copy this inside `setup()`. Will be used automatically.
	{
		-- Add custom surroundings to be used on top of builtin ones. For more
		-- information with examples, see `:h MiniSurround.config`.
		custom_surroundings = nil,

		-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
		highlight_duration = 500,

		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			-- Not convinced these are the best shortcuts.
			add = "<C-a>i", -- Add surrounding in Normal and Visual modes
			delete = "<C-a>d", -- Delete surrounding
			replace = "<C-a>r", -- Replace surrounding
			find = "", -- Find surrounding (to the right)
			find_left = "", -- Find surrounding (to the left)
			highlight = "", -- Highlight surrounding
			update_n_lines = "", -- Update `n_lines`

			suffix_last = "", -- Suffix to search with "prev" method
			suffix_next = "", -- Suffix to search with "next" method
		},

		-- Number of lines within which surrounding is searched
		n_lines = 20,

		-- Whether to respect selection type:
		-- - Place surroundings on separate lines in linewise mode.
		-- - Place surroundings on each line in blockwise mode.
		respect_selection_type = false,

		-- How to search for surrounding (first inside current line, then inside
		-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
		-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
		-- see `:h MiniSurround.config`.
		search_method = "cover",

		-- Whether to disable showing non-error feedback
		silent = false,
	}
)

local hop = require("hop")
hop.setup({
	-- Define order in which should assign keys.
	-- Keep it nice and close to the homerow.
	keys = "jfkdhgslaeiow",
})

local substitute = require("substitute")
substitute.setup()
require("Comment").setup()
require("gitsigns").setup()
require("git-conflict").setup()

require("neogit").setup({
	-- By default open commit buffer in insert mode.
	disable_insert_on_commit = true,
	-- Make evertyhing open in a replace window.
	-- floating could also be cool, but documentations says it's kinda buggy
	kind = "replace",
	commit_editor = {
		kind = "replace",
	},
	commit_select_view = {
		kind = "replace",
	},
	commit_view = {
		kind = "replace",
		verify_commit = os.execute("which gpg") == 0, -- Can be set to true or false, otherwise we try to find the binary
	},
	log_view = {
		kind = "replace",
	},
	rebase_editor = {
		kind = "replace",
	},
	reflog_view = {
		kind = "replace",
	},
	merge_editor = {
		kind = "replace",
	},
	tag_editor = {
		kind = "replace",
	},
	preview_buffer = {
		kind = "replace",
	},
	popup = {
		kind = "replace",
	},
})

require("telescope").setup({})

require("kanagawa").setup({
	-- This remove's gutter's background color
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
})

local function getDarkMode()
	-- Currently this will only work on Mac
	return vim.fn.system("defaults read -g AppleInterfaceStyle")
end

local color_scheme = getDarkMode() == "Dark" and "kanagawa-lotus" or "kanagawa-dragon"

vim.cmd("colorscheme " .. color_scheme)
-- Not sure why this is required (probably has to do with plugin load sequence)
-- but this line below is required for the neogit theme to take effect the first
-- time you open it.
change_theme(color_scheme)()

local lspconfig = require("lspconfig")
-- Enable language servers
local servers = { "pylsp", "ccls", "gopls" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		-- on_attach = on_attach,
		on_attach = function(client, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

			-- Mappings.
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			-- Goto def/decalaration with zt to put result at top of the screen
			bind("n", "gD", ":lua vim.lsp.buf.declaration()<Cr>zt", bufopts)
			bind("n", "gd", ":lua vim.lsp.buf.definition()<Cr>zt", bufopts)
			-- Collides with jumping up to next open line
			-- bind("n", "K", vim.lsp.buf.hover, bufopts)
			bind("n", "gi", vim.lsp.buf.implementation, bufopts)
			bind("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
			bind("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
			bind("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
			bind("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, bufopts)
			bind("n", "<space>gt", vim.lsp.buf.type_definition, bufopts)
			bind("n", "<space>rn", vim.lsp.buf.rename, bufopts)
			bind("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
			bind("n", "gr", vim.lsp.buf.references, bufopts)
			--vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
		end,
		-- Add additional capabilities supported by nvim-cmp
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		settings = {
			-- to install pylsp you need to run pip3 install 'python-language-server[all]'
			pylsp = {
				plugins = {
					pycodestyle = {
						ignore = { "W391" },
						maxLineLength = 100,
					},
				},
			},
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
					typeCheckingMode = "off",
				},
			},
		},
	})
end
vim.diagnostic.config({
	virtual_text = false,
	underline = false,
	update_in_insert = false,
})

-- Configure better diagnostic symbols in the side bar.
local signs = {
	"Error",
	"Warning",
	"Hint",
	"Information",
}

for _, type in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = "⏺︎", texthl = hl, numhl = nil })
end

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			-- require("luasnip").lsp_expand(args.body)
			require("snippy").expand_snippet(args.body) -- For `snippy` users.
			-- require("snippy").lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<Tab>"] = cmp.mapping.confirm({ noremap = true, select = true }),
	}),
	sources = {
		{ name = "snippy" },
		{ name = "nvim_lsp" },
	},
})

-- ================================================================================
-- Keybindings
-- ================================================================================

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

bind("n", "<Leader>q", ":q<Cr>")
bind("n", "<leader>w", ":bd<Cr>")
-- Close all buffers apart from the current one
bind("n", "<leader>W", ":%bd|e#|bd#<Cr>")

-- Jump around the quickfix list
bind("n", "[q", ":cprevious<Cr>")
bind("n", "]q", ":cnext<Cr>")

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

-- ================================================================================
-- Extension Keybindings
-- ================================================================================

-- copilot keybindings
-- Something to condsider in the future!
-- vim.api.nvim_set_keymap("i", "<C-H>", 'copilot#Previous()', { silent = true, expr = true })
-- vim.api.nvim_set_keymap("i", "<C-K>", 'copilot#Next()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "§", 'copilot#Accept("<CR>")', { silent = true, expr = true })

bind("n", "<leader>df", vim.diagnostic.open_float)
-- jump to next/prev diagnostic
bind("n", "[d", vim.diagnostic.goto_prev)
bind("n", "]d", vim.diagnostic.goto_next)

-- Show diagnostics in the quickfix list.
bind("n", "<leader>dq", vim.diagnostic.setloclist)

-- Telescope keybindings
local telescope_builtin = require("telescope.builtin")
bind("n", "<leader>b", function()
	telescope_builtin.buffers({ ignore_current_buffer = true, sort_lastused = true })
end)
bind("n", "<leader>o", telescope_builtin.git_files)
bind("n", "<leader>s", telescope_builtin.lsp_document_symbols)
bind("n", "<leader>fo", telescope_builtin.find_files)
bind("n", "<leader>ff", telescope_builtin.live_grep)
bind("n", "<leader>s", telescope_builtin.lsp_document_symbols)
bind("n", "<leader>fj", telescope_builtin.jumplist)
bind("n", "<leader>fs", telescope_builtin.grep_string)
bind("n", "<leader>fp", telescope_builtin.resume)
bind("n", "<leader>fh", telescope_builtin.help_tags)
bind("n", "<leader>fa", telescope_builtin.commands)
-- there are some more telescope pickers that could be helpful to configure at some point.

-- Substitute keybindings
bind("n", "s", substitute.operator, { noremap = true })
bind("n", "ss", substitute.line, { noremap = true })
bind("n", "S", substitute.eol, { noremap = true })
bind("x", "s", substitute.visual, { noremap = true })

-- GitSigns keybindings
local gs = package.loaded.gitsigns
bind("n", "<leader>hs", gs.stage_hunk)
bind("n", "<leader>hr", gs.reset_hunk)
bind("v", "<leader>hs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
bind("v", "<leader>hr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
bind("n", "<leader>hS", gs.stage_buffer)
bind("n", "<leader>hu", gs.undo_stage_hunk)
bind("n", "<leader>hR", gs.reset_buffer)
bind("n", "<leader>hp", gs.preview_hunk)
bind("n", "<leader>hb", function()
	gs.blame_line({ full = true })
end)
bind("n", "<leader>htb", gs.toggle_current_line_blame)
bind("n", "<leader>hd", gs.diffthis)
bind("n", "<leader>hD", function()
	gs.diffthis("~")
end)
bind("n", "<leader>td", gs.toggle_deleted)

function next_hunk()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(function()
		gs.next_hunk()
		vim.fn.feedkeys("zz")
	end)
	return "<Ignore>"
end
function prev_hunk()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		gs.prev_hunk()
		vim.fn.feedkeys("zz")
	end)
	return "<Ignore>"
end

bind("v", "<C-n>", next_hunk, { expr = true })
bind("v", "<C-p>", prev_hunk, { expr = true })
bind("n", "<C-n>", next_hunk, { expr = true })
bind("n", "<C-p>", prev_hunk, { expr = true })

bind("n", "<leader>cc", "<Plug>(git-conflict-ours)")
bind("n", "<leader>ci", "<Plug>(git-conflict-theirs)")
bind("n", "<leader>cb", "<Plug>(git-conflict-both)")
bind("n", "<leader>c0", "<Plug>(git-conflict-none)")
bind("n", "]c", "<Plug>(git-conflict-prev-conflict)")
bind("n", "[c", "<Plug>(git-conflict-next-conflict)")
bind("n", "<leader>cl", ":GitConflictListQf<CR>")

-- Commands for changing themes
vim.api.nvim_create_user_command("Dark", change_theme("kanagawa-dragon"), { nargs = 0 })
vim.api.nvim_create_user_command("Light", change_theme("kanagawa-lotus"), { nargs = 0 })
vim.api.nvim_create_user_command("Moon", change_theme("kanagawa-wave"), { nargs = 0 })

-- Formatter keybindings
bind("n", "<leader>ef", ":Format<Cr>")

-- Shortcuts for copying to system clipboard, works locally and on remote servers.
bind("n", "<leader>y", require("osc52").copy_operator, { expr = true })
bind("n", "<leader>yy", "<leader>y_", { remap = true })
bind("v", "<leader>y", require("osc52").copy_visual)

-- Neogit keybindings
bind("n", "<leader>hh", ":Neogit<Cr>")
bind("n", "<leader>hc", ":Neogit commit<Cr>")
bind("n", "<leader>hp", ":Neogit pull<Cr>")
bind("n", "<leader>hP", ":Neogit push<Cr>")

-- Simple hop config
local hop = require("hop")
bind("n", "<leader>l", ":HopLine<Cr>")
bind("n", "<leader>j", ":HopWord<Cr>")

bind("v", "<leader>l", "<cmd>:HopLine<Cr>")
bind("v", "<leader>j", "<cmd>:HopWord<Cr>")

bind("n", "<C-t>", "<Cmd>BufferPick<CR>")
-- Move to previous/next
bind("n", "<C-h>", ":bprev<CR>")
bind("n", "<C-l>", ":bnext<CR>")
require("snippy").setup({
	-- mappings = {
	--     is = {
	--         ['<Tab>'] = 'expand_or_advance',
	--         ['<S-Tab>'] = 'previous',
	--     },
	--     nx = {
	--         ['<leader>x'] = 'cut_text',
	--     },
	-- },
})
local mappings = require("snippy.mapping")

-- TODO: Figure out these keymaps
vim.keymap.set("i", "<Tab>", mappings.expand_or_advance("<Tab>"))
vim.keymap.set("s", "<Tab>", mappings.next("<Tab>"))
-- vim.keymap.set({ 'i', 's' }, '<S-Tab>', mappings.previous('<S-Tab>'))
-- vim.keymap.set('x', '<Tab>', mappings.cut_text, { remap = true })
-- vim.keymap.set('n', 'g<Tab>', mappings.cut_text, { remap = true })

require("statusline")

bind("n", "<leader>r", ":source %<CR>")
require("nvim-web-devicons").setup()
require("nvim-rooter").setup()
