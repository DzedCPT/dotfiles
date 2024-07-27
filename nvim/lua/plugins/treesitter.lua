local ensure_intalled = {
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
	"vimdoc",
	"luadoc",
	"vim",
	"lua",
	"markdown",
}

return {
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
				"vimdoc",
				"luadoc",
				"vim",
				"lua",
				"markdown",
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
}
