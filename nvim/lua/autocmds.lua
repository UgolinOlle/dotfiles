require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings
local general = augroup("General", { clear = true })

autocmd("VimEnter", {
  callback = function(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    -- change to the directory
    if directory then
      vim.cmd.cd(data.file)
      vim.cmd "Telescope find_files"
      -- require("nvim-tree.api").tree.open()
    end
  end,
  group = general,
  desc = "Open Telescope when it's a Directory",
})

autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.number = true
  end,
  group = general,
  desc = "Enable Line Number in Telescope Preview",
})

autocmd({ "FocusLost", "BufLeave", "BufWinLeave", "InsertLeave" }, {
  nested = true, -- for format on save
  callback = function()
    if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
      vim.cmd "silent! w"
    end
  end,
  group = general,
  desc = "Auto Save",
})

autocmd("FocusGained", {
  callback = function()
    vim.cmd "checktime"
  end,
  group = general,
  desc = "Update file when there are changes",
})

autocmd("VimResized", {
  callback = function()
    vim.cmd "wincmd ="
  end,
  group = general,
  desc = "Equalize Splits",
})

-- Git settings
local git = augroup("GitCommitRuler", { clear = true })

autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.colorcolumn = "50,72"
  end,
  group = git,
  desc = "",
})
