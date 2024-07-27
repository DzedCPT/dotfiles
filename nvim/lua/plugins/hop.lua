return {
	"smoka7/hop.nvim",
	version = "2.4.1",
	opts = {
		keys = "jfkdhgslaeiow",
	},
	keys = {
		{ "<leader>l", ":HopLine<Cr>", silent = true, noremap = true },
		{ "<leader>j", ":HopWord<Cr>", silent = true, noremap = true },
		{ "<leader>l", "<cmd>:HopLine<Cr>", mode="v", silent = true, noremap = true },
		{ "<leader>j", "<cmd>:HopWord<Cr>", mode="v", silent = true, noremap = true },
	},
}
