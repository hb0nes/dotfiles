local ok, outline = pcall(require, "outline")
if not ok then
	return
end

local icons = require("utils").icons

outline.setup({
	outline_window = {
		auto_jump = true,
    width = 15,
	},
	outline_items = {
		show_symbol_details = false,
	},
	symbol_folding = {
		autofold_depth = 1,
	},
    -- These keymaps can be a string or a table for multiple keys.
  -- Set to `{}` to disable. (Using 'nil' will fallback to default keys)
  keymaps = {
    show_help = '?',
    close = {'<Esc>', 'q'},
    -- Jump to symbol under cursor.
    -- It can auto close the outline window when triggered, see
    -- 'auto_close' option above.
    goto_location = '<Cr>',
    -- Jump to symbol under cursor but keep focus on outline window.
    peek_location = 'o',
    -- Visit location in code and close outline immediately
    goto_and_close = '<S-Cr>',
    -- Change cursor position of outline window to match current location in code.
    -- 'Opposite' of goto/peek_location.
    restore_location = '<C-g>',
    -- Open LSP/provider-dependent symbol hover information
    hover_symbol = '<C-space>',
    -- Preview location code of the symbol under cursor
    toggle_preview = 'K',
    rename_symbol = 'r',
    code_actions = 'a',
    -- These fold actions are collapsing tree nodes, not code folding
    fold = 'h',
    unfold = 'l',
    fold_toggle = '<Tab>',
    -- Toggle folds for all nodes.
    -- If at least one node is folded, this action will fold all nodes.
    -- If all nodes are folded, this action will unfold all nodes.
    fold_toggle_all = '<S-Tab>',
    fold_all = 'W',
    unfold_all = 'E',
    fold_reset = 'R',
    -- Move down/up by one line and peek_location immediately.
    -- You can also use outline_window.auto_jump=true to do this for any
    -- j/k/<down>/<up>.
    down_and_jump = '<C-j>',
    up_and_jump = '<C-k>',
  },

	preview_window = {
		border = "rounded",
	},
	guides = {
		enabled = true,
		markers = {
			bottom = "└",
			middle = "├",
			vertical = "",
			horizontal = "─",
		},
	},
	symbols = {
		icons = {
			Array = { icon = icons.kinds.Array, hl = "@constant" },
			Boolean = { icon = icons.kinds.Boolean, hl = "@boolean" },
			Class = { icon = "𝓒", hl = "@type" },
			Constant = { icon = icons.kinds.Constant, hl = "@constant" },
			Constructor = { icons.kinds.Constructor, hl = "@constructor" },
			Enum = { icon = icons.kinds.Enum, hl = "@type" },
			EnumMember = { icon = icons.kinds.EnumMember, hl = "@field" },
			Event = { icon = icons.kinds.Event, hl = "@type" },
			Field = { icon = icons.kinds.Field, hl = "@field" },
			File = { icon = icons.kinds.File, hl = "@text.uri" },
			Function = { icon = icons.kinds.Function, hl = "@function" },
			Interface = { icon = icons.kinds.Interface, hl = "@type" },
			Key = { icon = icons.kinds.Key, hl = "@type" },
			Method = { icon = icons.kinds.Function, hl = "@method" },
			Module = { icon = icons.kinds.Module, hl = "@namespace" },
			Namespace = { icon = icons.kinds.Namespace, hl = "@namespace" },
			Number = { icon = icons.kinds.Number, hl = "@number" },
			Null = { icon = "NULL", hl = "@type" },
			Object = { icon = icons.kinds.Object, hl = "@type" },
			Operator = { icon = icons.kinds.Operator, hl = "@operator" },
			Property = { icon = icons.kinds.Property, hl = "@method" },
			String = { icon = icons.kinds.String, hl = "@string" },
			Struct = { icon = icons.kinds.Struct, hl = "@type" },
			TypeParameter = { icon = icons.kinds.TypeParameter, hl = "@parameter" },
			Variable = { icon = icons.kinds.Variable, hl = "@constant" },
		},
	},
})

