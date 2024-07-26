local function gs()
	return package.loaded.gitsigns
end

function next_hunk()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(function()
		gs().next_hunk()
		vim.fn.feedkeys("zz", "n")
	end)
	return "<Ignore>"
end

function prev_hunk()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		gs().prev_hunk()
		vim.fn.feedkeys("zz", "n")
	end)
	return "<Ignore>"
end

return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		keys = {
			{ "<leader>gs", gs().stage_hunk },
			{ "<leader>gr", gs().reset_hunk },
			{ "<leader>gS", gs().stage_buffer },
			{ "<leader>gu", gs().undo_stage_hunk },
			{ "<leader>gR", gs().reset_buffer },
			{ "<leader>gp", gs().preview_hunk },
			{
				"<leader>gb",
				function()
					gs().blame_line({ full = true })
				end,
			},
			{ "<leader>gtb", gs().toggle_current_line_blame },
			{ "<leader>gd", gs().diffthis },
			{
				"<leader>gD",
				function()
					gs().diffthis("~")
				end,
			},
			{ "<leader>gj", next_hunk, { expr = true } },
			{ "<leader>gk", prev_hunk, { expr = true } },
			{ "v", "<leader>gj", next_hunk, { expr = true } },
			{ "v", "<leader>gk", prev_hunk, { expr = true } },
			{
				"v",
				"<leader>gs",
				function()
					gs().stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
			},
			{
				"v",
				"<leader>hr",
				function()
					gs().reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
			},
		},
	},
	-- {
	--                "NeogitOrg/neogit",
	--                dependencies = {
	--                        "nvim-lua/plenary.nvim", -- required
	--                },
	-- 			opts={},
	-- 		}
}
