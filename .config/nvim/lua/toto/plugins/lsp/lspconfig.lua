return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        "folke/trouble.nvim",
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
            ["<leader>ca"] = { { "n", "v" }, vim.lsp.buf.code_action },
            ["<leader>cr"] = { "n", vim.lsp.buf.rename },
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

        local function format_on_save(client, bufnr)
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end
        end

        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        vim.diagnostic.config({
            virtual_text = true,
        })

        local capabilities = cmp_nvim_lsp.default_capabilities()

        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                set_keymaps(bufnr, {})
                format_on_save(client, bufnr)
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
                format_on_save(client, bufnr)
            end,
        })

        lspconfig["taplo"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                set_keymaps(bufnr, {})
                format_on_save(client, bufnr)
            end,
        })

        lspconfig["texlab"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                set_keymaps(bufnr, {})
                format_on_save(client, bufnr)
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
                    format_on_save(client, bufnr)
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
                format_on_save(client, bufnr)
            end,
        })
    end,
}
