return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      icons_enabled = false,
      theme = "gruvbox-material",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      disabled_filetypes = { "undotree" },
    },
    sections = {
      lualine_b = { "filename" },
      lualine_c = {},
      lualine_x = { "encoding", "filetype" },
    },
    extensions = {
      "fugitive",
      "oil",
      "quickfix",
    }
  },
}
