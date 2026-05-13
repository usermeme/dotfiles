return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters = opts.linters or {}

    -- Target markdownlint-cli2 specifically, which is LazyVim's default
    opts.linters["markdownlint-cli2"] = opts.linters["markdownlint-cli2"] or {}

    -- Tell the linter exactly where to find your custom rules
    opts.linters["markdownlint-cli2"].args = {
      "--config",
      vim.fn.expand("~/.config/nvim/.markdownlint.json"),
    }
  end,
}
