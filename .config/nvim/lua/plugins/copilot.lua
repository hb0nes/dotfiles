vim.keymap.set("i", "<M-f>", "<Plug>(copilot-accept-word)")
vim.keymap.set("i", "<M-n>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<M-b>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<M-i>", "<Plug>(copilot-suggest)")
vim.keymap.set("i", "<C-space>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
