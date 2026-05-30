return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function()
            if LazyVim.cmp.actions.ai_accept() then
              return true
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
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
