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

        -- future default mappings
        map("n", "grr", vim.lsp.buf.references)
        map("n", "grn", vim.lsp.buf.rename)
        map({ "n", "x" }, "gra", vim.lsp.buf.code_action)
        map("i", "<C-S>", vim.lsp.buf.signature_help)

        map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols)
        map("n", "<leader>ws", require("telescope.builtin").lsp_workspace_symbols)
      end,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      rust_analyzer = {},

      tsserver = {},
      tailwindcss = {},
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
    }

    for server, opts in pairs(servers) do
      opts.capabilities = capabilities
      require("lspconfig")[server].setup(opts)
    end
  end,
}
