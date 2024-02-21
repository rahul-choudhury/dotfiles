return {
  "nvim-treesitter/nvim-treesitter",
  -- kanagawa uses old highlight groups
  -- version = "0.9.2",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "windwp/nvim-ts-autotag",
  },
  build = ":TSUpdate",
  config = function()
    -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
    vim.defer_fn(function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,

        autotag = { enable = true },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end, 0)
  end,
}
