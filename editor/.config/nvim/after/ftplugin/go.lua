local opt = vim.opt_local;
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4

vim.keymap.set("n", "<leader>ds", function()
    vim.cmd.DapNew('Debug')
end, { silent = true })
