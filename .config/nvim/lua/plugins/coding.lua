return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("cssls", {
        settings = {
          css = { lint = { unknownAtRules = "ignore" } },
          scss = { lint = { unknownAtRules = "ignore" } },
        },
      })

      vim.lsp.config("tailwindcss", {
        settings = {
          tailwindCSS = { classFunctions = { "cva", "cx" } },
        },
      })

      vim.lsp.enable({
        "gopls",
        "vtsls",
        "eslint",
        "cssls",
        "tailwindcss",
      })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      cmdline = { enabled = false },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      format_after_save = { lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofmt" },
        css = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },
}
