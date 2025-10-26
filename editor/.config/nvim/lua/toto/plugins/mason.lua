return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "zapling/mason-conform.nvim",
        -- "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls",
                "rust_analyzer",
                "clangd",
            },
            automatic_installation = true,
        })

        require("mason-conform").setup()

        -- require("mason-nvim-dap").setup({
        --     ensure_installed = {
        --         "delve",
        --         "codelldb",
        --     },
        --     automatic_installation = true,
        -- })
    end,
}
