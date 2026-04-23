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

vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line without yanking" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete character without yanking" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without yanking" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change to end of line without yanking" })
