require("nvchad.configs.lspconfig").defaults()

local map = vim.keymap.set
local signature_help = vim.lsp.buf.signature_help

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
  "prettier",
}

vim.lsp.enable(servers)

-- vim.lsp.buf.signature_help = function(config)
--   config = config or {}
--   config.border = "rounded"
--   config.title = ""
--   return signature_help(config)
-- end

-- Sets border for diagnostics and opens them on jump in a floating window
-- vim.diagnostic.config {
--   jump = {
--     float = true,
--   },
--   float = {
--     border = "rounded",
--   },
-- }

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
