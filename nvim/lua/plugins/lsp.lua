require("helpers")
local lsp_servers = {
	"pylsp",
	"ccls",
	"gopls",
	"lua_ls",
	-- "kotlin_lsp",
}

vim.lsp.enable("kotlin_lsp")
vim.lsp.config("kotlin_lsp", {
	-- Server-specific settings. See `:help lsp-quickstart`
	settings = {
		["kotlin_lsp"] = {
			filetypes = { "kotlin" },
			cmd = { "kotlin-lsp", "--stdio" },
			root_markers = {
				"LICENSE.txt"
				-- "settings.gradle", -- Gradle (multi-project)
				-- "settings.gradle.kts", -- Gradle (multi-project)
				-- "pom.xml", -- Maven
				-- "build.gradle", -- Gradle
				-- "build.gradle.kts", -- Gradle
				-- "workspace.json", -- Used to integrate your own build system
			},
		},
	},
})

local mason_ensure_intalled = {
	-- LSP servers
	{ "python-lsp-server", version = "1.8.0" }, -- pylsp
	-- "ccls",mason doesn't support installing ccls
	"gopls",
	"lua-language-server", -- lua_ls
	-- Formatters
	"black",
	"stylua",
	"clang-format",
	-- Debuggers
	"debugpy",
}

return {
	{ "williamboman/mason.nvim", opts = {} },
	{ "WhoIsSethDaniel/mason-tool-installer", opts = { ensure_installed = mason_ensure_intalled } },
	{
		"neovim/nvim-lspconfig",
		opts = {},
		config = function()
			local lspconfig = require("lspconfig")

			for _, lsp in ipairs(lsp_servers) do
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

						-- Ctrl+click for go-to-definition
						bind("n", "<C-LeftMouse>", ":lua vim.lsp.buf.definition()<Cr>zt", bufopts)
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
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					local signs = {
						{ name = "DiagnosticSignError", text = "●" },
						{ name = "DiagnosticSignWarn", text = "-" },
						{ name = "DiagnosticSignHint", text = "●" },
						{ name = "DiagnosticSignInfo", text = "●" },
					}

					for _, sign in ipairs(signs) do
						vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name, numhl = nil })
					end
				end,
			})
		end,
	},
}
