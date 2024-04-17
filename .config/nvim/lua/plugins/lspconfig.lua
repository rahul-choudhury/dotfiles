return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func)
          vim.keymap.set("n", keys, func, { buffer = event.buf })
        end

        map("gd", require("telescope.builtin").lsp_definitions)
        map("gr", require("telescope.builtin").lsp_references)
        map("gI", require("telescope.builtin").lsp_implementations)
        map("<leader>D", require("telescope.builtin").lsp_type_definitions)
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols)
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols)

        map("<leader>rn", vim.lsp.buf.rename)
        map("<leader>ca", vim.lsp.buf.code_action)

        map("K", vim.lsp.buf.hover)
        map("<C-k>", vim.lsp.buf.signature_help)

        map("gD", vim.lsp.buf.declaration)
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
      clangd = {},
      rust_analyzer = {},
      tailwindcss = {},
      tsserver = {},
      eslint = {},
      cssls = {
        settings = {
          css = {
            validate = true,
            lint = { unknownAtRules = "ignore" },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      },
    }

    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua",
      "prettierd",
      "clang-format",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })

    -- gleam lsp is included with the install package
    require("lspconfig").gleam.setup({})

    vim.diagnostic.config({ float = { border = "rounded" } })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
  end,
}
