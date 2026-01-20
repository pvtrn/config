return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  opts = {
    heading = { enabled = false },
    code = { enabled = false },
    dash = { enabled = false },
    bullet = { enabled = false },
    checkbox = { enabled = false },
    quote = { enabled = false },
    link = { enabled = false },
    sign = { enabled = false },

    pipe_table = {
      enabled = true,
      preset = "none",  -- острые углы
      style = "full",
      cell = "padded",
    },

    -- Убрать фон у таблиц
    overrides = {
      buftype = {
        nofile = { pipe_table = { enabled = false } },
      },
    },
  },
}
