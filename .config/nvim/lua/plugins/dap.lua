-- Debug Adapter Protocol (DAP) configuration
return {
  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.30 },
              { id = "stacks", size = 0.20 },
              { id = "breakpoints", size = 0.15 },
              { id = "watches", size = 0.15 },
              { id = "console", size = 0.20 },
            },
            size = 80,
            position = "right",
          },
        },
        controls = {
          enabled = true,
          element = "console",
        },
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        render = {
          max_value_lines = 100,
        },
      })

      -- Автоматически открывать/закрывать UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { "<leader>du", function() require("dapui").toggle({ reset = true }) end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Eval under cursor" },
      { "<leader>dC", function() require("dapui").float_element("console", { enter = true, width = 120, height = 40 }) end, desc = "Open console output (floating)" },
    },
  },

  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Step out" },
    },
    config = function()
      local dap = require("dap")

      -- Регистрируем адаптер codelldb
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"),
          args = { "--port", "${port}" },
        },
      }

      -- Иконки для брейкпоинтов
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
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
}
