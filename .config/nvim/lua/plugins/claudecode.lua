-- Claude Code Neovim integration
-- Using local fork with tmux provider support
return {
  dir = "~/claudecode-tmux.nvim",
  name = "claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    -- log_level = "debug",
    focus_after_send = true,
    terminal = {
      provider = "tmux",
      split_side = "right",
      split_width_percentage = 0.35,
    },
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = false,
      keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
    },
  },
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
