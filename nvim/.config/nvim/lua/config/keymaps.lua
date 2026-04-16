-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>gd", "<cmd>CodeDiff<cr>", { desc = "CodeDiff" })
-- Maps <leader>cp to copy the relative path
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print("Copied relative path: " .. path)
end, { desc = "Copy relative path to clipboard" })
