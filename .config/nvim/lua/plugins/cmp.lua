--set pumheight for max completion items
vim.o.pumheight = 25

local cmp_kinds = {
  Text = "  ",
  Method = "  ",
  Function = "  ",
  Constructor = "  ",
  Field = "  ",
  Variable = "  ",
  Class = "  ",
  Interface = "  ",
  Module = "  ",
  Property = "  ",
  Unit = "  ",
  Value = "  ",
  Enum = "  ",
  Keyword = "  ",
  Snippet = "  ",
  Color = "  ",
  File = "  ",
  Reference = "  ",
  Folder = "  ",
  EnumMember = "  ",
  Constant = "  ",
  Struct = "  ",
  Event = "  ",
  Operator = "  ",
  TypeParameter = "  ",
}

-- Setup VScode-esque colors
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  desc = "redefinition of nvim-cmp highlight groups",
  callback = function()
    -- gray
    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
    -- blue
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
    -- light blue
    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
    vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
    -- pink
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
    -- front
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
  end,
})

local function configure()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local compare = require("cmp.config.compare")

  ---@type table<integer, integer>
  local modified_priority = {
    [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
    [types.lsp.CompletionItemKind.Field] = 1, -- top
    [types.lsp.CompletionItemKind.Snippet] = 2, -- top
    [types.lsp.CompletionItemKind.Keyword] = 3, -- top
    [types.lsp.CompletionItemKind.Text] = 100, -- bottom
  }
  ---@param kind integer: kind of completion entry
  local function modified_kind(kind)
    return modified_priority[kind] or kind
  end

  local opts = {
    preselect = cmp.PreselectMode.None,
    performance = {
      debounce = 200,
    },
    view = {
      entries = { name = "custom", selection_order = "near_cursor" },
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = {
        winhighlight = "Normal:Normal,FloatBorder:Constant,Search:None",
        col_offset = 0,
        side_padding = 0,
        border = "rounded",
      },
      documentation = {
        winhighlight = "Normal:Normal,FloatBorder:Constant,Search:None",
        col_offset = 0,
        side_padding = 0,
        border = "rounded",
      },
    },
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = (cmp_kinds[vim_item.kind] or "") -- .. vim_item.kind
        vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
        if vim_item.menu == nil then
          vim_item.menu = ""
        end
        vim_item.menu = string.sub(vim_item.menu, 1, 40)
        return vim_item
      end,
    },
    mapping = {
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<A-c>"] = cmp.mapping.complete(),
      ["<C-space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }),
      ["<C-e>"] = cmp.mapping.abort(),

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 9 },
      { name = "copilot", priority = 8 },
      { name = "path", priority = 7 },
      { name = "luasnip", priority = 6 },
      { name = "buffer", priority = 5 },
    }),
    sorting = {
      -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
      comparators = {
        compare.exact,
        compare.offset,
        -- function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
        --   local kind1 = modified_kind(entry1:get_kind())
        --   local kind2 = modified_kind(entry2:get_kind())
        --   if kind1 ~= kind2 then
        --     return kind1 - kind2 < 0
        --   end
        -- end,
        compare.recently_used,
        compare.score,
        compare.order,
      },
    },
  }

  cmp.setup.cmdline({ "/", "?" }, {
    view = {
      entries = { name = "wildmenu", separator = "|" },
    },
    mapping = cmp.mapping.preset.cmdline(),
    window = { completion = { col_offset = 0 } },
    formatting = { fields = { "abbr" } },
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    window = { completion = { col_offset = 0 } },
    formatting = { fields = { "abbr" } },
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
  cmp.setup(opts)
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
    },
    config = configure,
  },
}
