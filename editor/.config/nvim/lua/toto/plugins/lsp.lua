return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")

            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                },
            })

            lspconfig.lua_ls.setup({
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

            -- rust_analyzer setup in rustaceanvim
            -- lspconfig.rust_analyzer.setup({
            --     settings = {
            --         ["rust-analyzer"] = {
            --             cargo = {
            --                 allFeatures = true,
            --             },
            --             imports = {
            --                 group = {
            --                     enable = false,
            --                 },
            --             },
            --             completion = {
            --                 postfix = {
            --                     enable = false,
            --                 },
            --             },
            --         },
            --     },
            -- })

            lspconfig["gopls"].setup({})
            lspconfig["zls"].setup({})

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp_config', {}),
                callback = function(args)
                    local telescope = require("telescope.builtin")
                    local opts = { buffer = args.buf }

                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", telescope.lsp_references, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>cs", telescope.lsp_document_symbols, opts)
                end
            })
        end,
    },
    -- {
    --     "j-hui/fidget.nvim",
    --     opts = {
    --         notification = {
    --             window = {
    --                 winblend = 0,
    --             },
    --         },
    --     },
    -- },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            doc_lines = 0,
            handler_opts = {
                border = "none",
            },
        },
    },

    -- rust
    {
        'mrcjkb/rustaceanvim',
        version = '^5',
        lazy = false,
        init = function()
            vim.g.rustaceanvim = {
                server = {
                    default_settings = {
                        ['rust-analyzer'] = {
                            cargo = {
                                allFeatures = true,
                            },
                            imports = {
                                group = {
                                    enable = false,
                                },
                            },
                            completion = {
                                postfix = {
                                    enable = false,
                                },
                            },
                        },
                    },
                },
            }
        end
    },
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = function()
            require('crates').setup({
                lsp = {
                    enabled = true,
                    actions = true,
                    completion = true,
                    hover = true,
                },
                text = {
                    loading = "  Loading...",
                    version = "  %s",
                    prerelease = "  %s",
                    yanked = "  %s yanked",
                    nomatch = "  Not found",
                    upgrade = "  %s",
                    error = "  Error fetching crate",
                },
                popup = {
                    text = {
                        title = "# %s",
                        pill_left = "",
                        pill_right = "",
                        created_label = "created        ",
                        updated_label = "updated        ",
                        downloads_label = "downloads      ",
                        homepage_label = "homepage       ",
                        repository_label = "repository     ",
                        documentation_label = "documentation  ",
                        crates_io_label = "crates.io      ",
                        lib_rs_label = "lib.rs         ",
                        categories_label = "categories     ",
                        keywords_label = "keywords       ",
                        version = "%s",
                        prerelease = "%s pre-release",
                        yanked = "%s yanked",
                        enabled = "* s",
                        transitive = "~ s",
                        normal_dependencies_title = "  Dependencies",
                        build_dependencies_title = "  Build dependencies",
                        dev_dependencies_title = "  Dev dependencies",
                        optional = "? %s",
                        loading = " ...",
                    },
                },
                completion = {
                    text = {
                        prerelease = " pre-release ",
                        yanked = " yanked ",
                    },
                },
            })
        end,
    },

    -- tex
    "lervag/vimtex",
}
