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
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local opts = {
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
        col_offset = -3,
        side_padding = 0,
        border = "rounded",
      },
      documentation = {
        winhighlight = "Normal:Normal,FloatBorder:Constant,Search:None",
        col_offset = -3,
        side_padding = 0,
        border = "rounded",
      },
    },
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
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
    sources = {
      { name = "nvim_lsp", keyword_length = 1 },
      { name = "luasnip", keyword_length = 2 },
      {
        name = "buffer",
        keyword_length = 1,
        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      { name = "path" },
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        require("cmp-under-comparator").under,
        cmp.config.compare.kind,
      },
    },
  }
  cmp.setup.cmdline({ "/", "?" }, {
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

  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

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
      "windwp/nvim-autopairs",
    },
    config = configure,
  },
}
