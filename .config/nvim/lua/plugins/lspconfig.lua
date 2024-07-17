return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(mode, keys, func)
          vim.keymap.set(mode, keys, func, { buffer = event.buf })
        end
        map("n", "gd", vim.lsp.buf.definition)

        map("n", "gA", vim.lsp.buf.references)
        map("n", "cd", vim.lsp.buf.rename)
        map("n", "g.", vim.lsp.buf.code_action)

        map("n", "gs", require("telescope.builtin").lsp_document_symbols)
        map("n", "gS", require("telescope.builtin").lsp_workspace_symbols)
      end,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      clangd = {},
      vtsls = {},
      eslint = {},
      html = {},

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
