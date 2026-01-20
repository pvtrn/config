-- Локальная тема vscode.nvim
return {
  {
    dir = "~/vscode.nvim",
    name = "vscode",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        cursorline = true,
        transparent_background = true,
        nvim_tree_darker = true,
      })
      vim.cmd.colorscheme("vscode")

      -- Отключаем подчёркивание во всех диагностиках LSP
      vim.diagnostic.config({
        underline = false,
      })
    end,
  },

  -- Set vscode as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
