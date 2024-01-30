return {
  "numToStr/Comment.nvim",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  config = function()
    vim.g.skip_ts_context_commentstring_module = true

    local commentstring = "ts_context_commentstring"
    local integrations = "ts_context_commentstring.integrations.comment_nvim"

    require(commentstring).setup({
      enable_autocmd = false,
    })

    require("Comment").setup({
      pre_hook = require(integrations).create_pre_hook(),
    })
  end,
}
