return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          if require("sidekick").nes_jump_or_apply() then
            return
          end
          return "<Tab>"
        end,
        expr = true,
        mode = { "i", "n" },
        desc = "Sidekick: Goto/Apply Next Edit Suggestion",
      },

      {
        "<leader>aa",
        function()
          -- This specifically targets the 'claude' CLI tool
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick: Toggle Claude Terminal",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Sidekick: Send Visual Selection",
      },
    },
  },
}
