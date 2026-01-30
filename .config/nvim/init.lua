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
vim.opt.winborder = "single"

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

require("lazy").setup({
  ui = {
    border = "single",
    backdrop = 100,
  },
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
        local languages = {
          "css",
          "git_rebase",
          "gitcommit",
          "go",
          "gomod",
          "gosum",
          "javascript",
          "json",
          "sql",
          "tsx",
          "typescript",
        }
        require("nvim-treesitter").install(languages)

        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("treesitter.setup", {}),
          callback = function(args)
            local buf = args.buf
            local filetype = args.match

            local language = vim.treesitter.language.get_lang(filetype) or filetype
            if not vim.treesitter.language.add(language) then
              return
            end

            vim.treesitter.start(buf, language)
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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

    {
      "mason-org/mason.nvim",
      opts = {
        ui = {
          backdrop = 100,
        },
      },
    },

    {
      "neovim/nvim-lspconfig",
      config = function()
        vim.lsp.config("vtsls", {
          settings = {
            vtsls = { autoUseWorkspaceTsdk = true },
          },
        })

        vim.lsp.config("tailwindcss", {
          settings = {
            tailwindCSS = {
              classFunctions = { "cva", "cx" },
            },
          },
        })

        vim.lsp.config("cssls", {
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        })

        vim.lsp.enable({
          "gopls",
          "vtsls",
          "eslint",
          "biome",
          "tailwindcss",
          "cssls",
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
          css = { "biome", "prettier", stop_after_first = true },
          javascript = { "biome", "prettier", stop_after_first = true },
          typescript = { "biome", "prettier", stop_after_first = true },
          javascriptreact = { "biome", "prettier", stop_after_first = true },
          typescriptreact = { "biome", "prettier", stop_after_first = true },
          markdown = { "prettier" },
          json = { "biome", "prettier", stop_after_first = true },
        },
      },
    },

    {
      "ibhagwan/fzf-lua",
      config = function()
        local fzf_lua = require("fzf-lua")

        fzf_lua.setup({
          hls = {
            border = "FloatBorder",
          },
          keymap = {
            fzf = {
              ["ctrl-q"] = "select-all+accept",
            },
          },
          winopts = {
            border = "single",
            backdrop = 100,
            width = 0.50,
            height = 0.50,
            preview = {
              hidden = true,
            },
          },
        })

        vim.keymap.set("n", "<C-p>", fzf_lua.files)
        vim.keymap.set("n", "<C-g>", fzf_lua.grep)
      end,
    },

    {
      "sourcegraph/amp.nvim",
      branch = "main",
      lazy = false,
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
