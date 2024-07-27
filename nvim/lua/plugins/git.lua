local function next_hunk()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(function()
		package.loaded.gitsigns.next_hunk()
		vim.fn.feedkeys("zz", "n")
	end)
	return "<Ignore>"
end

local function prev_hunk()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		package.loaded.gitsigns.prev_hunk()
		vim.fn.feedkeys("zz", "n")
	end)
	return "<Ignore>"
end

return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		lazy=false,
		keys = {
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk()
				end,
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
			},
			{
				"<leader>gS",
				function()
					require("gitsigns").stage_buffer()
				end,
			},
			{
				"<leader>gu",
				function()
					require("gitsigns").undo_stage_hunk()
				end,
			},
			{
				"<leader>gR",
				function()
					require("gitsigns").reset_buffer()
				end,
			},
			{
				"<leader>gp",
				function()
					require("gitsigns").preview_hunk()
				end,
			},
			{
				"<leader>gb",
				function()
					require('gitsigns').blame_line({ full = true })
				end,
			},
			{
				"<leader>gtb",
				function()
					require("gitsigns").toggle_current_line_blame()
				end,
			},
			{
				"<leader>gd",
				function()
					require("gitsigns").diffthis()
				end,
			},
			{
				"<leader>gD",
				function()
					require('gitsigns').diffthis("~")
				end,
			},
			{ "<leader>gj", next_hunk, expr = true },
			{ "<leader>gk", prev_hunk, expr = true },
			{ "<leader>gj", next_hunk, mode = "v", expr = true },
			{ "<leader>gk", prev_hunk, mode = "v", expr = true },
			{
				"<leader>gs",
				function()
					require('gitsigns').stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "v",
			},
			{
				"<leader>gr",
				function()
					require('gitsigns').reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "v",
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy=true,
		opts = {
			-- By default open commit buffer in insert mode.
			disable_insert_on_commit = true,
			-- Make everything open in a replace window.
			kind = "replace",
			commit_editor = {
				kind = "replace",
				-- Nice feature, but was giving me errors. TODO: Look into this.
				show_staged_diff = false,
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
		},
		keys = {
			{"<leader>gg", ":Neogit<Cr>"},
			{"<leader>gc", ":Neogit commit<Cr>"},
			{"<leader>gp", ":Neogit pull<Cr>"},
			{"<leader>gP", ":Neogit push<Cr>"},
		}
	},
}
