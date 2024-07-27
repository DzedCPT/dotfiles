return {
	{
		"mfussenegger/nvim-dap",
		ops = {},
		init = function()
			require("dap-python").setup("python")
			table.insert(require("dap").configurations.python, {
				type = "python",
				request = "launch",
				name = "Current launch",
				program = "${file}",
			})
		end,
		keys = {
			{
				"<c-b>",
				function()
					require("dap").toggle_breakpoint()
				end,
			},
			{
				"<c-.>",
				":DapNew<CR>",
			},
			{
				"<c-/>",
				":DapTerminate<CR>",
			},
		},
	},

	{
		"rcarriga/nvim-dap-ui",
		opts = {
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "",
					pause = "",
					play = "",
					run_last = "",
					step_back = "",
					step_into = "",
					step_out = "",
					step_over = "",
					terminate = "",
				},
			},
			element_mappings = {},
			expand_lines = true,
			floating = {
				border = "single",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			force_buffers = true,
			icons = {
				collapsed = "",
				current_frame = "",
				expanded = "",
			},
			layouts = {
				{
					elements = {
						-- scopes, breakpoints and watches are not shown
						{
							id = "stacks",
							size = 0.25,
						},
						{
							id = "scopes",
							size = 0.5,
						},
						{
							id = "repl",
							size = 0.25,
						},
					},
					position = "right",
					size = 60,
				},
				{
					-- Put nothing at the bottom
					elements = {},
					position = "bottom",
					size = 10,
				},
			},
			mappings = {
				edit = "e",
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				repl = "r",
				toggle = "t",
			},
			render = {
				indent = 1,
				max_value_lines = 100,
			},
		},
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		init = function()
			-- Make sure dapui is open when we start debugging
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
		keys = {
			{
				"<c-u>",
				function()
					require("dapui").toggle()
				end,
			},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
	},
}
