return {
    "stevearc/oil.nvim",
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
}
