return {
  -- Подсветка и навигация по TODO комментариям
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
      signs = true,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                         desc = "Todo comments" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  -- Org-mode для заметок и задач
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "./.org/**/*", "./**.org" },
        org_default_notes_file = "./.org/plan.org",
        org_todo_keywords = { "BACKLOG", "TODO", "IN-PROGRESS", "REVIEW", "TESTING", "|", "DONE", "CANCELLED" },
        win_split_mode = "horizontal", -- Исправляет конфликт с nui.nvim
        org_capture_templates = {
          t = { description = "Task", template = "* TODO %?\n  %u", target = "./.org/todo.org" },
          n = { description = "Note", template = "* %?\n  %u", target = "./.org/notes.org" },
          b = { description = "Backlog", template = "* BACKLOG %? :backlog:\n  %u", target = "./.org/backlog.org" },
        },
        mappings = {
          org = {
            org_toggle_checkbox = '<leader>ox',
            org_todo = '<leader>ot',
          },
        },
      })

      -- Обновляем snacks explorer после записи org файлов
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.org",
        callback = function()
          vim.defer_fn(function()
            -- Симулируем нажатие 'u' в explorer для обновления
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.bo[buf].filetype
              if ft == "snacks_picker_list" then
                local current_win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(win)
                vim.cmd("normal u")
                vim.api.nvim_set_current_win(current_win)
                break
              end
            end
          end, 200)
        end,
      })
    end,
    keys = {
      { "<leader>oa", "<cmd>lua require('orgmode').action('agenda.prompt')<cr>",                desc = "Org Agenda" },
      { "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<cr>",               desc = "Org Capture" },
      { "<leader>ox", "<cmd>lua require('orgmode').action('org_mappings.toggle_checkbox')<cr>", desc = "Toggle checkbox",  ft = "org" },
      { "<leader>ot", "<cmd>lua require('orgmode').action('org_mappings.todo_next_state')<cr>", desc = "Cycle TODO state", ft = "org" },
    },
  },

  -- Zettelkasten заметки с zk-nvim
  {
    "zk-org/zk-nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    config = function()
      require("zk").setup({
        picker = "telescope",
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
    end,
    keys = {
      { "<leader>zn", "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>",                               desc = "New note" },
      { "<leader>zo", "<cmd>ZkNotes { sort = { 'modified' } }<cr>",                                       desc = "Open notes" },
      { "<leader>zt", "<cmd>ZkTags<cr>",                                                                  desc = "Open by tag" },
      { "<leader>zf", "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<cr>", desc = "Find notes" },
      { "<leader>zl", "<cmd>ZkLinks<cr>",                                                                 desc = "Show links" },
      { "<leader>zb", "<cmd>ZkBacklinks<cr>",                                                             desc = "Show backlinks" },
      { "<leader>zi", "<cmd>ZkInsertLink<cr>",                                                            desc = "Insert link",   mode = { "n", "v" } },
    },
  },
}
