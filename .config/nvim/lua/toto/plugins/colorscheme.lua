return {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            styles = {
                bold = false,
                transparency = true,
            },
        })

        vim.cmd [[colorscheme rose-pine]]
    end,
}
