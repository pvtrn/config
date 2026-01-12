return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      highlights = {
        -- Фон линии табов
        fill = {
          bg = "#121212",
        },

        -- Неактивные табы (серый как в tmux)
        background = {
          fg = "#5A5A5A",
          bg = "#121212",
        },
        buffer_visible = {
          fg = "#5A5A5A",
          bg = "#121212",
        },

        -- Активный таб (прозрачный фон, белый текст)
        buffer_selected = {
          fg = "#FFFFFF",
          bg = "NONE",
          bold = false,
          italic = false,
        },

        -- Разделители
        separator = {
          fg = "#1e1e1e",
          bg = "#121212",
        },
        separator_visible = {
          fg = "#1e1e1e",
          bg = "#121212",
        },
        separator_selected = {
          fg = "#1e1e1e",
          bg = "NONE",
        },

        -- Индикатор активного таба (скрыт)
        indicator_selected = {
          fg = "#121212",
          bg = "NONE",
        },

        -- Modified (измененные файлы)
        modified = {
          fg = "#5A5A5A",
          bg = "#121212",
        },
        modified_visible = {
          fg = "#5A5A5A",
          bg = "#121212",
        },
        modified_selected = {
          fg = "#FFFFFF",
          bg = "NONE",
        },

        -- Duplicates (дубликаты имен файлов)
        duplicate = {
          fg = "#5A5A5A",
          bg = "#121212",
        },
        duplicate_visible = {
          fg = "#5A5A5A",
          bg = "#121212",
        },
        duplicate_selected = {
          fg = "#FFFFFF",
          bg = "NONE",
        },

        -- Close button
        close_button = {
          fg = "#5A5A5A",
          bg = "#121212",
        },
        close_button_visible = {
          fg = "#5A5A5A",
          bg = "#121212",
        },
        close_button_selected = {
          fg = "#FFFFFF",
          bg = "NONE",
        },
      },
    },
  },
}
