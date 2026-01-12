-- Scrollbar with diagnostics, search, and git markers
return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",
  opts = {
    show_in_active_only = true,
    hide_if_all_visible = true, -- Скрыть если файл помещается на экран
    handle = {
      blend = 30, -- Прозрачность
    },
    marks = {
      Search = { color = "#ff9e64" },
      Error = { color = "#db4b4b" },
      Warn = { color = "#e0af68" },
      Info = { color = "#0db9d7" },
      Hint = { color = "#1abc9c" },
      Misc = { color = "#9d7cd8" },
      GitAdd = { color = "#449dab" },
      GitChange = { color = "#6183bb" },
      GitDelete = { color = "#914c54" },
    },
    handlers = {
      diagnostic = true,
      search = false, -- Требует nvim-hlslens
      gitsigns = true, -- Требует gitsigns.nvim
    },
  },
}
