return {
    "folke/trouble.nvim",
    config = function()
        local trouble = require("trouble")
        trouble.setup({
            icons = false,
            fold_open = "⏷",
            fold_closed = "⏵",
            indent_lines = false,
            signs = {
                error = "E",
                warning = "W",
                hint = "H",
                information = "I",
                other = " ",
            },
            use_diagnostic_signs = false,
        })
        vim.keymap.set("n", "<leader>t", function() trouble.toggle("workspace_diagnostics") end)
        vim.keymap.set("n", "[t", function()
            if trouble.is_open() then
                require("trouble").previous({ skip_groups = true, jump = true })
            else
                print("You must open trouble")
            end
        end)
        vim.keymap.set("n", "]t", function()
            if trouble.is_open() then
                require("trouble").next({ skip_groups = true, jump = true })
            else
                print("You must open trouble")
            end
        end)
    end,
}
