-- Custom statusline:
-- Reference impl: https://github.com/VonHeikemen/nvim-starter/blob/xx-user-plugins/lua/user/statusline.lua

function lsp_attached()
	for _, lsp_info in pairs(vim.lsp.buf_get_clients()) do
		if lsp_info["name"] ~= "copilot" then
			return true
		end
	end
	return false
end

-- Status line diagnostic info
function diagnostic_status()
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

-- Map nvim mode id to display name in status line
function mode()
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
	local mode = vim.api.nvim_get_mode().mode
	return mode_map[mode]
end

function git()
	-- If gitsigns is not working on current buffer just abort
	if vim.fn.exists("b:gitsigns_status") ~= 1 then
		return ""
	end

	local git_dict = vim.api.nvim_buf_get_var(0, "gitsigns_status_dict")
	if git_dict["changed"] ~= 0 or git_dict["added"] ~= 0 or git_dict["removed"] ~= 0 then
		return "~ " .. git_dict["head"]
	end
	return git_dict["head"]
end

local statusline = {
	" %{%v:lua.mode()%} ",
	"⡳ ",
	"%{%v:lua.git()%} ",
	" %m", -- is file the modifed
	"%=", -- Push the rest to the right
	"%{%v:lua.diagnostic_status()%} ",
	"| %5l ", -- Line number, the 5 makes it always take up 5 chars
}

vim.o.statusline = table.concat(statusline, "")

