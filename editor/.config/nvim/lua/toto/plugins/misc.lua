return {
    "christoomey/vim-tmux-navigator",
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
}
