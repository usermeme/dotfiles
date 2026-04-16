return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("diffview").setup({
      use_icons = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    })
  end,
}
