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
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"

vim.keymap.set("n", "<M-j>", vim.cmd.cnext)
vim.keymap.set("n", "<M-k>", vim.cmd.cprev)
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
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
      require("rose-pine").setup({ styles = { italic = false } })
      vim.cmd("colorscheme rose-pine-moon")
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
        keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
      })

      vim.keymap.set("n", "<leader>ff", fzf_lua.files)
      vim.keymap.set("n", "<leader>fg", fzf_lua.grep)
      vim.keymap.set("n", "<leader>fl", fzf_lua.live_grep)
      vim.keymap.set("n", "<leader>fb", fzf_lua.buffers)
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)
      vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list(), {
          title_pos = "center",
        })
      end)

      vim.keymap.set("n", "<C-h>", function()
        harpoon:list():select(1)
      end)
      vim.keymap.set("n", "<C-j>", function()
        harpoon:list():select(2)
      end)
      vim.keymap.set("n", "<C-k>", function()
        harpoon:list():select(3)
      end)
      vim.keymap.set("n", "<C-l>", function()
        harpoon:list():select(4)
      end)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          vim.keymap.set("n", "grn", vim.lsp.buf.rename)
          vim.keymap.set("n", "gra", vim.lsp.buf.code_action)
          vim.keymap.set("n", "grr", vim.lsp.buf.references)
          vim.keymap.set({ "n", "s" }, "<C-s>", vim.lsp.buf.signature_help)
        end,
      })

      local servers = {
        gleam = {},
        gopls = {},
        zls = {},
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

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      for server, opts in pairs(servers) do
        opts.capabilities = capabilities
        require("lspconfig")[server].setup(opts)
      end
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    opts = { sources = { cmdline = {} } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = false,
      format_after_save = { lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },

  { "windwp/nvim-ts-autotag", opts = {} },
  { "windwp/nvim-autopairs", opts = {} },
  { "folke/ts-comments.nvim", opts = {} },
  { "kylechui/nvim-surround", opts = {} },
})
