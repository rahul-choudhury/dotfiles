return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "windwp/nvim-ts-autotag",
  },
  opts = {
    ensure_installed = {
      "cpp",
      "css",
      "html",
      "markdown",
      "javascript",
      "typescript",
      "tsx",
      "lua",
      "vim",
      "vimdoc",
    },
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
