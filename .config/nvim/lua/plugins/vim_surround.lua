return {
  {
    "tpope/vim-surround",
    dependencies = {
      "tpope/vim-commentary",
      "tpope/vim-repeat",
    },
    config = function()
      vim.keymap.set("n", "<leader>'", "ysiW'", { remap = true })
      vim.keymap.set("n", '<leader>"', 'ysiW"', { remap = true })
      vim.keymap.set("n", "<leader>[", "ysiw}", { remap = true })
      vim.keymap.set("n", "<leader>]", "ysiW}", { remap = true })
    end,
  },
}
