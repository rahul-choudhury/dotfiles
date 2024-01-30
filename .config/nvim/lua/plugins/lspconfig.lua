return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func)
        vim.keymap.set("n", keys, func, { buffer = bufnr })
      end

      nmap("<leader>rn", vim.lsp.buf.rename)
      nmap("<leader>ca", vim.lsp.buf.code_action)

      nmap("gd", require("telescope.builtin").lsp_definitions)
      nmap("gr", require("telescope.builtin").lsp_references)
      nmap("gI", require("telescope.builtin").lsp_implementations)
      nmap("<leader>D", require("telescope.builtin").lsp_type_definitions)
      nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols)
      nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols)

      nmap("K", vim.lsp.buf.hover)
      nmap("<C-k>", vim.lsp.buf.signature_help)

      nmap("gD", vim.lsp.buf.declaration)
    end

    require("mason").setup()
    require("mason-lspconfig").setup()

    local servers = {
      clangd = {},
      rust_analyzer = {},
      tailwindcss = {},
      tsserver = {},
      eslint = {},
      cssls = {
        css = {
          validate = true,
          lint = { unknownAtRules = "ignore" },
        },
      },
      lua_ls = {
        Lua = {
          diagnostics = { disable = { "missing-fields" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    require("neodev").setup()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        })
      end,
    })

    -- rounded borders for lsp documentation
    vim.diagnostic.config({ float = { border = "rounded" } })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
  end,
}
