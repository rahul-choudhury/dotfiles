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
vim.opt.signcolumn = "yes"

local FLOAT_BORDER_STYLE = "single"
local MAX_FLOAT_WIDTH = math.floor(vim.o.columns * 0.6)
local MAX_FLOAT_HEIGHT = 30

vim.diagnostic.config({
  float = {
    border = FLOAT_BORDER_STYLE,
    max_width = MAX_FLOAT_WIDTH,
    max_height = MAX_FLOAT_HEIGHT,
  },
})

vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({
    border = FLOAT_BORDER_STYLE,
    max_width = MAX_FLOAT_WIDTH,
    max_height = MAX_FLOAT_HEIGHT,
  })
end, { desc = "LSP Hover" })

vim.keymap.set("i", "<C-s>", function()
  vim.lsp.buf.signature_help({
    border = FLOAT_BORDER_STYLE,
    max_width = MAX_FLOAT_WIDTH,
    max_height = MAX_FLOAT_HEIGHT,
  })
end, { desc = "LSP Signature Help" })

vim.keymap.set("n", "<M-]>", vim.cmd.cnext)
vim.keymap.set("n", "<M-[>", vim.cmd.cprev)
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
        require("kanagawa").setup({
          colors = {
            theme = {
              all = {
                ui = {
                  bg_gutter = "none",
                },
              },
            },
          },
          overrides = function(colors)
            local theme = colors.theme
            return {
              NormalFloat = { bg = "none" },
              FloatBorder = { bg = "none" },
              FloatTitle = { bg = "none" },

              Pmenu = { fg = "none", bg = "none" },
              PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
              PmenuSbar = { bg = theme.ui.bg_m1 },
              PmenuThumb = { bg = theme.ui.bg_p2 },
              BlinkCmpMenuBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.bg },
            }
          end,
        })
        vim.cmd("colorscheme kanagawa")
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        local ts = require("nvim-treesitter")

        local pending_buffers = {}

        local function start_with_retry(buf, lang, attempts)
          attempts = attempts or 10
          local pending_key = buf .. ":" .. lang

          if not vim.api.nvim_buf_is_valid(buf) then
            pending_buffers[pending_key] = nil
            return
          end

          local ok = pcall(vim.treesitter.start, buf, lang)
          if ok then
            pending_buffers[pending_key] = nil
          elseif attempts > 0 then
            pending_buffers[pending_key] = true
            vim.defer_fn(function()
              start_with_retry(buf, lang, attempts - 1)
            end, 500)
          else
            pending_buffers[pending_key] = nil
          end
        end

        vim.api.nvim_create_autocmd("FileType", {
          callback = function(event)
            local lang = vim.treesitter.language.get_lang(event.match) or event.match
            local buf = event.buf

            start_with_retry(buf, lang)
            ts.install({ lang })
          end,
        })

        vim.api.nvim_create_autocmd("BufDelete", {
          callback = function(event)
            for key in pairs(pending_buffers) do
              if key:match("^" .. event.buf .. ":") then
                pending_buffers[key] = nil
              end
            end
          end,
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
        completion = {
          menu = { border = FLOAT_BORDER_STYLE },
          documentation = { window = { border = FLOAT_BORDER_STYLE } },
        },
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
          json = { "prettier" },
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
          winopts = {
            border = FLOAT_BORDER_STYLE,
            backdrop = 100,
            preview = { border = FLOAT_BORDER_STYLE },
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

    {
      "sourcegraph/amp.nvim",
      branch = "main",
      opts = { auto_start = true, log_level = "info" },
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
