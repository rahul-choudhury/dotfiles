-- h: lsp

-- LSP client keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    vim.keymap.set("n", "grn", vim.lsp.buf.rename)
    vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action)
    vim.keymap.set("n", "grr", vim.lsp.buf.references)
    vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help)
  end,
})

-- LSP server event handlers
-- Refer: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations

-- gleam
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gleam" },
  callback = function(ev)
    vim.lsp.start({
      name = "gleam",
      cmd = { "gleam", "lsp" },
      root_dir = vim.fs.root(ev.buf, { "gleam.toml" }),
    })
  end,
})

-- vtsls
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function(ev)
    vim.lsp.start({
      name = "vtsls",
      cmd = { "vtsls", "--stdio" },
      root_dir = vim.fs.root(ev.buf, { "tsconfig.json", "package.json", "jsconfig.json", ".git" }),
      single_file_support = true,
    })
  end,
})

-- eslint
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function(ev)
    vim.lsp.start({
      name = "eslint",
      cmd = { "vscode-eslint-language-server", "--stdio" },
      root_dir = vim.fs.root(ev.buf, {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        "eslint.config.ts",
        "eslint.config.mts",
        "eslint.config.cts",
      }),
      settings = {
        validate = "on",
        experimental = { useFlatConfig = false },
        rulesCustomizations = {},
        problems = { shortenToSingleLine = false },
        nodePath = "",
        codeAction = {
          disableRuleComment = { enable = true, location = "separateLine" },
          showDocumentation = { enable = true },
        },
      },
      handlers = {
        ["eslint/openDoc"] = function(_, result)
          -- opens eslint docs in the browser
          -- NOTE: this only works on mac. nvim-lspconfig docs have a cross-platform config.
          os.execute(string.format("open %q", result.url))
          return {}
        end,
      },
    })
  end,
})

-- tailwindcss
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "javascript", "typescript", "typescriptreact", "javascriptreact" },
  callback = function(ev)
    vim.lsp.start({
      name = "tailwindcss",
      cmd = { "tailwindcss-language-server", "--stdio" },
      root_dir = vim.fs.root(ev.buf, {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
        "package.json",
        "node_modules",
        ".git",
      }),
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
    })
  end,
})

-- html
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html" },
  callback = function(ev)
    -- Enable (broadcasting) snippet capability for completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.lsp.start({
      name = "html",
      cmd = { "vscode-html-language-server", "--stdio" },
      root_dir = vim.fs.root(ev.buf, { "package.json", ".git" }),
      init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = { css = true, javascript = true },
      },
      single_file_support = true,
      capabilities = capabilities,
    })
  end,
})

-- cssls
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css" },
  callback = function(ev)
    -- Enable (broadcasting) snippet capability for completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.lsp.start({
      name = "cssls",
      cmd = { "vscode-css-language-server", "--stdio" },
      root_dir = vim.fs.root(ev.buf, { "package.json", ".git" }),
      single_file_support = true,
      capabilities = capabilities,
    })
  end,
})
