-- Protocol Buffers support
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        buf_ls = {
          cmd = { "buf", "lsp", "serve" },
          filetypes = { "proto" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("buf.yaml", "buf.work.yaml", ".git")(fname)
          end,
        },
      },
    },
  },
}
