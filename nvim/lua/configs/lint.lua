local lint = require "lint"

-- Configure linters by filetype
lint.linters_by_ft = {
  javascript = { "oxlint" },
  typescript = { "oxlint" },
  javascriptreact = { "oxlint" },
  typescriptreact = { "oxlint" },
}

-- Create autocmd for linting
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Manual lint keymap
vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })
