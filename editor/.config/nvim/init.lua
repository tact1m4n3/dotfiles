vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.colorcolumn = '80'

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.iskeyword:append("-")

vim.opt.formatoptions:remove('o')

vim.keymap.set("n", "<C-c>", ":nohl<CR>")
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["+d]])

local my_group = vim.api.nvim_create_augroup("user", {});

vim.api.nvim_create_autocmd("BufWritePre", {
    group = my_group,
    pattern = "",
    command = ":%s/\\s\\+$//e",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = my_group,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = my_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = my_group,
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "checkhealth",
        "fugitive",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", ":close<CR>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = my_group,
    pattern = "*.wgsl",
    callback = function()
        vim.bo.filetype = "wgsl"
        vim.bo.commentstring = "//%s"
    end,
})

vim.api.nvim_create_autocmd('Filetype', {
    group = my_group,
    pattern = 'rust',
    command = 'set colorcolumn=100',
})

vim.api.nvim_create_autocmd('Filetype', {
    group = my_group,
    pattern = { "bib", "gitcommit", "markdown", "text" },
    command = 'setlocal spell tw=72 colorcolumn=73',
})

vim.api.nvim_create_autocmd('Filetype', {
    group = my_group,
    pattern = 'tex',
    command = 'setlocal spell tw=80 colorcolumn=81',
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        "christoomey/vim-tmux-navigator",
        {
            "sainnhe/gruvbox-material",
            name = "gruvbox-material",
            priority = 1000,
            config = function()
                vim.g.gruvbox_material_background = "hard"
                vim.g.gruvbox_material_better_performance = 1

                vim.cmd.colorscheme("gruvbox-material")

                vim.cmd("hi LineNr ctermfg=239 guifg=#666655")
                vim.cmd("hi Visual guibg=#454443")
            end,
        },
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "make",
                    config = function()
                        require("telescope").load_extension("fzf")
                    end,
                },
            },
            config = function()
                local telescope = require("telescope")

                telescope.setup()

                local builtin = require("telescope.builtin")
                vim.keymap.set("n", "<leader>ff", builtin.find_files)
                vim.keymap.set("n", "<leader>fs", builtin.live_grep)
                vim.keymap.set("n", "<leader>fh", builtin.help_tags)
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            opts = {
                options = {
                    icons_enabled = false,
                    theme = "gruvbox-material",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    disabled_filetypes = { "undotree" },
                },
                sections = {
                    lualine_b = { "filename" },
                    lualine_c = {},
                    lualine_x = { "encoding", "filetype" },
                },
                extensions = {
                    "fugitive",
                    "oil",
                    "quickfix",
                }
            },
        },
        {
            "lewis6991/gitsigns.nvim",
            event = { "BufReadPre", "BufNewFile" },
            opts = {
                signs = {
                    add          = { text = '┃' },
                    change       = { text = '┃' },
                    delete       = { text = '▁' },
                    topdelete    = { text = '▔' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
            },
        },
        {
            "tpope/vim-fugitive",
            config = function()
                vim.keymap.set("n", "<leader>g", vim.cmd.Git)

                vim.api.nvim_create_autocmd("BufWinEnter", {
                    group = vim.api.nvim_create_augroup("fugitive_push_pull", { clear = true }),
                    pattern = "*",
                    callback = function()
                        if vim.bo.ft ~= "fugitive" then
                            return
                        end

                        local bufnr = vim.api.nvim_get_current_buf()
                        local opts = { buffer = bufnr, remap = false }
                        vim.keymap.set("n", "<leader>p", function()
                            vim.cmd.Git('push')
                        end, opts)

                        vim.keymap.set("n", "<leader>P", function()
                            vim.cmd.Git({ 'pull', '--rebase' })
                        end, opts)
                    end
                })
            end,
        },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                local harpoon = require("harpoon")

                harpoon.setup()

                vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
                vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

                vim.keymap.set("n", "<C-q>", function() harpoon:list():select(1) end)
                vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
                vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
                vim.keymap.set("n", "<C-m>", function() harpoon:list():select(4) end)
            end,
        },
        {
            "stevearc/oil.nvim",
            lazy = false,
            config = function()
                require("oil").setup({
                    columns = {},
                    use_default_keymaps = false,
                    keymaps = {
                        ["<CR>"] = "actions.select",
                        ["q"] = "actions.close",
                        ["<C-f>"] = "actions.refresh",
                        ["-"] = "actions.parent",
                        ["_"] = "actions.open_cwd",
                    },
                    view_options = {
                        show_hidden = true,
                        skip_confirm_for_simple_edits = true,
                    },
                })

                vim.keymap.set("n", "<C-e>", ":Oil<CR>")
            end,
        },
        {
            "mbbill/undotree",
            config = function()
                vim.g.undotree_SetFocusWhenToggle = true

                vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
            end,
        },
        {
            "numToStr/Comment.nvim",
            event = { "BufReadPre", "BufNewFile" },
            opts = {},
        },
        {
            "nvim-treesitter/nvim-treesitter",
            version = "*",
            event = { "BufReadPre", "BufNewFile" },
            build = ":TSUpdate",
            dependencies = {
                "nvim-treesitter/nvim-treesitter-textobjects",
            },
            config = function()
                require("nvim-treesitter.configs").setup({
                    highlight = {
                        enable = true,
                        disable = { "bibtex", "latex" },
                    },
                    indent = {
                        enable = true,
                        disable = { "c", "cpp" },
                    },
                    ensure_installed = {
                        "bash",
                        "bibtex",
                        "c",
                        "comment",
                        "cpp",
                        "go",
                        "gomod",
                        "gowork",
                        "latex",
                        "lua",
                        "luadoc",
                        "luap",
                        "markdown",
                        "python",
                        "rust",
                        "toml",
                        "vim",
                        "vimdoc",
                        "wgsl",
                        "zig",
                    },
                    textobjects = {
                        move = {
                            enable = true,
                            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                        },
                    },
                })
            end,
        },
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
            },
            opts = function()
                local cmp = require("cmp")

                return {
                    snippet = {
                        expand = function(args)
                            vim.snippet.expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-e>"] = cmp.mapping.abort(),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<Tab>"] = cmp.mapping(function(fallback)
                            if vim.snippet.active({ direction = 1 }) then
                                vim.snippet.jump(1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                            if vim.snippet.active({ direction = -1 }) then
                                vim.snippet.jump(-1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                    }, {
                        { name = "path" },
                        { name = "buffer" },
                    }),
                    experimental = {
                        ghost_text = true,
                    },
                }
            end,
        },
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            config = function()
                local lspconfig = require("lspconfig")

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

                lspconfig.rust_analyzer.setup({
                    settings = {
                        ["rust-analyzer"] = {
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
                })

                lspconfig["gopls"].setup({})
                lspconfig["zls"].setup({})

                vim.diagnostic.config({
                    virtual_text = {
                        prefix = "●",
                    },
                })

                vim.api.nvim_create_autocmd('LspAttach', {
                    group = vim.api.nvim_create_augroup('user_lsp_config', {}),
                    callback = function(ev)
                        local telescope = require("telescope.builtin")

                        local opts = { buffer = ev.buf }
                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
                        vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
                        vim.keymap.set("n", "<leader>cs", telescope.lsp_document_symbols, opts)
                        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
                        vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, opts)
                    end
                })
            end,
        },
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            },
        },
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
        {
            'ziglang/zig.vim',
            ft = { "zig" },
        },
        {
            'rust-lang/rust.vim',
            ft = { "rust" },
            config = function()
                vim.g.rustfmt_autosave = 1
                vim.g.rustfmt_emit_files = 1
                vim.g.rustfmt_fail_silently = 0
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
        "lervag/vimtex",
        {
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
                        "lua_ls",
                    },
                    automatic_installation = true,
                })
            end,
        },
    },
    install = {
        colorscheme = { "gruvbox-material" },
    },
    ui = {
        border = "single",
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
    checker = {
        enabled = true,
        notify = false,
    },
})
