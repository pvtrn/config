-- Mapping английских букв в русские (QWERTY -> ЙЦУКЕН)
local en_to_ru = {
  q = "й",
  w = "ц",
  e = "у",
  r = "к",
  t = "е",
  y = "н",
  u = "г",
  i = "ш",
  o = "щ",
  p = "з",
  a = "ф",
  s = "ы",
  d = "в",
  f = "а",
  g = "п",
  h = "р",
  j = "о",
  k = "л",
  l = "д",
  z = "я",
  x = "ч",
  c = "с",
  v = "м",
  b = "и",
  n = "т",
  m = "ь",
  Q = "Й",
  W = "Ц",
  E = "У",
  R = "К",
  T = "Е",
  Y = "Н",
  U = "Г",
  I = "Ш",
  O = "Щ",
  P = "З",
  A = "Ф",
  S = "Ы",
  D = "В",
  F = "А",
  G = "П",
  H = "Р",
  J = "О",
  K = "Л",
  L = "Д",
  Z = "Я",
  X = "Ч",
  C = "С",
  V = "М",
  B = "И",
  N = "Т",
  M = "Ь",
}

-- Функция для конвертации английского хоткея в русский
local function en_to_ru_keymap(keymap)
  local result = keymap
  for en, ru in pairs(en_to_ru) do
    result = result:gsub(en, ru)
  end
  return result
end

-- Helper для создания plugin keys с обеими раскладками
-- Автоматически создает русский дубликат
local function keys_both(en_key, action, desc)
  local ru_key = en_to_ru_keymap(en_key)
  return {
    { en_key, action, desc = desc },
    { ru_key, action, desc = desc },
  }
end

-- Helper для разворачивания массива keys_both в плоский список
local function flatten_keys(specs)
  local result = {}
  for _, spec in ipairs(specs) do
    for _, key in ipairs(spec) do
      table.insert(result, key)
    end
  end
  return result
end

