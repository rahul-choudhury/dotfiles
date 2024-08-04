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
vim.opt.updatetime = 100
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.pumheight = 15

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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

require("lazy").setup({
  "tpope/vim-fugitive",
  "tpope/vim-sleuth",
  "tpope/vim-vinegar",
  "github/copilot.vim",

  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },

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
      require("fzf-lua").setup({
        winopts = {
          split = "belowright 15new",
          preview = { hidden = "hidden" },
        },
      })
      vim.keymap.set("n", "<C-p>", require("fzf-lua").files)
      vim.keymap.set("n", [[<C-\>]], require("fzf-lua").buffers)
      vim.keymap.set("n", "<C-g>", require("fzf-lua").grep)
      vim.keymap.set("n", "<C-l>", require("fzf-lua").live_grep)
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = false,
      format_after_save = { lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier" },
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

  { import = "plugins" },
})
