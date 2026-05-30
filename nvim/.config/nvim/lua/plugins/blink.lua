return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            end
            if cmp.get_selected_item() and cmp.get_selected_item().source_id == "copilot" then
              return cmp.accept()
            end
          end,
          LazyVim.cmp.map({ "ai_accept", "snippet_forward" }),
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
