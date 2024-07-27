require("helpers")
local servers = {
	"pylsp",
	"ccls",
	"gopls",
	"lua_ls",
}

return {
	{
		"neovim/nvim-lspconfig",
		opts = {},
		config = function()
			local lspconfig = require("lspconfig")

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					-- on_attach = on_attach,
					on_attach = function(client, bufnr)
						-- Enable completion triggered by <c-x><c-o>
						vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

						-- Mappings.
						local bufopts = { noremap = true, silent = true, buffer = bufnr }
						-- Goto def/decalaration with zt to put result at top of the screen
						bind("n", "gD", ":lua vim.lsp.buf.declaration()<Cr>zt", bufopts)
						bind("n", "gd", ":lua vim.lsp.buf.definition()<Cr>zt", bufopts)
						bind("n", "gt", vim.lsp.buf.type_definition, bufopts)
						bind("n", "gr", vim.lsp.buf.references, bufopts)
						bind("n", "gi", vim.lsp.buf.implementation, bufopts)
						bind("n", "gs", vim.lsp.buf.signature_help, bufopts)
						bind("n", "gh", vim.lsp.buf.hover, bufopts)

						bind("n", "<space>en", vim.lsp.buf.rename, bufopts)
						bind("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

						bind("n", "<leader>df", vim.diagnostic.open_float, bufopts)
						bind("n", "<leader>dk", vim.diagnostic.goto_prev, bufopts)
						bind("n", "<leader>dj", vim.diagnostic.goto_next, bufopts)
						bind("n", "<leader>dq", vim.diagnostic.setloclist)
					end,

					-- Add additional capabilities supported by nvim-cmp
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					settings = {
						-- to install pylsp you need to run pip3 install 'python-language-server[all]'
						pylsp = {
							plugins = {
								pycodestyle = {
									ignore = { "W391" },
									maxLineLength = 100,
								},
							},
						},
						python = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
								typeCheckingMode = "off",
							},
						},
					},
				})
			end
			vim.diagnostic.config({
				virtual_text = false,
				underline = false,
				update_in_insert = false,
			})

			-- Configure better diagnostic symbols in the side bar.
			local signs = {
				"Error",
				"Warning",
				"Hint",
				"Information",
			}

			for _, type in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = "⏺︎", texthl = hl, numhl = nil })
			end
		end,
	},
}
