return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        "folke/trouble.nvim",
        { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
        "simrat39/rust-tools.nvim",
    },
    config = function()
        local default_keys = {
            ["gd"] = { "n", vim.lsp.buf.definition },
            ["gD"] = { "n", vim.lsp.buf.declaration },
            ["gi"] = { "n", vim.lsp.buf.implementation },
            ["gt"] = { "n", vim.lsp.buf.type_definition },
            ["gr"] = { "n", function() require("trouble").toggle("lsp_references") end },
            ["K"] = { "n", vim.lsp.buf.hover },
            ["<C-h>"] = { "i", vim.lsp.buf.signature_help },
            ["[d"] = { "n", vim.diagnostic.goto_prev },
            ["]d"] = { "n", vim.diagnostic.goto_next },
            ["<leader>ca"] = { { "n", "v" }, vim.lsp.buf.code_action },
            ["<leader>cr"] = { "n", vim.lsp.buf.rename },
            ["<leader>cd"] = { "n", vim.diagnostic.open_float },
            ["<leader>cf"] = { "n", vim.lsp.buf.format },
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
            float = { border = "rounded" },
            virtual_text = {
                prefix = "●",
            },
        })

        local capabilities = cmp_nvim_lsp.default_capabilities()

        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
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

        lspconfig["gopls"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                set_keymaps(bufnr, {})
            end,
        })

        lspconfig["taplo"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                set_keymaps(bufnr, {})
            end,
        })

        lspconfig["texlab"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                set_keymaps(bufnr, {})
            end,
        })

        local rust_tools = require("rust-tools")
        rust_tools.setup({
            server = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
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
            on_attach = function(client, bufnr)
                set_keymaps(bufnr, {})
            end,
        })
    end,
}