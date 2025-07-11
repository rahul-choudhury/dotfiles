local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"

vim.keymap.set("n", "<M-]>", vim.cmd.cnext)
vim.keymap.set("n", "<M-[>", vim.cmd.cprev)
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".env.local", ".env.*.local" },
  callback = function()
    vim.bo.filetype = "sh"
  end,
})

require("lazy").setup({
  "tpope/vim-fugitive",
  "tpope/vim-sleuth",
  "tpope/vim-vinegar",

  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup()
      vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true })
    end,
  },

  {
    "ibhagwan/fzf-lua",
    config = function()
      local fzf_lua = require("fzf-lua")

      fzf_lua.setup({
        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          },
        },
      })

      vim.keymap.set("n", [[<C-\>]], fzf_lua.buffers)
      vim.keymap.set("n", "<C-p>", fzf_lua.files)
      vim.keymap.set("n", "<C-g>", fzf_lua.grep)
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      cmdline = {
        enabled = false,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local servers = {
        biome = {},
        clangd = {},
        gopls = {},
        vtsls = {
          settings = {
            vtsls = { autoUseWorkspaceTsdk = true },
          },
        },
        jsonls = {},
        eslint = {},
        html = {},
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = { unknownAtRules = "ignore" },
            },
            scss = {
              validate = true,
              lint = { unknownAtRules = "ignore" },
            },
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              classFunctions = { "cva", "cx" },
              experimental = {
                classRegex = {
                  { "class:\\s*?[\"'`]([^\"'`]*).*?," },
                },
              },
            },
          },
        },
      }

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      for server, opts in pairs(servers) do
        opts.capabilities = capabilities
        require("lspconfig")[server].setup(opts)
      end
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = false,
      format_after_save = { lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofmt" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        yml = { "prettier" },
      },
    },
  },

  { "windwp/nvim-ts-autotag", opts = {} },
  { "windwp/nvim-autopairs", opts = {} },
  { "folke/ts-comments.nvim", opts = {} },
  { "kylechui/nvim-surround", opts = {} },
})
