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

autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd "checktime"
    end
  end,
  group = general,
  desc = "Update file when there are changes",
})

autocmd("VimEnter", {
  callback = function()
    -- Check and update theme based on macOS appearance
    local handle = io.popen "defaults read -g AppleInterfaceStyle 2>/dev/null"
    if handle then
      local result = handle:read "*a"
      handle:close()
      result = result:gsub("%s+", "")

      local appearance = result == "Dark" and "dark" or "light"
      local new_theme = appearance == "dark" and "github_dark" or "github_light"

      -- Only update if theme has changed
      local current_theme = vim.g.nvchad_theme
      if current_theme ~= new_theme then
        require("nvchad.utils").replace_word('theme = "' .. current_theme .. '"', 'theme = "' .. new_theme .. '"')
        vim.cmd("Nvchad theme " .. new_theme)
      end
    end
  end,
  group = general,
  desc = "Sync theme with macOS appearance on startup",
})

autocmd("VimResized", {
  callback = function()
    vim.cmd "wincmd ="
  end,
  group = general,
  desc = "Equalize Splits",
})

-- Disable line numbers for specific filetypes
local no_numbers = augroup("NoLineNumbers", { clear = true })

autocmd("FileType", {
  pattern = { "nvdash", "lazy", "mason" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  group = no_numbers,
  desc = "Disable line numbers for dashboard, lazy, and mason",
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
