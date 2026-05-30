return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = {
          LazyVim.cmp.map({ "ai_accept", "snippet_forward" }),
          "fallback",
        },
      },
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
