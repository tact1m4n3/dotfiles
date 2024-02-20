return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local trouble = require("trouble")
        trouble.setup({
            signs = {
                error = " ",
                warning = " ",
                hint = " ",
                information = " ",
                other = "",
            },
            use_diagnostic_signs = false,
        })
        vim.keymap.set("n", "<leader>t", function() trouble.toggle("workspace_diagnostics") end)
        vim.keymap.set("n", "[t", function()
            if trouble.is_open() then
                require("trouble").previous({ skip_groups = true, jump = true })
            else
                warn("You must open trouble first")
            end
        end)
        vim.keymap.set("n", "]t", function()
            if trouble.is_open() then
                require("trouble").next({ skip_groups = true, jump = true })
            else
                warn("You must open trouble first")
            end
        end)
    end,
}
