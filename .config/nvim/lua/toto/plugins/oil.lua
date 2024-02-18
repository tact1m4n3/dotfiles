return {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
        { "<leader>e", ":Oil<CR>" },
    },
    opts = {
        view_options = {
            show_hidden = true,
            skip_confirm_for_simple_edits = true,
        },
    },
}
