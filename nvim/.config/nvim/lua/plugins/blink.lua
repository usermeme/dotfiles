return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = { "sources.default" },
    opts = {
      keymap = { preset = "super-tab" },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },

        providers = {
          lsp = {
            score_offset = 100,
          },
          path = {
            score_offset = -100,
          },
        },
      },
    },
  },
}
