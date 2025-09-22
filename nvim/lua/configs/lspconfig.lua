require("nvchad.configs.lspconfig").defaults()

local map = vim.keymap.set

-- Define servers with their configurations
local servers = {
  "html",
  "cssls",
  "tailwindcss",
  "lua_ls",
  "emmet_ls",
  "ts_ls",
  "eslint",
  "bashls",
  "biome",
}

vim.lsp.enable(servers)

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
