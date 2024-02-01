local function configure()
  local auto_pairs = require("nvim-autopairs")
  local rule = require("nvim-autopairs.rule")

  auto_pairs.setup({
    ignored_next_char = "[%w%.]",
    fast_wrap = {
      map = "<C-w>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = [=[[%'%"%)%>%]%)%}%,]]=],
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
  })
  auto_pairs.add_rule(rule("<", ">"))
end

return {
  {
    "windwp/nvim-autopairs",
    config = configure,
  },
}
