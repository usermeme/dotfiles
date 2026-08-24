return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      local default_should_attach = opts.should_attach or require("copilot.config.should_attach").default

      opts.should_attach = function(bufnr, bufname)
        -- Keep default attach checks (buflisted, buftype, etc.)
        if default_should_attach and not default_should_attach(bufnr, bufname) then
          return false
        end

        -- Get file path
        local filepath = bufname or vim.api.nvim_buf_get_name(bufnr)
        if not filepath or filepath == "" then
          return true
        end

        -- Check if file is ignored by git
        local dir = vim.fs.dirname(filepath)
        local res = vim.system({ "git", "check-ignore", "-q", filepath }, { cwd = dir }):wait()

        -- If git check-ignore returns 0, the file is ignored
        if res.code == 0 then
          return false
        end

        return true
      end
    end,
  },
}
