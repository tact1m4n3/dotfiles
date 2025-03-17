return {
    "nvim-treesitter/nvim-treesitter",
    -- version = "*",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "bash",
                "bibtex",
                "c",
                "comment",
                "cpp",
                "go",
                "gomod",
                "gowork",
                "gotmpl",
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
            highlight = { enable = true },
            indent = { enable = true },
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
