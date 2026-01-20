-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable spell checking for markdown files (Russian words get underlined)
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Fix terminal buffer jumping/flickering when logs are added
-- scrolloff causes terminal to jump when new lines appear
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings: no scrolloff, no numbers, start in insert mode",
})

-- Auto enter insert mode when switching to terminal buffer
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
  desc = "Auto insert mode in terminal",
})
