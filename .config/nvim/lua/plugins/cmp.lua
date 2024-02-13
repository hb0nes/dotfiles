--set pumheight for max completion items
vim.o.pumheight = 15

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
        vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
        if vim_item.menu == nil then
          vim_item.menu = ""
        end
        vim_item.menu = string.sub(vim_item.menu, 1, 20)
        return vim_item
      end,
    },
    mapping = {
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<A-c>"] = cmp.mapping.complete(),
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
      { name = "nvim_lsp", priority = 8 },
      { name = "buffer", priority = 7 },
      { name = "luasnip", priority = 6 },
      { name = "path", priority = 5 },
    }),
    sorting = {
      priority_weight = 1.0,
      comparators = {
        cmp.config.compare.locality,
        cmp.config.compare.recently_used,
        cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
        cmp.config.compare.offset,
        cmp.config.compare.order,
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
