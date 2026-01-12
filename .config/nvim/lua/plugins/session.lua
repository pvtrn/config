-- Auto-save and restore sessions per directory
return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/",
    need = 1, -- minimum number of buffers to save session
    branch = true, -- save separate session per git branch
    pre_save = function()
      -- Закрываем проблемные окна перед сохранением сессии
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        -- Закрываем neo-tree, nvim-tree, и другие служебные буферы
        if vim.tbl_contains({ "neo-tree", "NvimTree", "dap-repl", "dapui_scopes", "dapui_stacks", "dapui_watches", "dapui_breakpoints", "dapui_console", "toggleterm", "Trouble" }, ft) then
          vim.api.nvim_win_close(win, true)
        end
      end
    end,
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save session" },
  },
  config = function(_, opts)
    require("persistence").setup(opts)

    -- Автоматически восстанавливать сессию при запуске
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
      callback = function()
        -- Восстанавливаем если: нет аргументов ИЛИ единственный аргумент - текущая директория
        local argc = vim.fn.argc()
        local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
        local no_args = argc == 0

        if (no_args or is_dir) and not vim.g.started_with_stdin then
          require("persistence").load()
        end
      end,
      nested = true,
    })
  end,
}
