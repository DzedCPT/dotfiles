
-- Custom statusline:
-- Inspired by: https://raw.githubusercontent.com/alacritty/alacritty/master/extra/promo/alacritty-readme.png
-- Reference impl: https://github.com/VonHeikemen/nvim-starter/blob/xx-user-plugins/lua/user/statusline.lua
-- 
local cmp = {} -- statusline components

function lsp_attached() 
	for _, lsp_info in pairs(vim.lsp.buf_get_clients()) do 
		if lsp_info['name'] ~= 'copilot' then
			return true
		end 
	end
	return false
end

function cmp.diagnostic_status()
	-- No LSP then nothing to show.
	if not lsp_attached() then
		return ""
	end

	local ignore = {
		["c"] = true, -- command mode
		["t"] = true, -- terminal mode
	}

	-- Using the highlight groups DiagnosticWarn, ... were messing with the bg colours
	-- so I have to manually get the StatusLine background colour and set it.
	local status_line_bg = vim.api.nvim_get_hl_by_name("StatusLine", true).background

	local mode = vim.api.nvim_get_mode().mode


	local levels = vim.diagnostic.severity
	local errors = #vim.diagnostic.get(0, { severity = levels.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = levels.WARN })
	print(#vim.lsp.get_active_clients())

	if ignore[mode] or (errors == 0 and warnings == 0) then
		local ok_fg = vim.api.nvim_get_hl_by_name("DiagnosticOk", true).foreground
		vim.api.nvim_set_hl(0, "StatusLineOk", { fg = ok_fg, bg = status_line_bg })
		-- Note: the %* at the ends the highilght group. So not all future text is also coloured
		return "%#StatusLineOk# ⏺︎%*"
	end

	result = ""
	if warnings > 0 then
		local warn_fg = vim.api.nvim_get_hl_by_name("DiagnosticWarn", true).foreground
		vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = warn_fg, bg = status_line_bg })
		result = warnings .. "%#StatusLineWarn# ⏺︎%*"
	end

	if errors > 0 then
		local err_fg = vim.api.nvim_get_hl_by_name("DiagnosticError", true).foreground
		vim.api.nvim_set_hl(0, "StatusLineError", { fg = err_fg, bg = status_line_bg })
		result = result .. " " .. errors .. "%#StatusLineError# ⏺︎%*"
	end

	return result
end

function _G._statusline_component(name)
	return cmp[name]()
end

-- function state.mode()
-- 	local mode = vim.api.nvim_get_mode().mode
-- 	local mode_name = mode_map[mode]
-- 	local text = " "
--
-- 	local higroup = mode_higroups[mode_name]
--
-- 	if higroup then
-- 		state.mode_group = higroup
-- 		if state.show_diagnostic then
-- 			text = show_sign(mode_name)
-- 		end
--
-- 		return fmt(hi_pattern, higroup, text)
-- 	end
--
-- 	state.mode_group = "UserStatusMode_DEFAULT"
-- 	text = fmt(" %s ", mode_name)
-- 	return fmt(hi_pattern, state.mode_group, text)
-- end

-- Do I want to keep this?
local hi_pattern = "%%#%s#%s%%*"
local mode_map = {
	["n"] = "NORMAL",
	["no"] = "O-PENDING",
	["nov"] = "O-PENDING",
	["noV"] = "O-PENDING",
	["no\22"] = "O-PENDING",
	["niI"] = "NORMAL",
	["niR"] = "NORMAL",
	["niV"] = "NORMAL",
	["nt"] = "NORMAL",
	["v"] = "VISUAL",
	["vs"] = "VISUAL",
	["V"] = "V-LINE",
	["Vs"] = "V-LINE",
	["\22"] = "V-BLOCK",
	["\22s"] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	["\19"] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["ix"] = "INSERT",
	["R"] = "REPLACE",
	["Rc"] = "REPLACE",
	["Rx"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["Rvc"] = "V-REPLACE",
	["Rvx"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "EX",
	["ce"] = "EX",
	["r"] = "REPLACE",
	["rm"] = "MORE",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

function cmp.mode()
	local mode = vim.api.nvim_get_mode().mode
	return mode_map[mode]
end


function cmp.git()
	-- If gitsigns not wokring on current buffer just abort
	 if vim.fn.exists('b:gitsigns_status') ~= 1 then 
	 	return ""
	end

	local git_dict = vim.api.nvim_buf_get_var(0,'gitsigns_status_dict')
	if git_dict['changed'] ~= 0 or git_dict['added'] ~= 0 or git_dict['removed'] ~= 0 then
		return "~ " .. git_dict['head']
	end
	return git_dict['head']
end

-- TOOD: Status lines missed some git info

local statusline = {
	' %{%v:lua._statusline_component("mode")%} ',
	"⡳ ",
	'%{%v:lua._statusline_component("git")%} ',
	-- TODO: Do we even need the file name here since it's in the tabs
	-- " %f",
	" %m", -- is the modifed
	"%r",
	"%=",
	'%{%v:lua._statusline_component("diagnostic_status")%} ',
	-- This changes so often it's nice to put it the right.
	-- The 5 makes it always take up 5 chars
	"| %5l ",
	-- '%{&filetype} ',
	-- 'b:gitsigns_head',
	-- ' %2p%% ',
	-- '%{%v:lua._statusline_component("position")%}'
	-- '%{get(b:,'gitsigns_status','')}'
}

vim.o.statusline = table.concat(statusline, "")
