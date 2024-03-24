return {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            styles = {
                transparency = true,
            },
            highlight_groups = {
                TroubleNormal = { bg = "none" }
            },
        })

        vim.cmd [[colorscheme rose-pine]]
    end,
}
