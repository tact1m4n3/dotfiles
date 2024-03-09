vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "",
    command = ":%s/\\s\\+$//e",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.wgsl",
    callback = function()
        vim.bo.filetype = "wgsl"
        vim.bo.commentstring = "//%s"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "checkhealth",
        "fugitive",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", ":close<CR>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd("Filetype", {
    pattern = { "bib", "gitcommit", "markdown", "tex", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})
