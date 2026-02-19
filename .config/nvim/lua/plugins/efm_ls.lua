return {
  {
    "creativenull/efmls-configs-nvim",
    tag = "v1.11.0",
    config = function()
      local yamllint = require("efmls-configs.linters.yamllint")
      yamllint.lintCommand = "uvx yamllint -f parsable ${INPUT}"

      local languages = require("efmls-configs.defaults").languages()
      languages = vim.tbl_extend("force", languages, {
        yaml = { yamllint },
      })

      local efmls_config = {
        filetypes = vim.tbl_keys(languages),
        settings = {
          rootMarkers = { ".git/" },
          languages = languages,
        },
      }

      vim.lsp.config(
        "efm",
        vim.tbl_extend("force", efmls_config, {
          cmd = { "efm-langserver" },
        })
      )
      vim.lsp.enable("efm")
    end,
  },
}
