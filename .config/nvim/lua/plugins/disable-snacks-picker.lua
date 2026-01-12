-- Настройки snacks
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- Показываем скрытые файлы
            hidden = true,
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
                width = 40,
                min_width = 40,
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
