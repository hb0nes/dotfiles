-- Require config
require("opts")
require("keymaps")

local jump_to_paragraph_start = function()
  local column = vim.fn.virtcol(".")
  if vim.fn.line(".") == (vim.fn.line("'{") + 1) then
    vim.fn.cursor(vim.fn.line(".") - 1, column)
  end
  local paragraph_start = vim.fn.line("'{")
  if paragraph_start == 1 then
    vim.fn.cursor(1, column)
  else
    vim.fn.cursor((paragraph_start + 1), column)
  end
end

local jump_to_paragraph_end = function()
  local column = vim.fn.virtcol(".")
  if vim.fn.line(".") == (vim.fn.line("'}") - 1) then
    vim.fn.cursor(vim.fn.line(".") + 1, column)
  end
  local paragraph_end = vim.fn.line("'}")
  if paragraph_end == vim.fn.line("$") then
    vim.fn.cursor(vim.fn.line("$"), column)
  else
    vim.fn.cursor((paragraph_end - 1), column)
  end
end

vim.keymap.set({ "v", "n" }, "(", jump_to_paragraph_start, { silent = true, desc = "move to last line of paragraph" })
vim.keymap.set({ "v", "n" }, ")", jump_to_paragraph_end, { silent = true, desc = "move to last line of paragraph" })

-- Setup plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Remove trailing whitespaces on save
vim.cmd([[autocmd BufWritePre * %s/\s\+$//e]])
