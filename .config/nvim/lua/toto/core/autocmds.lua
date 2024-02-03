vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "",
	command = ":%s/\\s\\+$//e",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.wgsl",
	callback = function()
		vim.bo.filetype = "wgsl"
	end,
})

vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "bib", "gitcommit", "markdown", "tex", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})
