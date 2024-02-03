return {
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			local lazy_status = require("lazy.status")

			return {
				options = {
					theme = "catppuccin",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					disabled_filetypes = { "NvimTree", "undotree" },
				},
				sections = {
					lualine_b = {
						{
							"diagnostics",
							symbols = { error = " ", warn = " ", hint = " ", info = " " },
						},
					},
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						{ "encoding" },
						{ "filetype" },
					},
				},
			}
		end,
	},
}
