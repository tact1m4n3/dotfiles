return {
  "sainnhe/gruvbox-material",
  name = "gruvbox-material",
  priority = 1000,
  config = function()
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_better_performance = 1

    vim.cmd.colorscheme("gruvbox-material")

    vim.cmd("hi LineNr ctermfg=239 guifg=#666655")
    vim.cmd("hi! link Comment Label")
    vim.cmd("hi Visual guibg=#454443")
  end,
}
