local opts = {
  timeout = 10000,
  render = "default",
  stages = "fade_in_slide_out",
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { focusable = false })
  end,
  background_colour = "#000000",
}
local function configure()
  local notify = require("notify")
  vim.keymap.set("n", "<Esc>", notify.dismiss, { desc = "dismiss notify popup and clear hlsearch" })
  notify.setup(opts)
end

return {
  {
    "rcarriga/nvim-notify",
    config = configure,
  },
}
