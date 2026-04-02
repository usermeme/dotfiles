return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- Shows hidden items but dims them
          hide_gitignored = false, -- PERMANENTLY shows .gitignore files
          hide_dotfiles = false, -- PERMANENTLY shows dotfiles (optional)
        },
      },
    },
  },
}
