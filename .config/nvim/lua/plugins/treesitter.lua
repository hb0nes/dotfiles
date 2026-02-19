vim.api.nvim_create_autocmd({ "bufenter" }, {
  callback = function()
    -- create a better context with a line separator
    vim.api.nvim_set_hl(0, "treesittercontext", { force = true, link = "normal" })
    vim.api.nvim_set_hl(0, "treesittercontextbottom", { force = true, link = "underlined" })
    -- highlighting for types was italic, horrible
    vim.api.nvim_set_hl(0, "type", { force = true, link = "draculacyan" })
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
        ["ib"] = { query = "@block.inner", desc = "🌲select inside block" },
        ["ai"] = { query = "@yaml_item.outer", desc = "YAML: around list item" },
        ["ii"] = { query = "@yaml_item.inner", desc = "YAML: inside list item" },
        ["ab"] = { query = "@yaml_block.outer", desc = "YAML: around block" },
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
        ["gi="] = { query = "@yaml_item.outer", desc = "🌲go to next yaml item" },
      },
      goto_previous_start = {
        ["[["] = { query = "@function.outer", desc = "🌲go to previous function" },
        ["gc-"] = { query = "@class.outer", desc = "🌲go to previous class" },
        ["gl-"] = { query = "@loop.outer", desc = "🌲go to previous loop" },
        ["gb-"] = { query = "@block.outer", desc = "🌲go to previous block" },
        ["gi-"] = { query = "@yaml_item.outer", desc = "🌲go to previous yaml item" },
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
