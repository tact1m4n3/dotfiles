return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            transparent_background = true,
            highlight_overrides = {
                all = function(colors)
                    return {
                        LineNr = { fg = colors.flamingo },
                        Comment = { fg = colors.overlay2 },
                    }
                end
            }
        })

        vim.cmd [[colorscheme catppuccin]]
    end,
}
