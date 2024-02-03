return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			"simrat39/rust-tools.nvim",
		},
		config = function()
			local default_keys = {
				["gd"] = { "n", vim.lsp.buf.definition },
				["gr"] = { "n", vim.lsp.buf.references },
				["gD"] = { "n", vim.lsp.buf.declaration },
				["gi"] = { "n", vim.lsp.buf.implementation },
				["gt"] = { "n", vim.lsp.buf.type_definition },
				["K"] = { "n", vim.lsp.buf.hover },
				["gK"] = { "n", vim.lsp.buf.signature_help },
				["<leader>ca"] = { { "n", "v" }, vim.lsp.buf.code_action },
				["<leader>cr"] = { "n", vim.lsp.buf.rename },
			}

			local function set_keymaps(keys, opts)
				local final_keys = {}
				for key, binding in pairs(default_keys) do
					final_keys[key] = binding
				end
				for key, binding in pairs(keys) do
					final_keys[key] = binding
				end
				for key, binding in pairs(final_keys) do
					local mode, action = unpack(binding)
					vim.keymap.set(mode, key, action, opts)
				end
			end

			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
				},
			})

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					set_keymaps({}, { buffer = bufnr })
				end,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			lspconfig["taplo"].setup({
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					local opts = { buffer = bufnr }
					local keys = {
						["K"] = {
							"n",
							function()
								if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
									require("crates").show_popup()
								else
									vim.lsp.buf.hover()
								end
							end,
						},
					}
					set_keymaps(keys, opts)
				end,
			})

			local rust_tools = require("rust-tools")
			rust_tools.setup({
				server = {
					capabilities = capabilities,
					on_attach = function(_, bufnr)
						local opts = { buffer = bufnr }
						local keys = {
							["K"] = { "n", rust_tools.hover_actions.hover_actions },
							["<space>ca"] = { { "n", "v" }, rust_tools.code_action_group.code_action_group },
						}
						set_keymaps(keys, opts)
					end,
					settings = {
						["rust-analyzer"] = {
							check = {
								command = "clippy",
							},
							cargo = {
								buildScripts = {
									enable = true,
								},
							},
							procMacro = {
								enable = true,
							},
						},
					},
				},
			})

			lspconfig["wgsl_analyzer"].setup({
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					set_keymaps({}, { buffer = bufnr })
				end,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			mason.setup()

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"wgsl_analyzer",
				},
				automatic_installation = true,
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"stylua",
				},
			})
		end,
	},
}
