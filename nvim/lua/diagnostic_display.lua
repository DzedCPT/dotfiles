-- Display LSP diagnostics in command line area when cursor moves
local M = {}

local function lsp_attached()
	for _, lsp_info in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if lsp_info["name"] ~= "copilot" then
			return true
		end
	end
	return false
end

-- Display diagnostic message at cursor position in command line
function M.show_diagnostic_at_cursor()
	if not lsp_attached() then
		vim.api.nvim_echo({}, false, {})
		return
	end

	local line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local col = vim.api.nvim_win_get_cursor(0)[2]
	
	-- Get diagnostics for current line
	local diagnostics = vim.diagnostic.get(0, { lnum = line })
	
	if #diagnostics == 0 then
		vim.api.nvim_echo({}, false, {})
		return
	end
	
	-- Find diagnostic at or closest to cursor position
	local closest_diagnostic = nil
	local min_distance = math.huge
	
	for _, diagnostic in ipairs(diagnostics) do
		local distance = math.abs(diagnostic.col - col)
		if distance < min_distance then
			min_distance = distance
			closest_diagnostic = diagnostic
		end
	end
	
	if closest_diagnostic then
		local severity_colors = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		}
		
		local severity_icons = {
			[vim.diagnostic.severity.ERROR] = "✗",
			[vim.diagnostic.severity.WARN] = "✗",
			[vim.diagnostic.severity.WARN] = "✗",
			[vim.diagnostic.severity.INFO] = "✗",
			[vim.diagnostic.severity.HINT] = "✗",
		}
		
		local icon = severity_icons[closest_diagnostic.severity] or "●"
		local hl_group = severity_colors[closest_diagnostic.severity] or "Normal"
		local message = closest_diagnostic.message:gsub("\n", " ")
		
		-- Display in command line with appropriate highlighting
		vim.api.nvim_echo({{icon .. " " .. message, hl_group}}, false, {})
	else
		vim.api.nvim_echo({}, false, {})
	end
end

-- Setup autocmds for diagnostic display
local function setup()
	local augroup = vim.api.nvim_create_augroup("DiagnosticDisplay", { clear = true })
	
	-- Show diagnostic on cursor move
	vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
		group = augroup,
		callback = M.show_diagnostic_at_cursor,
	})
	
	-- Clear diagnostic when entering insert mode or leaving buffer
	vim.api.nvim_create_autocmd({"InsertEnter", "BufLeave"}, {
		group = augroup,
		callback = function()
			vim.api.nvim_echo({}, false, {})
		end,
	})
end

-- Auto-setup when module is required
setup()

return M
