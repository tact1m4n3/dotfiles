return {
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
        "folke/trouble.nvim",
    },
    keys = {
        "<leader>ff",
        "<leader>fg",
        "<leader>sg",
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        local trouble = require("trouble.providers.telescope")

        telescope.setup({
            defaults = {
                file_ignore_patterns = {
                    ".git/",
                    ".cache/",
                    "target/",
                    "%.o",
                    "%.a",
                    "%.out",
                    "%.class",
                    "%.pdf",
                    "%.mkv",
                    "%.mp4",
                },
                mappings = {
                    i = { ["<C-t>"] = trouble.open_with_trouble },
                    n = { ["<C-t>"] = trouble.open_with_trouble },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
            },
        })

        vim.keymap.set("n", "<leader>ff", builtin.find_files)
        vim.keymap.set("n", "<leader>fg", builtin.git_files)
        vim.keymap.set("n", "<leader>sg", builtin.live_grep)
    end,
}
