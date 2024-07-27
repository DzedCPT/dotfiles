local function change_theme(theme)
	local cmd = string.format("colorscheme %s", theme)
	return function()
		vim.cmd(cmd)
	end
end

-- Commands for changing themes
vim.api.nvim_create_user_command("Dark", change_theme("kanagawa-dragon"), { nargs = 0 })
vim.api.nvim_create_user_command("Light", change_theme("kanagawa-lotus"), { nargs = 0 })
vim.api.nvim_create_user_command("Moon", change_theme("kanagawa-wave"), { nargs = 0 })

