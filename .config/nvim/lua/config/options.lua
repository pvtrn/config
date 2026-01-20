-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Отключаем плавную прокрутку (snacks.nvim)
vim.g.snacks_animate_scroll = false

-- Russian keyboard layout support
-- All vim commands work in Russian layout without switching
vim.opt.langmap = table.concat({
  -- Lowercase: Russian -> English
  "йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ]",
  "фa,ыs,вd,аf,пg,рh,оj,лk,дl,ж\\;,э'",
  "яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.",
  -- Uppercase: Russian -> English
  "ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ъ}",
  'ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж:,Э"',
  "ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>",
}, ",")

-- Use system clipboard for yank/paste (y, p работают с Cmd+V)
vim.opt.clipboard = "unnamedplus"

-- OSC52 support for remote clipboard (works over SSH with iTerm2)
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

-- ============================================
-- Claude Code Integration (via claudecode.nvim plugin)
-- ============================================

-- Auto-reload files when changed outside Neovim
-- This is crucial for Claude Code integration - when Claude modifies files,
-- Neovim will automatically reload them
vim.opt.autoread = true
vim.opt.updatetime = 300  -- Faster CursorHold (300ms instead of 4s)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
  desc = "Auto-reload files changed outside Neovim",
})

-- Notify when file is auto-reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    local filename = vim.fn.expand("%:~:.") -- Относительный путь или ~ для home
    vim.notify("File reloaded: " .. filename, vim.log.levels.INFO)
  end,
  desc = "Notify on file reload",
})

-- Map "protobuf" to "proto" parser for markdown code blocks
vim.treesitter.language.register("proto", "protobuf")
