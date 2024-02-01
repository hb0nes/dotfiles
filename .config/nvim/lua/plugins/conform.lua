local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
  return
end

conform.setup({
  formatters_by_ft = {
    json = { "jq" },
    go = { "gofmt", "goimports" },
    latex = { "latexindent" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    sql = { "sqlfluff" },
    toml = { "taplo" },
    yaml = { "prettier" },
  },
  formatters = {
    stylua = {
      prepend_args = { "--indent-width=2", "--indent-type=Spaces" },
    },
    rustfmt = {
      prepend_args = { "--config", "tab_spaces=2" },
    },
  },
  format_on_save = function()
    local next = next
    if next(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })) ~= nil then
      local notify_ok, notify = pcall(require, "notify")
      if not notify_ok then
        return
      end
      notify("LSP errors, cannot format")
      return
    end
    return { timeout_ms = 1000, lsp_fallback = true }
  end,
})
vim.keymap.set("n", "<leader>f", function()
  require("conform").format()
end)
