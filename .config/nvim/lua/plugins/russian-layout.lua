-- Добавляем русские дубликаты для стандартных LazyVim хоткеев
-- Этот файл автоматически дублирует самые используемые хоткеи для работы с русской раскладкой

return {
  -- Telescope (поиск и навигация)
  {
    "nvim-telescope/telescope.nvim",
    keys = function()
      local builtin = require("telescope.builtin")

      -- Функция для получения русского дубликата хоткея
      local en_to_ru = {
        s = "ы", g = "п", f = "а", b = "и", w = "ц", h = "р", r = "к",
        c = "с", m = "ь", k = "л", q = "й", n = "т", e = "у", o = "щ",
        S = "Ы", G = "П", F = "А", B = "И", W = "Ц", H = "Р", R = "К",
      }

      local function en_to_ru_key(key)
        local result = key
        for en, ru in pairs(en_to_ru) do
          result = result:gsub(en, ru)
        end
        return result
      end

      -- Создаем пары хоткеев (английский + русский)
      local function both(en_key, action, desc)
        local ru_key = en_to_ru_key(en_key)
        return {
          { en_key, action, desc = desc },
          { ru_key, action, desc = desc },
        }
      end

      local keys = {}

      -- Search группа (<leader>s)
      for _, key in ipairs({
        both("<leader>sg", builtin.live_grep, "Grep (root dir)"),
        both("<leader>sG", builtin.live_grep, "Grep (cwd)"),
        both("<leader>sw", builtin.grep_string, "Word (root dir)"),
        both("<leader>sW", builtin.grep_string, "Word (cwd)"),
        both("<leader>ss", builtin.lsp_document_symbols, "Goto Symbol"),
        both("<leader>sS", builtin.lsp_dynamic_workspace_symbols, "Goto Symbol (Workspace)"),
        both("<leader>sc", builtin.command_history, "Command History"),
        both("<leader>sC", builtin.commands, "Commands"),
        both("<leader>sh", builtin.help_tags, "Help Pages"),
        both("<leader>sH", builtin.man_pages, "Man Pages"),
        both("<leader>sk", builtin.keymaps, "Key Maps"),
        both("<leader>sm", builtin.marks, "Jump to Mark"),
        both("<leader>so", builtin.vim_options, "Options"),
        both("<leader>sr", builtin.oldfiles, "Recent"),
        both("<leader>sR", builtin.resume, "Resume"),

        -- Find группа (<leader>f)
        both("<leader>ff", builtin.find_files, "Find Files (root dir)"),
        both("<leader>fF", builtin.find_files, "Find Files (cwd)"),
        both("<leader>fr", builtin.oldfiles, "Recent"),
        both("<leader>fb", builtin.buffers, "Buffers"),

        -- Buffers (<leader>b)
        both("<leader>bb", builtin.buffers, "Switch Buffer"),
      }) do
        for _, k in ipairs(key) do
          table.insert(keys, k)
        end
      end

      return keys
    end,
  },

  -- Neo-tree (файловый менеджер)
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function()
      local function both(en_key, action, desc)
        local en_to_ru = { e = "у", E = "У" }
        local ru_key = en_key:gsub("[eE]", en_to_ru)
        return {
          { en_key, action, desc = desc },
          { ru_key, action, desc = desc },
        }
      end

      local keys = {}
      for _, key in ipairs({
        both("<leader>e", "<cmd>Neotree toggle<cr>", "Explorer NeoTree (root dir)"),
        both("<leader>E", "<cmd>Neotree toggle float<cr>", "Explorer NeoTree (float)"),
      }) do
        for _, k in ipairs(key) do
          table.insert(keys, k)
        end
      end

      return keys
    end,
  },

  -- Buffer management
  {
    "akinsho/bufferline.nvim",
    keys = function()
      local function both(en_key, action, desc)
        local en_to_ru = {
          h = "р", l = "д", p = "з", b = "и",
          H = "Р", L = "Д", P = "З", B = "И",
        }
        local ru_key = en_key
        for en, ru in pairs(en_to_ru) do
          ru_key = ru_key:gsub(en, ru)
        end
        return {
          { en_key, action, desc = desc },
          { ru_key, action, desc = desc },
        }
      end

      local keys = {}
      for _, key in ipairs({
        both("<leader>bp", "<Cmd>BufferLineTogglePin<CR>", "Toggle pin"),
        both("<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete non-pinned buffers"),
        both("[b", "<cmd>bprevious<cr>", "Prev buffer"),
        both("]b", "<cmd>bnext<cr>", "Next buffer"),
        both("<S-h>", "<cmd>bprevious<cr>", "Prev buffer"),
        both("<S-l>", "<cmd>bnext<cr>", "Next buffer"),
      }) do
        for _, k in ipairs(key) do
          table.insert(keys, k)
        end
      end

      return keys
    end,
  },

  -- Which-key hints для русских хоткеев
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}

      -- Добавляем описания для русских групп
      vim.list_extend(opts.spec, {
        { "<leader>ы", group = "search" },
        { "<leader>а", group = "file/find" },
        { "<leader>и", group = "buffer" },
        { "<leader>с", group = "code" },
        { "<leader>в", group = "debug" },
        { "<leader>е", group = "test" },
        { "<leader>п", group = "git" },
        { "<leader>г", group = "ui" },
        { "<leader>ц", group = "windows" },
        { "<leader>х", group = "quit/session" },
      })

      return opts
    end,
  },
}
