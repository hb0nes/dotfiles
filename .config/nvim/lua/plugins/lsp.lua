local function configure()
  -- Setup lspconfig.
  local lsp = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- UI
  vim.diagnostic.config({
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
      source = "always",
      prefix = "●",
      virt_text_pos = "eol",
    },
    underline = true,
    signs = true,
    severity_sort = true,
    float = {
      source = "always",
      header = "",
      prefix = "",
      focusable = false,
      border = "rounded",
    },
  })

  vim.lsp.set_log_level("off")

  -- Override default float looks for diagnostics
  -- Make the border look like the severity
  vim.diagnostic.open_float = (function(orig)
    return function(opts)
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
      local max_severity = vim.diagnostic.severity.HINT
      for _, d in ipairs(diagnostics) do
        if d.severity < max_severity then
          max_severity = d.severity
        end
      end
      local border_color = ({
        [vim.diagnostic.severity.HINT] = "NonText",
        [vim.diagnostic.severity.INFO] = "DraculaCyan",
        [vim.diagnostic.severity.WARN] = "DraculaOrangeBold",
        [vim.diagnostic.severity.ERROR] = "DraculaError",
      })[max_severity]
      local opts = {
        border = {
          { "╭", border_color },
          { "─", border_color },
          { "╮", border_color },
          { "│", border_color },
          { "╯", border_color },
          { "─", border_color },
          { "╰", border_color },
          { "│", border_color },
        },
      }
      orig(opts)
    end
  end)(vim.diagnostic.open_float)

  local on_attach = function(client, bufnr)
    vim.g.diagnostics_visible = true

    --- toggle inlay hints
    local function toggle_inlay_hints()
      if vim.g.inlay_hints_visible then
        vim.g.inlay_hints_visible = false
        vim.lsp.inlay_hint.enable(bufnr, false)
      else
        if client.server_capabilities.inlayHintProvider then
          vim.g.inlay_hints_visible = true
          vim.lsp.inlay_hint.enable(bufnr, true)
        else
          print("no inlay hints available")
        end
      end
    end

    local keymap_opts_buf = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(
      "n",
      "<leader>=",
      vim.diagnostic.goto_next,
      vim.tbl_extend("force", keymap_opts_buf, { desc = "✨lsp go to next diagnostic" })
    )
    vim.keymap.set(
      "n",
      "<leader>-",
      vim.diagnostic.goto_prev,
      vim.tbl_extend("force", keymap_opts_buf, { desc = "✨lsp go to prev diagnostic" })
    )

    vim.keymap.set(
      "n",
      "K",
      vim.lsp.buf.hover,
      vim.tbl_extend("force", keymap_opts_buf, { desc = "✨lsp hover for docs" })
    )
    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      vim.tbl_extend("force", keymap_opts_buf, { desc = "✨lsp go to definition" })
    )
    vim.keymap.set(
      "n",
      "<leader>h",
      toggle_inlay_hints,
      vim.tbl_extend("force", keymap_opts_buf, { desc = "✨lsp toggle inlay hints" })
    )
    vim.keymap.set(
      "n",
      "<leader>d",
      vim.diagnostic.open_float,
      vim.tbl_extend("force", keymap_opts_buf, { desc = "✨lsp toggle diagnostics" })
    )
  end

  local default_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    lsp_flags = {
      debounce_text_changes = 500,
    },
  }

  local server_opts = {
    bashls = {},
    puppet = {},
    dockerls = {},
    yamlls = {},
    lua_ls = {},
    jsonls = {},
    vimls = {},
    gopls = {
      settings = {
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  }

  for server, opts in pairs(server_opts) do
    local merged_opts = vim.tbl_deep_extend("force", opts, default_opts)
    lsp[server].setup(merged_opts)
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    config = configure,
  },
}
