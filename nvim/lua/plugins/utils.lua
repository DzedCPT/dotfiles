require("helpers")

return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 10000, -- Make sure this loads before anything else
		opts = {
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
		},
		init = function()
			local color_scheme = getDarkMode() == "Dark" and "kanagawa-lotus" or "kanagawa-dragon"
			vim.cmd("colorscheme " .. color_scheme)
		end,
	},
	{ "DzedCPT/nvim-rooter", opts = {} },
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"ojroques/nvim-osc52", -- Need this for copying text from remotes to local clipboard
		lazy = true,
		opts = {},
		init = function()
			bind("n", "<leader>y", require("osc52").copy_operator, { expr = true })
			bind("v", "<leader>y", require("osc52").copy_visual)
			bind("n", "<leader>yy", "<leader>y_", { remap = true })
		end,
	},
	{ "gbprod/substitute.nvim", opts = {} },
	"machakann/vim-highlightedyank",
}
