return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = false,
    format_on_save = {
      lsp_fallback = true,
    },
    formatters_by_ft = {
      c = { "clang_format" },
      cpp = { "clang_format" },
      lua = { "stylua" },
      html = { "prettierd" },
      css = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
    },
  },
}
