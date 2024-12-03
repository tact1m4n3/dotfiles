return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { lsp_format = "fallback" },
                rust = { "rustfmt" },
                go = { "goimports", "gofmt" },
                zig = { lsp_format = "fallback" },
            },
            format_on_save = function(bufnr)
                local only_for = { "go", "zig" }
                if not vim.tbl_contains(only_for, vim.bo[bufnr].filetype) then
                    return
                end
                return { timeout_ms = 500 }
            end,
        })

        vim.keymap.set({ "n", "v" }, "<leader>cf", function()
            require("conform").format({ async = true }, function(err)
                if not err then
                    local mode = vim.api.nvim_get_mode().mode
                    if vim.startswith(string.lower(mode), "v") then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                    end
                end
            end)
        end)
    end,
}
