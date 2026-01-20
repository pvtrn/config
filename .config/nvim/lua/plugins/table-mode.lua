return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "org", "text" },
  keys = {
    { "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle Table Mode" },
  },
  init = function()
    -- Использовать markdown-совместимые таблицы
    vim.g.table_mode_corner = "|"
  end,
}
