return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          ".git/",
          ".cache/",
          "target/",
          "%.o",
          "%.a",
          "%.out",
          "%.class",
          "%.pdf",
          "%.mkv",
          "%.mp4",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>sg", builtin.live_grep)
    vim.keymap.set("n", "<leader>fh", builtin.help_tags)
  end,
}
