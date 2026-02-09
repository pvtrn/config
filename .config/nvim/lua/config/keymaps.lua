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

-- Shift+Arrow keys to resize windows
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Close buffer but keep window open
vim.keymap.set("n", "<leader>x", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    vim.notify("Buffer has unsaved changes!", vim.log.levels.WARN)
    return
  end
  -- Switch to another buffer first, then delete current
  local alt = vim.fn.bufnr("#")
  if alt > 0 and alt ~= buf and vim.fn.buflisted(alt) == 1 then
    vim.cmd("b# | bd! " .. buf)
  else
    vim.cmd("enew | bd! " .. buf)
  end
end, { desc = "Close buffer (keep window)" })

-- Toggle line wrap
vim.keymap.set("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })
