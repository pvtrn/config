-- Highlight references under cursor
return {
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
}
