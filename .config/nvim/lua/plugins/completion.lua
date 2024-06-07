return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.executable("make") == 1 then
          return "make install_jsregexp"
        end
      end)(),
    },
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    luasnip.config.setup({})

    require("luasnip.loaders.from_lua").lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/snippets",
      },
    })

    luasnip.filetype_extend("typescript", { "javascript" })
    luasnip.filetype_extend("javascriptreact", { "javascript" })
    luasnip.filetype_extend("typescriptreact", { "javascriptreact", "javascript" })

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }),
    })
  end,
}
