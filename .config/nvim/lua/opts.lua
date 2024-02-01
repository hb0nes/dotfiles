-- Opts
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.signcolumn = "number"

-- Disable mouse
vim.o.mouse = ""

-- Better tabs
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Copy to clipboard on yank
vim.o.clipboard = "unnamed"

-- Write vim swap file sooner, also helps with git diff tracking
vim.o.updatetime = 100

-- Remove annoying delays
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 0

-- Set relative numbers
vim.o.number = true
vim.o.relativenumber = true

-- Remove search highlighting
vim.o.incsearch = false
vim.o.hlsearch = false

-- Eye candy
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    -- Pretty Floats
    vim.api.nvim_set_hl(0, "NormalFloat", { force = true, link = "Normal" })
    vim.api.nvim_set_hl(0, "FloatBorder", { force = true, link = "Constant" })
    -- Transparency
    vim.api.nvim_set_hl(0, "Normal", { ctermbg = NONE })
  end,
})
