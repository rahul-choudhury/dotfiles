return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = false,
    format_after_save = {
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      html = { { "prettierd", "prettier" } },
      css = { { "prettierd", "prettier" } },
      javascript = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },
    },
  },
}
