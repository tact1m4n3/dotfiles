return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			custom_highlights = function(colors)
				return {
					EndOfBuffer = { fg = colors.surface1 },
				}
			end,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				harpoon = true,
				telescope = true,
				lsp_trouble = true,
			},
		})

		vim.cmd([[colorscheme catppuccin]])
	end,
}
