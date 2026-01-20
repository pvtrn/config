-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Reload nvim configuration
vim.keymap.set("n", "<leader>r", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^config") then
      package.loaded[name] = nil
    end
  end
  require("config.options")
  require("config.keymaps")
  require("config.autocmds")
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end, { desc = "Reload nvim config" })

-- Ctrl+Arrow keys to switch between buffers (tabs)
vim.keymap.set("n", "<C-Left>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-Right>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

-- Alt+Shift+Arrow keys to switch between buffers (tabs)
vim.keymap.set("n", "<A-S-Left>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<A-S-Right>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
