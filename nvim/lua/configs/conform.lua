local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    javascript = { "biome" },
    javascriptreact = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },

    css = { "biome" },
    html = { "biome" },
    json = { "biome" },
    jsonc = { "biome" },
    -- css = { "biome" },
    -- html = { "prettier" },
    -- typescript = { "biome" },
    -- javascript = { "biome" },
    -- javascriptreact = { "biome" },
    -- typescriptreact = { "biome" },
    -- json = { "biome" },
    -- jsonc = { "biome" },
    -- yaml = { "prettier" },
    -- markdown = { "prettier" },
    -- sh = { "shfmt" },
    -- bash = { "shfmt" },
    -- zsh = { "shfmt" },
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
