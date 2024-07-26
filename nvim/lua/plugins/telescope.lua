local function builtin()
	return require("telescope.builtin")
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts={},
	keys = {
		{ "<leader>o", builtin().git_files },
		{
			"<leader>b",
			function()
				builtin().buffers({ ignore_current_buffer = true, sort_lastused = true })
			end,
		},
		-- ZZZ: These should also work in visual mode!
		-- ZZZ: Maybe this should be <c-o
		{ "<leader>o", builtin().git_files },
		{ "<leader>fo", builtin().find_files },
		{ "<leader>ff", builtin().live_grep },
		{ "<leader>s", builtin().lsp_document_symbols },
		{ "<leader>fj", builtin().jumplist },
		{ "<leader>fs", builtin().grep_string },
		{ "<leader>fp", builtin().resume },
		{ "<leader>fh", builtin().help_tags },
		{ "<leader>fa", builtin().commands },
	},
}
