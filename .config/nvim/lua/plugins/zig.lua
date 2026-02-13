-- Zig language support
return {
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zig" })
      end
    end,
  },

  -- LSP - Zig Language Server (zls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {
          -- ZLS settings
          settings = {
            zls = {
              enable_build_on_save = true,
              build_on_save_step = "check",
              enable_autofix = true,
              enable_snippets = true,
              enable_ast_check_diagnostics = true,
              enable_semantic_tokens = true,
              enable_inlay_hints = true,
              inlay_hints_show_builtin = true,
              inlay_hints_exclude_single_argument = true,
              inlay_hints_hide_redundant_param_names = true,
              inlay_hints_hide_redundant_param_names_last_token = true,
              warn_style = true,
              highlight_global_var_declarations = true,
            },
          },
        },
      },
    },
  },

  -- Mason - auto install zls
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zls" })
    end,
  },
}
