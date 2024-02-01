return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      local actions = require("fzf-lua.actions")
      fzf.setup({
        buffers = {
          actions = {
            ["ctrl-d"] = { fn = actions.buf_del, reload = true },
          },
        },
      })
      vim.keymap.set("n", "<leader>g", fzf.live_grep_native)
      vim.keymap.set("n", "<leader>s", fzf.files)
      vim.keymap.set("n", "<leader>r", fzf.lsp_references)
      vim.keymap.set("n", "<leader>ld", fzf.lsp_workspace_diagnostics)
      vim.keymap.set("n", "<leader>ls", fzf.lsp_document_symbols)
      vim.keymap.set("n", "<leader>b", fzf.buffers)
      vim.keymap.set("n", "<leader>t", fzf.tabs)
      -- calling `setup` is optional for customization
    end,
  },
}
