local function cmp_config()
	local cmp = require("cmp")
	cmp.setup({
		snippet = {
			expand = function(args)
				require("snippy").expand_snippet(args.body)
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
			-- Snippets first!
			{ name = "snippy" },
			{
				name = "nvim_lsp",
				-- Filter out snippet suggestions from the lsp.
				entry_filter = function(entry)
					return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
				end,
			},
		},
	})
end

return {
	{
		"hrsh7th/nvim-cmp",
		config = cmp_config,
		keys = {
			{
				"<c-l>",
				function()
					require("snippy.mapping").expand_or_advance("<Tab>")()
				end,
				mode = "i",
			},
			{
				"<c-l>",
				function()
					require("snippy.mapping").next("<Tab>")()
				end,
				mode = "s",
			},
			{
				"<c-h>",
				function()
					require("snippy.mapping").previous("<S-Tab>")()
				end,
				mode = { "i", "s" },
			},
		},
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"dcampos/nvim-snippy",
	"dcampos/cmp-snippy",
	{
		"github/copilot.vim", -- REQUIRES: NodeJS
		lazy = false,
		init = function()
			-- Disable using tab to accept completion. Use <c-i> instead.
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
		end,
		keys = {
			{ "<c-k>", "copilot#Previous()", mode = "i", silent = true, expr = true , replace_keycodes = false },
			{ "<c-j>", "copilot#Next()", mode = "i", silent = true, expr = true , replace_keycodes = false },
			-- § is mapped to <c-i> by wezterm.
			{ "§", 'copilot#Accept("<CR>")', mode = "i", silent = true, expr = true , replace_keycodes = false },
		},
	},
}
