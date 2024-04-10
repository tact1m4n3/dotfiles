return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local lazy_status = require("lazy.status")

        local custom_theme = require("lualine.themes.onedark")
        custom_theme.normal.b.bg = "none"
        custom_theme.normal.c.bg = "none"
        custom_theme.inactive.b.bg = "none"
        custom_theme.inactive.c.bg = "none"

        return {
            options = {
                theme = custom_theme,
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                disabled_filetypes = { "undotree" },
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
            extensions = {
                "fugitive",
                "oil",
                "trouble",
            }
        }
    end,
}
