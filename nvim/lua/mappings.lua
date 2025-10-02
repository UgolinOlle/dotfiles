require "nvchad.mappings"

local map = vim.keymap.set

-- Core
map("n", "<LEADER>w", "<CMD>confirm w<ENTER>", { desc = "Save without quit" })
map("n", "Q", "<CMD>confirm q<CR>", { desc = "Close window" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })
map(
  "n",
  "<leader><leader>",
  "<cmd>Telescope find_files<CR>",
  { desc = "Find Files (Telescope)" }
)
map("n", "sv", "<CMD>vsplit<ENTER>", { desc = "Split screen vertically" })
map("n", "ss", "<CMD>split<ENTER>", { desc = "Split screen horizontally" })

-- Git mappings
map(
  "n",
  "<leader>gp",
  "<cmd>Gitsigns preview_hunk<CR>",
  { desc = "Preview git hunk" }
)
map(
  "n",
  "<leader>gb",
  "<cmd>Gitsigns blame_line<CR>",
  { desc = "Git blame line" }
)

-- Terminal mappings
map("n", "<C-\\>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
map("t", "<C-\\>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

-- Theme switching
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Change theme" })
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

-- Formatting mappings
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format file or range" })

map("v", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format selection" })

-- LSP
map("n", "<leader>dy", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line "." - 1 })
  if #diagnostics > 0 then
    local diagnostic = diagnostics[1]
    local message = diagnostic.message
    vim.fn.setreg("+", message)
    vim.notify("Copied diagnostic: " .. message)
  else
    vim.notify "No diagnostic at current line"
  end
end, { desc = "Copy diagnostic to clipboard" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
end)

-- Zellij navigation
map(
  "n",
  "<C-h>",
  "<cmd>ZellijNavigateLeft<cr>",
  { silent = true, desc = "Navigate left" }
)
map(
  "n",
  "<C-j>",
  "<cmd>ZellijNavigateDown<cr>",
  { silent = true, desc = "Navigate down" }
)
map(
  "n",
  "<C-k>",
  "<cmd>ZellijNavigateUp<cr>",
  { silent = true, desc = "Navigate up" }
)
map(
  "n",
  "<C-l>",
  "<cmd>ZellijNavigateRight<cr>",
  { silent = true, desc = "Navigate right" }
)

-- Git graph
map("n", "<leader>gl", function()
  require("gitgraph").draw({}, { all = true, max_count = 5000 })
end, { desc = "GitGraph - Draw" })
