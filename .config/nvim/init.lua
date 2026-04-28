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

local plugins = {
  { src = "https://github.com/EdenEast/nightfox.nvim.git" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter.git" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context.git" },
  { src = "https://github.com/neovim/nvim-lspconfig.git" },
  { src = "https://github.com/saghen/blink.cmp.git", version = vim.version.range("1") },
  { src = "https://github.com/stevearc/conform.nvim.git" },
  { src = "https://github.com/ibhagwan/fzf-lua.git" },
  { src = "https://github.com/tpope/vim-fugitive.git" },
  { src = "https://github.com/tpope/vim-sleuth.git" },
  { src = "https://github.com/tpope/vim-vinegar.git" },
  { src = "https://github.com/windwp/nvim-ts-autotag.git" },
  { src = "https://github.com/windwp/nvim-autopairs.git" },
  { src = "https://github.com/folke/ts-comments.nvim.git" },
  { src = "https://github.com/kylechui/nvim-surround.git" },
}

local lsps = {
  gopls = {},
  vtsls = {
    settings = {
      vtsls = { autoUseWorkspaceTsdk = true },
    },
  },
  eslint = {},
  tailwindcss = {
    settings = {
      tailwindCSS = {
        classFunctions = { "cva", "cx" },
      },
    },
  },
  cssls = {
    settings = {
      css = {
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  },
}

local formatters_by_ft = {
  lua = { "stylua" },
  go = { "gofmt" },
}

for _, filetype in ipairs({
  "css",
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "json",
  "jsonc",
}) do
  formatters_by_ft[filetype] = { "prettier" }
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
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
    local data = event.data
    if data.spec.name == "nvim-treesitter" and (data.kind == "install" or data.kind == "update") then
      if not data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add(plugins, { load = true, confirm = false })

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

for server, config in pairs(lsps) do
  vim.lsp.config(server, config)
end

vim.lsp.enable(vim.tbl_keys(lsps))

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
  formatters_by_ft = formatters_by_ft,
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
vim.keymap.set("n", "<C-l>", fzf_lua.live_grep)

require("nvim-ts-autotag").setup()
require("nvim-autopairs").setup()
require("ts-comments").setup()
require("nvim-surround").setup()
