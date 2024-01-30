local ok, notify = pcall(require, "notify")
if not ok then
  return
end

local notify_hl = vim.api.nvim_create_augroup("NotifyHighlights", {})
vim.api.nvim_clear_autocmds({ group = notify_hl })
vim.api.nvim_create_autocmd("BufEnter", {
  group = notify_hl,
  desc = "redefinition of notify icon colours",
  callback = function()
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", {})
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { link = "Character" })
  end,
})

notify.setup({
  timeout = 10000,
  render = "minimal",
  stages = "fade_in_slide_out",
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { focusable = false })
  end,
  background_colour = "#000000",
})

vim.keymap.set("n", "<Esc>", function()
  require("notify").dismiss()
end, { desc = "dismiss notify popup and clear hlsearch" })
