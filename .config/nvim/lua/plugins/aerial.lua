-- Быстрая навигация по символам через treesitter (без ожидания LSP)
return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- Приоритет: сначала treesitter (мгновенно), потом LSP
    backends = { "treesitter", "lsp", "markdown", "man" },
    layout = {
      min_width = 30,
      default_direction = "right",
    },
    -- Автоматически закрывать после выбора
    close_on_select = true,
    -- Показывать превью при навигации
    show_guides = true,
    -- Фильтр символов для Rust
    filter_kind = false, -- показывать все символы
  },
  keys = {
    { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    { "<leader>cS", "<cmd>AerialNavToggle<cr>", desc = "Aerial Nav" },
    -- Быстрая навигация между символами
    { "[s", "<cmd>AerialPrev<cr>", desc = "Previous symbol" },
    { "]s", "<cmd>AerialNext<cr>", desc = "Next symbol" },
    -- Telescope интеграция
    {
      "<leader>ss",
      "<cmd>Telescope aerial<cr>",
      desc = "Goto Symbol (Aerial/Treesitter)",
    },
  },
  config = function(_, opts)
    require("aerial").setup(opts)
    -- Telescope интеграция
    pcall(function()
      require("telescope").load_extension("aerial")
    end)
  end,
}
