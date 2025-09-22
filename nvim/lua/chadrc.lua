---@type ChadrcConfig
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
    ["gd"] = { "<cmd> Telescope <CR>", "definitions" },
    ["gr"] = { "<cmd> Telescope <CR>", "references" },
  },
}

vim.opt.guifont = "JetBrains Mono:h14"

return M
