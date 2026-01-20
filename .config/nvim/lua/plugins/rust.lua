-- Rust support
return {
  -- Enhanced Rust support (rustaceanvim config)
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    init = function()
      -- Отключаем подчёркивания в Rust файлах
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function()
          vim.diagnostic.config({ underline = false })
        end,
      })
    end,
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
              -- Ускорение индексации
              cachePriming = {
                enable = true,
                numThreads = 4, -- Больше потоков для быстрой индексации
              },
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  ".github",
                  ".gitlab",
                  "node_modules",
                  "target",
                },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              semanticHighlighting = {
                enable = false,
              },
              inlayHints = {
                enable = true,
                chainingHints = true,
                typeHints = true,
                parameterHints = true,
              },
              -- Улучшенная навигация
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
            },
          },
        },
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
    keys = {
      {
        "<leader>td",
        function()
          -- Асинхронная компиляция и запуск дебага
          local Job = require("plenary.job")
          local dap = require("dap")

          -- Находим имя функции под курсором через treesitter
          local test_name = nil
          local bufnr = vim.api.nvim_get_current_buf()
          local cursor = vim.api.nvim_win_get_cursor(0)
          local row, col = cursor[1] - 1, cursor[2]

          local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "rust")
          if ok then
            local tree = parser:parse()[1]
            local node = tree:root():descendant_for_range(row, col, row, col)

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

          if not test_name then
            test_name = vim.fn.expand("<cword>")
          end

          local current_file = vim.api.nvim_buf_get_name(0)
          local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

          local git_root =
            vim.fn.system("cd " .. vim.fn.shellescape(current_dir) .. " && git rev-parse --show-toplevel 2>/dev/null")
          git_root = git_root:gsub("%s+$", "")

          local workspace_root
          if git_root ~= "" and vim.fn.isdirectory(git_root) == 1 then
            workspace_root = git_root
          else
            workspace_root = vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("/$", "")
          end

          local project_dir = workspace_root .. "/tolki-grpc-api"

          if vim.fn.isdirectory(project_dir) == 0 then
            vim.notify("ERROR: Project directory not found: " .. project_dir, vim.log.levels.ERROR)
            return
          end

          vim.notify("Compiling test: " .. test_name, vim.log.levels.INFO)

          Job:new({
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

                  if vim.fn.filereadable(binary_path) == 0 then
                    vim.notify("Test binary not found: " .. binary_path, vim.log.levels.ERROR)
                    return
                  end

                  vim.notify("Starting debugger for: " .. test_name, vim.log.levels.INFO)

                  dap.run({
                    type = "codelldb",
                    request = "launch",
                    name = "Debug test: " .. test_name,
                    program = binary_path,
                    args = { test_name, "--nocapture" },
                    cwd = project_dir,
                    stopOnEntry = false,
                    env = { RUST_LOG = "info" },
                    terminal = "integrated",
                  })
                else
                  local stderr = table.concat(j:stderr_result(), "\n")
                  local stdout = table.concat(j:result(), "\n")
                  vim.notify("Compilation failed with exit code: " .. return_val, vim.log.levels.ERROR)
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
          }):start()
        end,
        desc = "Debug test under cursor",
      },
      {
        "<leader>tD",
        function()
          local ok = pcall(function()
            require("telescope").extensions.rustaceanvim.debuggables()
          end)
          if not ok then
            vim.cmd.RustLsp("debuggables")
          end
        end,
        desc = "Show all debuggables (picker)",
      },
      {
        "<leader>tr",
        function()
          vim.cmd.RustLsp("runnables")
        end,
        desc = "Rust runnables",
      },
      -- Навигация
      {
        "<leader>rp",
        function()
          vim.cmd.RustLsp("parentModule")
        end,
        desc = "Go to parent module",
      },
      {
        "<leader>ro",
        function()
          vim.cmd.RustLsp("openDocs")
        end,
        desc = "Open docs.rs",
      },
      {
        "<leader>re",
        function()
          vim.cmd.RustLsp("explainError")
        end,
        desc = "Explain error",
      },
      {
        "<leader>rc",
        function()
          vim.cmd.RustLsp("openCargo")
        end,
        desc = "Open Cargo.toml",
      },
      {
        "K",
        function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end,
        desc = "Rust hover actions",
        ft = "rust",
      },
    },
  },

  -- Better Cargo.toml support
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },
}
