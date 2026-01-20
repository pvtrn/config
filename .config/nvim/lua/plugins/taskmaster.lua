-- Task Master integration for Neovim
-- Provides commands and keybindings to interact with task-master CLI

return {
  dir = ".",
  name = "taskmaster",
  lazy = false,
  config = function()
    -- Task Master commands
    vim.api.nvim_create_user_command("TM", function(args)
      vim.cmd("!task-master " .. args.args)
    end, { nargs = "*", desc = "Task Master command" })

    vim.api.nvim_create_user_command("TMList", function()
      vim.cmd("botright split | resize 15 | terminal task-master list --with-subtasks")
    end, { desc = "List all tasks" })

    vim.api.nvim_create_user_command("TMNext", function()
      vim.cmd("botright split | resize 20 | terminal task-master next")
    end, { desc = "Show next task" })

    vim.api.nvim_create_user_command("TMAdd", function(args)
      vim.cmd('!task-master add-task --prompt="' .. args.args .. '"')
    end, { nargs = "+", desc = "Add new task" })

    vim.api.nvim_create_user_command("TMDone", function(args)
      vim.cmd("!task-master set-status " .. args.args .. " done")
    end, { nargs = 1, desc = "Mark task as done" })

    vim.api.nvim_create_user_command("TMStatus", function(args)
      local parts = vim.split(args.args, " ")
      if #parts >= 2 then
        vim.cmd("!task-master set-status " .. parts[1] .. " " .. parts[2])
      else
        print("Usage: TMStatus <id> <status>")
      end
    end, { nargs = "+", desc = "Set task status" })

    vim.api.nvim_create_user_command("TMShow", function(args)
      vim.cmd("botright split | resize 20 | terminal task-master show " .. args.args)
    end, { nargs = 1, desc = "Show task details" })

    vim.api.nvim_create_user_command("TMResearch", function(args)
      vim.cmd("botright split | terminal task-master research \"" .. args.args .. "\"")
    end, { nargs = "+", desc = "Research a topic" })

    vim.api.nvim_create_user_command("TMParsePRD", function(args)
      local file = args.args ~= "" and args.args or ".taskmaster/docs/prd.txt"
      vim.cmd("!task-master parse-prd " .. file)
    end, { nargs = "?", desc = "Parse PRD file" })

    vim.api.nvim_create_user_command("TMExpand", function(args)
      if args.args ~= "" then
        vim.cmd("!task-master expand --id=" .. args.args)
      else
        vim.cmd("!task-master expand --all")
      end
    end, { nargs = "?", desc = "Expand task(s) into subtasks" })

    -- Floating window for task list
    vim.api.nvim_create_user_command("TMFloat", function()
      local buf = vim.api.nvim_create_buf(false, true)
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
        title = " Task Master ",
        title_pos = "center",
      })
      vim.fn.termopen("task-master list --with-subtasks")
      vim.cmd("startinsert")
    end, { desc = "Open task list in floating window" })

    -- Keybindings (using <leader>t prefix for Tasks)
    vim.keymap.set("n", "<leader>tl", "<cmd>TMList<cr>", { desc = "List tasks" })
    vim.keymap.set("n", "<leader>tn", "<cmd>TMNext<cr>", { desc = "Next task" })
    vim.keymap.set("n", "<leader>tf", "<cmd>TMFloat<cr>", { desc = "Tasks (float)" })
    vim.keymap.set("n", "<leader>ta", ":TMAdd ", { desc = "Add task" })
    vim.keymap.set("n", "<leader>td", ":TMDone ", { desc = "Mark done" })
    vim.keymap.set("n", "<leader>ts", ":TMStatus ", { desc = "Set status" })
    vim.keymap.set("n", "<leader>tv", ":TMShow ", { desc = "View task" })
    vim.keymap.set("n", "<leader>tr", ":TMResearch ", { desc = "Research" })
    vim.keymap.set("n", "<leader>tp", "<cmd>TMParsePRD<cr>", { desc = "Parse PRD" })
    vim.keymap.set("n", "<leader>te", ":TMExpand ", { desc = "Expand task" })

    -- Register with which-key if available
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>t", group = "Task Master" },
      })
    end
  end,
}
