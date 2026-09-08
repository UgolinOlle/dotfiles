local nvlsp = require "nvchad.configs.lspconfig"
nvlsp.defaults()

local map = vim.keymap.set

-- NvChad's LspAttach autocmd (registered inside nvlsp.defaults() above) runs
-- nvlsp.on_attach and sets gd/gr to vim.lsp.buf.definition/references.
-- Neovim always fires LspAttach autocmds BEFORE the client config's on_attach
-- field, so wrapping our override here (used as the on_attach field below)
-- guarantees it runs last and wins, for every server including
-- typescript-tools.nvim (which inherits this via the "*" config below).
local function on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  local opts = { buffer = bufnr }
  map("n", "gd", function()
    require("telescope.builtin").lsp_definitions { jump_type = "never" }
  end, vim.tbl_extend("force", opts, { desc = "LSP Go to definition" }))
  map("n", "gr", function()
    require("telescope.builtin").lsp_references { jump_type = "never" }
  end, vim.tbl_extend("force", opts, { desc = "LSP References" }))
end

-- Servers to setup with default config
local servers = {
  "html",
  "cssls",
  "tailwindcss",
  "emmet_ls",
  "eslint",
  "bashls",
  "biome",
  "dockerls",
  "docker_compose_language_service",
  "terraformls",
}

-- Setup each server with NvChad defaults
vim.lsp.config("*", {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})
vim.lsp.enable(servers)

-- JSON with SchemaStore (package.json, tsconfig, GH Actions, k8s json, etc.)
vim.lsp.config("jsonls", {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})
vim.lsp.enable "jsonls"

-- YAML with SchemaStore (Kubernetes, docker-compose, GH/GitLab CI, etc.)
vim.lsp.config("yamlls", {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
      validate = true,
    },
  },
})
vim.lsp.enable "yamlls"

-- Ansible (only attaches to yaml.ansible, detected in autocmds.lua by path)
vim.lsp.config("ansiblels", {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "yaml.ansible" },
})
vim.lsp.enable "ansiblels"

-- Lua LSP with specific settings
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})
vim.lsp.enable "lua_ls"

-- Configure diagnostics display
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
}

-- Configure autoimport keymaps
map(
  "n",
  "<leader>io",
  "<cmd>LspImportCurrent<CR>",
  { desc = "Import symbol under cursor" }
)
map(
  "n",
  "<leader>ia",
  "<cmd>LspImportAll<CR>",
  { desc = "Import all missing symbols" }
)

-- TypeScript specific keymaps (handled by typescript-tools.nvim)
map(
  "n",
  "<leader>to",
  "<cmd>TSToolsOrganizeImports<CR>",
  { desc = "Organize imports" }
)
map("n", "<leader>ts", "<cmd>TSToolsSortImports<CR>", { desc = "Sort imports" })
map(
  "n",
  "<leader>tr",
  "<cmd>TSToolsRemoveUnusedImports<CR>",
  { desc = "Remove unused imports" }
)
map("n", "<leader>tf", "<cmd>TSToolsFixAll<CR>", { desc = "Fix all issues" })
map(
  "n",
  "<leader>ti",
  "<cmd>TSToolsAddMissingImports<CR>",
  { desc = "Add missing imports" }
)

-- Core
vim.keymap.set({ "n" }, "K", function()
  vim.lsp.buf.hover { border = "rounded" }
end, { desc = "LSP show details", silent = true })
