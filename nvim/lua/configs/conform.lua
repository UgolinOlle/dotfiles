local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    javascript = { "oxfmt", "prettier", stop_after_first = true },
    typescript = { "oxfmt", "prettier", stop_after_first = true },

    javascriptreact = { "oxfmt", "prettier", stop_after_first = true },
    typescriptreact = { "oxfmt", "prettier", stop_after_first = true },

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

    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },

    toml = { "taplo" },
  },

  formatters = {
    oxfmt = {
      command = function(self, ctx)
        return require("conform.util").from_node_modules("oxfmt")(self, ctx)
      end,
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
      cwd = function(self, ctx)
        return require("conform.util").root_file({ "package.json", ".oxfmtrc.json" })(self, ctx)
      end,
      condition = function(_, ctx)
        local has_config = vim.fs.find(".oxfmtrc.json", { path = ctx.dirname, upward = true })[1] ~= nil
        local node_modules = vim.fs.find("node_modules", { path = ctx.dirname, upward = true })[1]
        local has_local_bin = node_modules and vim.fn.executable(node_modules .. "/.bin/oxfmt") == 1
        return has_config or has_local_bin or false
      end,
    },
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
