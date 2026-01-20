return {
  "Wansmer/langmapper.nvim",
  lazy = false,
  priority = 1, -- загружается первым, до всех плагинов
  config = function()
    require("langmapper").setup({
      hack_keymap = true,
      map_all_ctrl = true,
      default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>:"{}~abcdefghijklmnopqrstuvwxyz,.;'[]`]],
      layouts = {
        ru = {
          id = "ru",
          layout = [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯБЮЖЭХЪЁфисвуапршолдьтщзйкыегмцчнябюжэхъё]],
        },
      },
      -- Скрыть русские маппинги из which-key
      automapping_opts = {
        desc_as_original = true, -- не дублировать описания
      },
    })

    -- Применить ко всем существующим маппингам, но скрыть из which-key
    vim.defer_fn(function()
      require("langmapper").automapping({
        global = true,
        buffer = true,
        silent = true, -- скрыть из which-key
      })
    end, 100)
  end,
}
