local treesitter_languages = {
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
vim.opt.winborder = "rounded"

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("pack-hooks", { clear = true }),
  callback = function(event)
    local spec = event.data.spec
    if spec.name == "nvim-treesitter" and (event.data.kind == "install" or event.data.kind == "update") then
      vim.system({ "nvim", "--headless", "-c", "TSUpdate", "-c", "qa" }, { text = true }):wait()
    end
  end,
})

vim.pack.add({
  "https://github.com/EdenEast/nightfox.nvim.git",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter.git", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context.git",
  "https://github.com/neovim/nvim-lspconfig.git",
  { src = "https://github.com/saghen/blink.cmp.git", version = vim.version.range("1") },
  "https://github.com/stevearc/conform.nvim.git",
  "https://github.com/ibhagwan/fzf-lua.git",
  "https://github.com/tpope/vim-fugitive.git",
  "https://github.com/tpope/vim-sleuth.git",
  "https://github.com/tpope/vim-vinegar.git",
  "https://github.com/windwp/nvim-ts-autotag.git",
  "https://github.com/windwp/nvim-autopairs.git",
  "https://github.com/folke/ts-comments.nvim.git",
  "https://github.com/kylechui/nvim-surround.git",
}, { load = true, confirm = false })

require("nightfox").setup({
  groups = {
    all = {
      NormalFloat = { bg = "NONE" },
    },
  },
})
vim.cmd.colorscheme("carbonfox")

require("nvim-treesitter").install(treesitter_languages)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter.setup", { clear = true }),
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

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

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
  "tailwindcss",
  "cssls",
})

require("blink.cmp").setup({
  keymap = { preset = "default" },
  cmdline = { enabled = false },
  completion = {
    menu = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
    },
    documentation = {
      window = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,EndOfBuffer:Normal",
      },
    },
  },
  signature = {
    window = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  },
})

require("conform").setup({
  format_after_save = { lsp_format = "fallback" },
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt" },
    css = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
  },
})

local fzf_lua = require("fzf-lua")

fzf_lua.setup({
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
})

vim.keymap.set("n", "<C-p>", fzf_lua.files)
vim.keymap.set("n", "<C-g>", fzf_lua.grep)

require("nvim-ts-autotag").setup()
require("nvim-autopairs").setup()
require("ts-comments").setup()
require("nvim-surround").setup()
