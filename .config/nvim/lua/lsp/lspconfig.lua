return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        vim.keymap.set("n", "grn", vim.lsp.buf.rename)
        vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action)
        vim.keymap.set("n", "grr", vim.lsp.buf.references)
        vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help)
      end,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      gleam = {},

      vtsls = {},
      eslint = {},
      html = {},
      jsonls = {},

      cssls = {
        settings = {
          css = {
            validate = true,
            lint = { unknownAtRules = "ignore" },
          },
        },
      },

      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "class:\\s*?[\"'`]([^\"'`]*).*?," },
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
          },
        },
      },
    }

    for server, opts in pairs(servers) do
      opts.capabilities = capabilities
      require("lspconfig")[server].setup(opts)
    end
  end,
}
