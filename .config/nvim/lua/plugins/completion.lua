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
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
  },
  config = function()
    local cmp = require("cmp")
    local ls = require("luasnip")

    ls.config.setup({})

    require("luasnip.loaders.from_lua").lazy_load({
      paths = {
        "~/.config/nvim/lua/snippets",
      },
    })

    ls.filetype_extend("typescript", { "javascript" })
    ls.filetype_extend("javascriptreact", { "javascript" })
    ls.filetype_extend("typescriptreact", { "javascriptreact", "javascript" })

    cmp.setup({
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-l>"] = cmp.mapping(function()
          if ls.expand_or_locally_jumpable() then
            ls.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if ls.locally_jumpable(-1) then
            ls.jump(-1)
          end
        end, { "i", "s" }),
      }),
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            nvim_lua = "[LSP]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            buffer = "[Buffer]",
          })[entry.source.name]

          return vim_item
        end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer", keyword_length = 5 },
      }),
    })
  end,
}
