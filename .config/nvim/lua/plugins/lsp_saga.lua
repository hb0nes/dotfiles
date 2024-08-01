return {
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      lspsaga = require("lspsaga")
      vim.keymap.set("n", "L", ":Lspsaga peek_definition<CR>", { desc = "lsp peek definition" })
      lspsaga.setup({
        definition = {
          width = 0.8,
          height = 0.8,
          keys = {
            edit = "e",
            tabe = "t",
          },
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
}
