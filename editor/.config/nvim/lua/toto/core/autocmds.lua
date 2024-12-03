local core_group = vim.api.nvim_create_augroup("core", {});

-- remove trailing whitespaces
vim.api.nvim_create_autocmd("BufWritePre", {
    group = core_group,
    pattern = "",
    command = ":%s/\\s\\+$//e",
})

-- highlight text after yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = core_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- close with q any of these splits
vim.api.nvim_create_autocmd("FileType", {
    group = core_group,
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

-- push the colorcolumn further for some languages
vim.api.nvim_create_autocmd('Filetype', {
    group = core_group,
    pattern = { 'rust', 'zig' },
    command = 'set colorcolumn=100',
})

-- enable wrapping and spell checking for 'documents'
vim.api.nvim_create_autocmd('Filetype', {
    group = core_group,
    pattern = { "bib", "gitcommit", "markdown", "text", "tex" },
    callback = function()
        local opt = vim.opt_local
        opt.wrap = true
        opt.spell = true
        opt.textwidth = 79
    end,
})
