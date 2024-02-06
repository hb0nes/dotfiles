function configure()
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      vim.api.nvim_set_hl(0, "StarterQuery", { fg = "#ffffff", bg = "#f50f0f", bold = true })
      vim.api.nvim_set_hl(0, "MiniStarterItemPrefix", { link = "StarterQuery", force = true })
    end,
  })
  local starter = require("mini.starter")
  local opts = {
    evaluate_single = true,
    items = {
      starter.sections.builtin_actions(),
      starter.sections.recent_files(10, false),
      starter.sections.recent_files(10, true),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.indexing("all", { "Builtin actions" }),
      starter.gen_hook.padding(3, 2),
    },
  }
  starter.setup(opts)
end

return {
  {
    "echasnovski/mini.starter",
    version = false,
    config = configure,
  },
}
