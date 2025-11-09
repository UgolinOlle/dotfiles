local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    javascript = { "prettier" },
    typescript = { "prettier" },

    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },

    json = { "prettier" },
    jsonc = { "prettier" },

    css = { "prettier" },
    html = { "prettier" },

    markdown = { "prettier" },
    sql = { "sqlfmt" },

    ["yaml"] = { "prettier" },
    ["markdown.mdx"] = { "prettier" },

    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },

  format_after_save = {
    lsp_fallback = true,
  },
}

return options
