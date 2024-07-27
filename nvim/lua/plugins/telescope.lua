local function builtin()
	return require("telescope.builtin")
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy=false,
	opts={},
	keys = {
		{ "<leader>o", function() builtin().git_files() end },
		{
			"<leader>b",
			function()
				builtin().buffers({ ignore_current_buffer = true, sort_lastused = true })
			end,
		},
		-- ZZZ: These should also work in visual mode!
		-- ZZZ: Maybe this should be <c-o
		{ "<leader>o", function() builtin().git_files() end },
		{ "<leader>fo", function() builtin().find_files() end },
		{ "<leader>ff", function() builtin().live_grep() end },
		{ "<leader>s", function() builtin().lsp_document_symbols() end },
		{ "<leader>fj", function() builtin().jumplist() end },
		{ "<leader>fs", function() builtin().grep_string() end },
		{ "<leader>fp", function() builtin().resume() end },
		{ "<leader>fh", function() builtin().help_tags() end },
		{ "<leader>fa", function() builtin().commands() end },
	},
}
