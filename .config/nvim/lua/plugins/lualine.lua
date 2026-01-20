-- Statusline customization
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Remove clock from statusline (already in tmux)
    opts.sections.lualine_z = {}

    -- LSP progress indicator (показывает когда rust-analyzer индексирует)
    local function lsp_progress()
      local messages = vim.lsp.status()
      if messages and messages ~= "" then
        return "󰔟 " .. messages
      end
      return ""
    end

    -- Добавляем в секцию X
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 1, {
      lsp_progress,
      color = { fg = "#fab387" }, -- оранжевый цвет для заметности
    })
  end,
}
