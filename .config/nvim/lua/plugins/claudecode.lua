-- Claude Code Neovim integration
-- Default minimal configuration from official repository
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },

  opts = {
    -- Custom terminal command with --continue flag
    -- terminal_cmd = "codex",
    -- Auto-focus Claude terminal after sending selection
    focus_after_send = true,

    diff_opts = {
      auto_close_on_accept = true, -- close diff windows after accepting
      vertical_split = true, -- use vertical splits for diffs
      open_in_current_tab = false, -- don't create new tabs
      keep_terminal_focus = true, -- keep focus on claude terminal
    },
  },

  -- Key mappings
  config = true,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
