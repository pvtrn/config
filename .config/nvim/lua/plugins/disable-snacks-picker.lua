-- Настройки snacks
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- Показываем скрытые файлы и gitignored
            hidden = true,
            ignored = true,
            -- Отключаем watch чтобы избежать дублирования файлов
            watch = true,
            -- Убираем инпут для фильтрации
            win = {
              input = {
                keys = {
                  ["<Esc>"] = { "close", mode = { "n", "i" } },
                },
              },
            },
            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                backdrop = false,
                width = 32,
                min_width = 32,
                height = 0,
                position = "left",
                border = "none",
                box = "vertical",
                { win = "list", border = "none" },
              },
            },
          },
        },
      },
    },
  },
}
