vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.signcolumn = "number"

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

-- Surrounding with quotes or brackets
local plugins = {
	{
		"tpope/vim-surround",
		dependencies = {
			"tpope/vim-commentary",
			"tpope/vim-repeat",
		},
		config = function()
			vim.keymap.set("n", "<leader>'", "ysiW'", { remap = true })
			vim.keymap.set("n", '<leader>"', 'ysiW"', { remap = true })
			vim.keymap.set("n", "<leader>[", "ysiw}", { remap = true })
			vim.keymap.set("n", "<leader>]", "ysiW}", { remap = true })
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
		end,
	},
	{
		"creativenull/efmls-configs-nvim",
		tag = "v1.5.0",
		desc = "Linting for bash: brew install efm-langserver, brew install shellcheck",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"dracula/vim",
		name = "dracula",
		config = function()
			vim.cmd("colorscheme dracula")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.lsp")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"lukas-reineke/cmp-under-comparator",
			"saadparwaiz1/cmp_luasnip",
			{
				"windwp/nvim-autopairs",
				config = function()
					require("plugins.autopairs")
				end,
			},
		},
		config = function()
			require("plugins.cmp")
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			require("plugins.conform")
		end,
	},
	{
		"folke/noice.nvim",
		dependencies = {
			{ "MunifTanjim/nui.nvim" },
			{
				"rcarriga/nvim-notify",
				config = function()
					require("plugins.notify")
				end,
			},
		},
		config = function()
			require("plugins.noice")
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		config = function()
			require("plugins.snip")
		end,
	},
	{
		"hedyhli/outline.nvim",
		cmd = "Outline",
		keys = {
			{
				"<C-o>",
				function()
					require("nvim-tree.api").tree.close()
					vim.cmd.Outline()
				end,
				desc = "open outline view",
			},
		},
		config = function()
			-- Close Outline when leaving buffer
			vim.api.nvim_create_autocmd({ "QuitPre" }, {
				pattern = { "*" },
				command = "OutlineClose",
			})
			-- Load outline settings
			require("plugins.outline")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		keys = {
			{
				"<C-n>",
				function()
					require("outline").close()
					require("nvim-tree.api").tree.toggle()
				end,
				desc = "toggle nvim-tree",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		config = function()
			require("plugins.nvim_tree")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{
				"nvim-treesitter/nvim-treesitter-context",
				event = "BufReadPre",
				keys = {
					{
						"[c",
						function()
							require("treesitter-context").go_to_context()
						end,
					},
				},
				opts = { max_lines = 3 },
			},
		},
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "BufReadPre",
		init = function()
			vim.keymap.set("n", "g<Tab>", function()
				require("dropbar.api").pick()
			end)
		end,
		config = function()
			require("plugins.dropbar")
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>t",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
		config = function()
			require("plugins.flash")
		end,
	},
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup()
		end,
	},
  {
  "luckasRanarison/clear-action.nvim",
	  opts = require('plugins.clear_action')
  },
  'github/copilot.vim',
}
require("lazy").setup(plugins, nil)

-- Disable mouse
vim.o.mouse = ""

-- Switch windows in Neovim with alt shift + j/k/l/h
vim.keymap.set("n", "<C-A-j>", "<C-w>j")
vim.keymap.set("n", "<C-A-l>", "<C-w>l")
vim.keymap.set("n", "<C-A-k>", "<C-w>k")
vim.keymap.set("n", "<C-A-h>", "<C-w>h")

-- Eye candy
vim.opt.termguicolors = true

-- Transparency support
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Save with sudo when typing :w!!
vim.api.nvim_set_keymap("c", "w!!", "w !sudo tee > /dev/null %", { noremap = true, silent = true })
-- Save with ctrl or alt s
vim.keymap.set('n', '<A-s>', ':w<Cr>')

-- Copy to clipboard on yank
vim.o.clipboard = "unnamed"

-- Write vim swap file sooner, also helps with git diff tracking
vim.o.updatetime = 100

-- Remove annoying delays
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 0

-- Set relative numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.incsearch = false
vim.o.hlsearch = false

-- Remove trailing whitespaces on save
vim.cmd([[autocmd BufWritePre * %s/\s\+$//e]])

local config_path = vim.fn.stdpath("config")
for _, file in ipairs(vim.fn.readdir(config_path .. "/lua", [[v:val =~ '\.lua$']])) do
	require(file:gsub("%.lua$", ""))
end
