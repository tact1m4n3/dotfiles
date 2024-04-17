return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
            { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
            "simrat39/rust-tools.nvim",
        },
        config = function()
            local telescope = require("telescope.builtin")
            local default_keys = {
                ["gd"] = { "n", vim.lsp.buf.definition },
                ["gi"] = { "n", telescope.lsp_implementations },
                ["gD"] = { "n", telescope.lsp_type_definitions },
                ["gr"] = { "n", telescope.lsp_references },
                ["K"] = { "n", vim.lsp.buf.hover },
                ["<C-s>"] = { "i", vim.lsp.buf.signature_help },
                ["<leader>ca"] = { { "n", "v" }, vim.lsp.buf.code_action },
                ["<leader>cr"] = { "n", vim.lsp.buf.rename },
                ["<leader>cf"] = { "n", vim.lsp.buf.format },
                ["[d"] = { "n", vim.diagnostic.goto_prev },
                ["]d"] = { "n", vim.diagnostic.goto_next },
                ["<leader>cd"] = { "n", vim.diagnostic.open_float },
                ["<leader>cq"] = { "n", vim.diagnostic.setqflist },
            }

            local function set_keymaps(bufnr, keys)
                local opts = { buffer = bufnr }

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

            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                },
            })

            local capabilities = cmp_nvim_lsp.default_capabilities()

            lspconfig["clangd"].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    set_keymaps(bufnr, {})
                end,
            })

            lspconfig["gopls"].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    set_keymaps(bufnr, {})
                end,
            })

            lspconfig["lua_ls"].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    set_keymaps(bufnr, {})
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

            lspconfig["pyright"].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    set_keymaps(bufnr, {})
                end,
            })

            lspconfig["taplo"].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    set_keymaps(bufnr, {})
                end,
            })

            lspconfig["texlab"].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    set_keymaps(bufnr, {})
                end,
            })

            local rust_tools = require("rust-tools")
            rust_tools.setup({
                server = {
                    capabilities = capabilities,
                    on_attach = function(_, bufnr)
                        local keys = {
                            ["K"] = { "n", rust_tools.hover_actions.hover_actions },
                            ["<space>ca"] = { { "n", "v" }, rust_tools.code_action_group.code_action_group },
                        }
                        set_keymaps(bufnr, keys)
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
                    set_keymaps(bufnr, {})
                end,
            })
        end,
    }, {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")

            mason.setup()

            mason_lspconfig.setup({
                ensure_installed = {
                    "clangd",
                    "gopls",
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "taplo",
                    "texlab",
                    "wgsl_analyzer",
                },
                automatic_installation = true,
            })
        end,
    }
}
