-- Keybinds
-- Switch windows in Neovim with alt shift + j/k/l/h
vim.keymap.set("n", "<C-A-j>", "<C-w>j")
vim.keymap.set("n", "<C-A-l>", "<C-w>l")
vim.keymap.set("n", "<C-A-k>", "<C-w>k")
vim.keymap.set("n", "<C-A-h>", "<C-w>h")

-- Save with sudo when typing :w!!
vim.api.nvim_set_keymap("c", "w!!", "w !sudo tee > /dev/null %", { noremap = true, silent = true })

-- Save with alt s
vim.keymap.set("n", "<A-s>", ":w<Cr>")

-- Close all but current win
vim.keymap.set("n", "<leader>q", ":only<CR>")

-- Show highlights
vim.keymap.set("n", "<leader>hi", ":so $VIMRUNTIME/syntax/hitest.vim<Cr>")
