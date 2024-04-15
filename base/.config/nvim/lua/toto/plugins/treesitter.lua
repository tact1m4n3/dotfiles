return {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
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
}
