local nvlsp = require "nvchad.configs.lspconfig"
nvlsp.defaults()

local lspconfig = require "lspconfig"
local map = vim.keymap.set

-- Servers to setup with default config
local servers = {
  "html",
  "cssls",
  "tailwindcss",
  "emmet_ls",
  "eslint",
  "bashls",
  "biome",
}

-- Setup each server with NvChad defaults
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Lua LSP with specific settings
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
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
}

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
