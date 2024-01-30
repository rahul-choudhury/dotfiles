return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          preview_width = 0.5,
        },
      },
    })

    pcall(require("telescope").load_extension("fzf"))

    local nmap = function(keys, func)
      vim.keymap.set("n", keys, func)
    end

    local builtin = require("telescope.builtin")

    nmap("<leader>sf", builtin.find_files)
    nmap("<leader>sw", builtin.grep_string)
    nmap("<leader>sg", builtin.live_grep)
    nmap("<leader>sh", builtin.help_tags)
    nmap("<leader>?", builtin.oldfiles)
    nmap("<leader><space>", builtin.buffers)
  end,
}
