local function configure()
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  local f = ls.function_node
  local fmt = require("luasnip.extras.fmt").fmt
  local types = require("luasnip.util.types")

  -- options
  ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    store_selection_keys = "<c-s>",
    ext_opts = {
      -- [types.insertNode] = {
      --   visited = { hl_group = "Comment" },
      --   unvisited = { hl_group = "Comment" },
      -- },
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", "InsertMode" } },
        },
      },
    },
  })

  -- commands
  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true, desc = "🚀snip jump to next placeholder" })

  vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if ls.expand_or_jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true, desc = "🚀snip jump to prev placeholder" })

  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { desc = "🚀snip next choice" })

  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.choice_active() then
      ls.change_choice(-1)
    end
  end, { desc = "🚀snip prev choice" })

  -- add snips to engine
  local list_snips = function()
    local ft_list = require("luasnip").available()[vim.o.filetype]
    local ft_snips = {}
    for _, item in pairs(ft_list) do
      ft_snips[item.trigger] = item.name
    end
    P(ft_snips)
  end

  vim.api.nvim_create_user_command("SnipList", list_snips, {})
end

return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = configure,
  },
}
