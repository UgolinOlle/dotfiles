require "nvchad.autocmds"

vim.api.nvim_create_augroup("GitCommitRuler", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "GitCommitRuler",
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.colorcolumn = "50,72"
  end,
})

