-- ASCII diagram drawing
-- Usage:
-- 1. Enter Visual Block mode: Ctrl+v
-- 2. Select area
-- 3. :VBox - draw box around selection
-- Toggle "draw mode" with <leader>v
return {
  "jbyuki/venn.nvim",
  keys = {
    {
      "<leader>v",
      function()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.opt_local.virtualedit = "all"
          -- Draw line with HJKL
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
          -- Draw box with f
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
          vim.notify("Venn drawing mode ON", vim.log.levels.INFO)
        else
          vim.b.venn_enabled = nil
          vim.opt_local.virtualedit = ""
          vim.api.nvim_buf_del_keymap(0, "n", "J")
          vim.api.nvim_buf_del_keymap(0, "n", "K")
          vim.api.nvim_buf_del_keymap(0, "n", "L")
          vim.api.nvim_buf_del_keymap(0, "n", "H")
          vim.api.nvim_buf_del_keymap(0, "v", "f")
          vim.notify("Venn drawing mode OFF", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle Venn drawing mode",
    },
  },
}
