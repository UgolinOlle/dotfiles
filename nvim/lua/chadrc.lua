---@class ChadrcConfig
local M = {}

-- Function to detect macOS appearance
local function get_macos_appearance()
  local handle = io.popen "defaults read -g AppleInterfaceStyle 2>/dev/null"

  if handle then
    local result = handle:read "*a"
    handle:close()
    result = result:gsub("%s+", "")

    return result == "Dark" and "dark" or "light"
  end

  return "light"
end

local appearance = get_macos_appearance()
local theme = appearance == "dark" and "github_dark" or "github_light"

M.base46 = {
  theme = theme,
  transparency = true,

  integrations = {
    "blankline",
    "cmp",
    "defaults",
    "devicons",
    "edgy",
    "grug_far",
    "git",
    "lsp",
    "markview",
    "mason",
    "nvcheatsheet",
    "nvimtree",
    "statusline",
    "syntax",
    "tbline",
    "telescope",
    "whichkey",
    "dap",
    "hop",
    "treesitter",
    "rainbowdelimiters",
    "diffview",
    "todo",
    "trouble",
    "notify",
  },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom_colored",
  },

  telescope = { style = "bordered" },

  statusline = {
    theme = "minimal",
    separator_style = "round",
    order = nil,
    modules = nil,
  },

  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
  },

  lsp = {
    signature = true,
  },
}

M.disabled = {
  n = {
    ["gd"] = "",
    ["gr"] = "",
  },
}

M.lspoveride = {
  n = {
    ["gd"] = { "<cmd>Telescope <CR>", "definitions" },
    ["gr"] = { "<cmd>Telescope <CR>", "references" },
  },
}

M.nvdash = {
  load_on_startup = true,
  buttons = require "configs.nvdash",
}

M.mason = {
  -- Lua
  "lua-language-server",
  "stylua",

  -- Web
  "css-lsp",
  "html-lsp",
  "typescript-language-server",
  "prettier",
  "eslint-lsp",
  "eslint_d",
  "emmet-ls",
  "rustywind",

  -- Spell
  "marksman",

  -- Json
  "jsonlint",
  "json-lsp",

  -- Docker
  "dockerfile-language-server",
  "hadolint",
  "docker-compose-language-service",
}

M.terminal = {
  winopts = {
    winfixbuf = true,
    number = false,
    relativenumber = false,
  },
  sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
  float = {
    relative = "editor",
    row = 0.3,
    col = 0.25,
    width = 0.5,
    height = 0.4,
    border = "single",
  },
}

M.colorify = {
  enabled = true,
  mode = "virtual",
  virt_text = "󱓻 ",

  highlight = {
    hex = true,
    lspvars = true,
  },
}

M.gitsigns = {
  signs = {
    add = { text = " " },
    change = { text = " " },
    delete = { text = " " },
    topdelete = { text = " " },
    changedelete = { text = " " },
    untracked = { text = " " },
  },
}

vim.opt.guifont = "JetBrains Mono:h14"

return M
