-- Supermaven AI code completion
return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter", -- Загружать при входе в режим вставки
  config = function()
    -- "supermaven-nvim".setup(opts)
    -- Подробнее в документации
    require("supermaven-nvim").setup({
      -- Keymaps
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      -- Игнорировать определенные типы файлов
      ignore_filetypes = {
        "gitcommit",
        "gitrebase",
      },
      -- Настройки цвета (используется hl группа)
      color = {
        suggestion_color = "#808080",
        cterm = 244,
      },
      -- Уровень логирования
      log_level = "info", -- trace, debug, info, warn, error, off
      -- Опции для отключения функций
      disable_inline_completion = false, -- отключить inline подсказки
      disable_keymaps = false, -- отключить стандартные hotkeys
    })
  end,
}
