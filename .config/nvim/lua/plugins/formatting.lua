return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = false,
    format_after_save = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      cpp = { "clang-format" },
      lua = { "stylua" },
      html = { "prettier" },
      css = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
    },
  },
}
