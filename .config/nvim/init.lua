local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
vim.opt.signcolumn = "number"

vim.keymap.set("n", "<M-]>", vim.cmd.cnext)
vim.keymap.set("n", "<M-[>", vim.cmd.cprev)
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

require("lazy").setup({
  spec = {
    {
      "rebelot/kanagawa.nvim",
      priority = 1000,
      config = function()
        vim.cmd("colorscheme kanagawa")
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
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

    { "mason-org/mason.nvim", opts = {} },

    {
      "neovim/nvim-lspconfig",
      config = function()
        vim.lsp.config("cssls", {
          settings = {
            css = { lint = { unknownAtRules = "ignore" } },
            scss = { lint = { unknownAtRules = "ignore" } },
          },
        })

        vim.lsp.config("tailwindcss", {
          settings = {
            tailwindCSS = { classFunctions = { "cva", "cx" } },
          },
        })

        vim.lsp.enable({
          "gopls",
          "vtsls",
          "eslint",
          "cssls",
          "tailwindcss",
        })
      end,
    },

    {
      "saghen/blink.cmp",
      version = "1.*",
      opts = {
        keymap = { preset = "default" },
        cmdline = { enabled = false },
      },
    },

    {
      "stevearc/conform.nvim",
      opts = {
        format_after_save = { lsp_format = "fallback" },
        formatters_by_ft = {
          lua = { "stylua" },
          go = { "gofmt" },
          css = { "prettier" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          markdown = { "prettier" },
        },
      },
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

        vim.keymap.set("n", "<leader>fb", fzf_lua.buffers)
        vim.keymap.set("n", "<leader>ff", fzf_lua.files)
        vim.keymap.set("n", "<leader>fg", fzf_lua.grep)
        vim.keymap.set("n", "<leader>lg", fzf_lua.live_grep)
        vim.keymap.set("n", "<leader>fw", fzf_lua.grep_cword)
        vim.keymap.set("n", "<leader>ds", fzf_lua.lsp_document_symbols)
        vim.keymap.set("n", "<leader>ws", fzf_lua.lsp_live_workspace_symbols)
      end,
    },

    "tpope/vim-fugitive",
    "tpope/vim-sleuth",
    "tpope/vim-vinegar",

    { "windwp/nvim-ts-autotag", opts = {} },
    { "windwp/nvim-autopairs", opts = {} },
    { "folke/ts-comments.nvim", opts = {} },
    { "kylechui/nvim-surround", opts = {} },
  },
})
