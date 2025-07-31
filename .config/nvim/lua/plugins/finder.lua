return {
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

    vim.keymap.set("n", [[<C-\>]], fzf_lua.buffers)
    vim.keymap.set("n", "<C-p>", fzf_lua.files)
    vim.keymap.set("n", "<C-g>", fzf_lua.grep)
  end,
}
