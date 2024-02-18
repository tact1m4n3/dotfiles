return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        "<leader>a",
        "<leader>h",
        "<C-q>",
        "<C-w>",
        "<C-e>",
        "<C-r>",
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon.setup()

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():append()
        end)
        vim.keymap.set("n", "<leader>h", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        vim.keymap.set("n", "<C-q>", function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "<C-w>", function()
            harpoon:list():select(2)
        end)
        vim.keymap.set("n", "<C-e>", function()
            harpoon:list():select(3)
        end)
        vim.keymap.set("n", "<C-r>", function()
            harpoon:list():select(4)
        end)
    end,
}
