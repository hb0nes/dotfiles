-- Change highlight
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "TreesitterContext", { force = true, link = "Normal" })
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { force = true, link = "Underlined" })
  end,
})

local opts = {
  highlight = { enable = true },
  ensure_installed = {
    "bash",
    "go",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "requirements",
    "rust",
    "puppet",
    "embedded_template",
    "toml",
    "yaml",
    "vim",
    "vimdoc",
  },
  matchup = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "🌲select around function" },
        ["if"] = { query = "@function.inner", desc = "🌲select inside function" },
        ["ac"] = { query = "@class.outer", desc = "🌲select around class" },
        ["ic"] = { query = "@class.inner", desc = "🌲select inside class" },
        ["al"] = { query = "@loop.outer", desc = "🌲select around loop" },
        ["il"] = { query = "@loop.inner", desc = "🌲select inside loop" },
        ["ab"] = { query = "@block.outer", desc = "🌲select around block" },
        ["ib"] = { query = "@block.inner", desc = "🌲select inside block" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]]"] = { query = "@function.outer", desc = "🌲go to next function" },
        ["gc="] = { query = "@class.outer", desc = "🌲go to next class" },
        ["gl="] = { query = "@loop.outer", desc = "🌲go to next loop" },
        ["gb="] = { query = "@block.outer", desc = "🌲go to next block" },
      },
      goto_previous_start = {
        ["[["] = { query = "@function.outer", desc = "🌲go to previous function" },
        ["gc-"] = { query = "@class.outer", desc = "🌲go to previous class" },
        ["gl-"] = { query = "@loop.outer", desc = "🌲go to previous loop" },
        ["gb-"] = { query = "@block.outer", desc = "🌲go to previous block" },
      },
    },
    lsp_interop = {
      enable = true,
      border = "rounded",
      peek_definition_code = {
        ["<leader>p"] = { query = "@function.outer", desc = "🌲peek function definition" },
        ["gcp"] = { query = "@class.outer", desc = "🌲peek class definition" },
      },
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufEnter",
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
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