return {
  -- VSCode Modern theme with transparent background
  {
    "pvtrn/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        cursorline = true,
        transparent_background = true,
        nvim_tree_darker = true,
      })
      vim.cmd.colorscheme("vscode")

      -- Отключаем подчёркивание во всех диагностиках LSP
      vim.diagnostic.config({
        underline = false,
      })
    end,
  },

  -- Set vscode as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },

  -- Enhanced Rust support (rustaceanvim config)
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    opts = function()
      return {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              checkOnSave = true,
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              -- Disable semantic highlighting (use treesitter instead)
              semanticHighlighting = {
                enable = false,
              },
              -- Inlay hints for better code understanding
              inlayHints = {
                enable = true,
                chainingHints = true,
                typeHints = true,
                parameterHints = true,
              },
            },
          },
        },
        -- DAP конфигурация через rustaceanvim
        dap = {
          adapter = {
            type = "server",
            port = "${port}",
            executable = {
              command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"),
              args = { "--port", "${port}" },
            },
          },
        },
      }
    end,
    keys = (function()
      -- Выносим функцию отладки теста, чтобы не дублировать
      local debug_test_fn = function()
        -- Асинхронная компиляция и запуск дебага (как в VSCode)
        local Job = require("plenary.job")
        local dap = require("dap")

        -- Находим имя функции под курсором через встроенный treesitter
        local test_name = nil
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row, col = cursor[1] - 1, cursor[2]

        -- Получаем treesitter parser
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "rust")
        if ok then
          local tree = parser:parse()[1]
          local node = tree:root():descendant_for_range(row, col, row, col)

          -- Поднимаемся вверх по дереву до function_item
          while node do
            if node:type() == "function_item" then
              for child in node:iter_children() do
                if child:type() == "identifier" then
                  test_name = vim.treesitter.get_node_text(child, bufnr)
                  break
                end
              end
              break
            end
            node = node:parent()
          end
        end

        -- Если не нашли через treesitter, используем <cword>
        if not test_name then
          test_name = vim.fn.expand("<cword>")
        end

        -- Находим корень workspace через git
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

        -- Используем git для поиска корня репозитория
        local git_root =
          vim.fn.system("cd " .. vim.fn.shellescape(current_dir) .. " && git rev-parse --show-toplevel 2>/dev/null")
        git_root = git_root:gsub("%s+$", "") -- Убираем trailing whitespace

        local workspace_root
        if git_root ~= "" and vim.fn.isdirectory(git_root) == 1 then
          workspace_root = git_root
        else
          -- Fallback на текущую директорию
          workspace_root = vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("/$", "")
        end

        -- Определяем папку проекта tolki-grpc-api (всегда полный путь)
        local project_dir = workspace_root .. "/tolki-grpc-api"

        -- Проверяем существование папки проекта
        if vim.fn.isdirectory(project_dir) == 0 then
          vim.notify("ERROR: Project directory not found: " .. project_dir, vim.log.levels.ERROR)
          vim.notify("Workspace root: " .. workspace_root, vim.log.levels.ERROR)
          vim.notify("Current file: " .. current_file, vim.log.levels.ERROR)
          return
        end

        vim.notify("Compiling test: " .. test_name, vim.log.levels.INFO)
        vim.notify("Project: " .. project_dir, vim.log.levels.INFO)

        Job
          :new({
            command = "bash",
            args = {
              "-c",
              string.format(
                'cd %s && cargo test --package tolki-grpc-api --lib --no-run && latest=$(find %s/target/debug/deps -name \'tolki_grpc_api-*\' -type f -executable ! -name \'*.d\' | head -n1) && [ -n "$latest" ] && ln -sf "$(basename "$latest")" %s/target/debug/deps/tolki_grpc_api-latest',
                project_dir,
                project_dir,
                project_dir
              ),
            },
            cwd = project_dir,
            on_exit = function(j, return_val)
              vim.schedule(function()
                if return_val == 0 then
                  local binary_path = project_dir .. "/target/debug/deps/tolki_grpc_api-latest"

                  -- Проверяем существование бинарника
                  if vim.fn.filereadable(binary_path) == 0 then
                    vim.notify("Test binary not found: " .. binary_path, vim.log.levels.ERROR)
                    return
                  end

                  vim.notify("Starting debugger for: " .. test_name, vim.log.levels.INFO)

                  -- Запускаем DAP с правильным cwd
                  dap.run({
                    type = "codelldb",
                    request = "launch",
                    name = "Debug test: " .. test_name,
                    program = binary_path,
                    args = { test_name, "--nocapture" },
                    cwd = project_dir,
                    stopOnEntry = false,
                    env = {
                      RUST_LOG = "info",
                    },
                    -- Перенаправляем вывод в DAP console
                    stdio = { nil, nil, nil }, -- stdin, stdout, stderr (nil = default)
                    terminal = "integrated",
                  })
                else
                  local stderr = table.concat(j:stderr_result(), "\n")
                  local stdout = table.concat(j:result(), "\n")

                  vim.notify("Compilation failed with exit code: " .. return_val, vim.log.levels.ERROR)

                  -- Показываем последние 20 строк вывода
                  local output = stderr ~= "" and stderr or stdout
                  if output ~= "" then
                    local lines = vim.split(output, "\n")
                    local start_idx = math.max(1, #lines - 20)
                    local last_lines = {}
                    for i = start_idx, #lines do
                      table.insert(last_lines, lines[i])
                    end
                    vim.notify("Last output:\n" .. table.concat(last_lines, "\n"), vim.log.levels.ERROR)
                  end
                end
              end)
            end,
          })
          :start()
      end

      local debuggables_fn = function()
        local ok = pcall(function()
          require("telescope").extensions.rustaceanvim.debuggables()
        end)
        if not ok then
          vim.cmd.RustLsp("debuggables")
        end
      end

      local runnables_fn = function()
        vim.cmd.RustLsp("runnables")
      end

      -- Возвращаем keys с автоматическими русскими дубликатами
      return flatten_keys({
        keys_both("<leader>td", debug_test_fn, "Debug test under cursor"),
        keys_both("<leader>tD", debuggables_fn, "Show all debuggables (picker)"),
        keys_both("<leader>tr", runnables_fn, "Rust runnables"),
      })
    end)(),
  },

  -- Better Cargo.toml support
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },

  -- Additional treesitter parsers for Rust
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "rust",
        "toml",
        "ron",
      },
    },
  },

  -- Remove clock from statusline (already in tmux)
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_z = {}
    end,
  },

  -- Neotest with neotest-rust adapter (works reliably)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust", -- Используем neotest-rust - он стабильнее
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust")({
            args = { "--no-capture" },
            -- НЕ используем dap_adapter - будем использовать rustaceanvim команды
          }),
        },
      })
    end,
    keys = flatten_keys({
      keys_both("<leader>tt", function()
        require("neotest").run.run()
      end, "Run nearest test"),
      keys_both("<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, "Run file tests"),
      keys_both("<leader>ts", function()
        require("neotest").summary.toggle()
      end, "Toggle test summary"),
      keys_both("<leader>to", function()
        require("neotest").output.open({ enter = true })
      end, "Show test output"),
    }),
  },

  -- DAP UI improvements
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Настройка UI для широкого монитора (57 дюймов) - дебаг справа, файлы слева
      dapui.setup({
        layouts = {
          {
            -- Вся информация для дебага на правой панели (не перекрывает neo-tree)
            elements = {
              { id = "scopes", size = 0.30 }, -- Переменные и их значения
              { id = "stacks", size = 0.20 }, -- Стек вызовов
              { id = "breakpoints", size = 0.15 }, -- Список брейкпоинтов
              { id = "watches", size = 0.15 }, -- Наблюдаемые переменные
              { id = "console", size = 0.20 }, -- DAP console (stdout/stderr)
            },
            size = 80, -- Ширина правой панели
            position = "right",
          },
        },
        controls = {
          enabled = true,
          element = "console", -- Кнопки управления (step over/into/out) в панели console
        },
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        render = {
          max_value_lines = 100, -- Показывать больше строк в переменных
        },
      })

      -- Автоматически открывать UI при старте дебага
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end

      -- Автоматически закрывать UI при завершении дебага
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Глобальные хоткеи для DAP UI (доступны всегда, с автоматической русской раскладкой)
      -- Используем локальную версию keymap_both_layouts
      local function keymap_both(mode, en_keys, action, opts)
        local ru_keys = en_to_ru_keymap(en_keys)
        vim.keymap.set(mode, en_keys, action, opts)
        vim.keymap.set(mode, ru_keys, action, opts)
      end

      keymap_both("n", "<leader>du", function()
        require("dapui").toggle({ reset = true })
      end, { desc = "Toggle DAP UI" })

      keymap_both({ "n", "v" }, "<leader>de", function()
        require("dapui").eval()
      end, { desc = "Eval under cursor" })

      keymap_both("n", "<leader>dC", function()
        require("dapui").float_element("console", { enter = true, width = 120, height = 40 })
      end, { desc = "Open console output (floating)" })
    end,
  },

  -- Breakpoint on mouse click (line number column)
  {
    "mfussenegger/nvim-dap",
    keys = flatten_keys({
      keys_both("<leader>db", function()
        require("dap").toggle_breakpoint()
      end, "Toggle breakpoint"),
      keys_both("<leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input("Condition: "))
      end, "Conditional breakpoint"),
      keys_both("<leader>dc", function()
        require("dap").continue()
      end, "Continue"),
      keys_both("<leader>di", function()
        require("dap").step_into()
      end, "Step into"),
      keys_both("<leader>do", function()
        require("dap").step_over()
      end, "Step over"),
      keys_both("<leader>dO", function()
        require("dap").step_out()
      end, "Step out"),
      keys_both("<leader>dr", function()
        require("dap").repl.toggle()
      end, "Toggle REPL"),
      keys_both("<leader>dl", function()
        require("dap").run_last()
      end, "Run last"),
      keys_both("<leader>dx", function()
        require("dap").terminate()
      end, "Terminate"),
      -- F-keys не дублируем, так как они не зависят от раскладки
      {
        {
          "<F5>",
          function()
            require("dap").continue()
          end,
          desc = "Continue",
        },
      },
      {
        {
          "<F9>",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle breakpoint",
        },
      },
      {
        {
          "<F10>",
          function()
            require("dap").step_over()
          end,
          desc = "Step over",
        },
      },
      {
        {
          "<F11>",
          function()
            require("dap").step_into()
          end,
          desc = "Step into",
        },
      },
      {
        {
          "<S-F11>",
          function()
            require("dap").step_out()
          end,
          desc = "Step out",
        },
      },
    }),
    config = function()
      local dap = require("dap")

      -- Регистрируем адаптер codelldb для nvim-dap
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"),
          args = { "--port", "${port}" },
        },
      }

      -- Красивые иконки для брейкпоинтов
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

      -- Цвета
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f9a825" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d2e" })

      -- Double-click = toggle breakpoint
      vim.keymap.set("n", "<2-LeftMouse>", function()
        require("dap").toggle_breakpoint()
      end, { desc = "Toggle breakpoint on double-click" })
    end,
  },

  -- Highlight references under cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      filetypes_denylist = {
        "neo-tree",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "lazy",
        "mason",
        "DressingInput",
        "NeogitStatus",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- Rainbow delimiters for nested brackets/parentheses
  -- {
  --   "HiPhish/rainbow-delimiters.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     local rainbow_delimiters = require("rainbow-delimiters")
  --     require("rainbow-delimiters.setup").setup({
  --       strategy = {
  --         [""] = rainbow_delimiters.strategy["global"],
  --         vim = rainbow_delimiters.strategy["local"],
  --       },
  --       query = {
  --         [""] = "rainbow-delimiters",
  --         lua = "rainbow-blocks",
  --       },
  --       priority = {
  --         [""] = 110,
  --         lua = 210,
  --       },
  --       highlight = {
  --         "RainbowDelimiterRed",
  --         "RainbowDelimiterYellow",
  --         "RainbowDelimiterBlue",
  --         "RainbowDelimiterOrange",
  --         "RainbowDelimiterGreen",
  --         "RainbowDelimiterViolet",
  --         "RainbowDelimiterCyan",
  --       },
  --     })
  --   end,
  -- },
}
