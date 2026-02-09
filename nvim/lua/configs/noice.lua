require("noice").setup {
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    format = {
      cmdline = { pattern = "^:", icon = "󰘳 ", lang = "vim" },
      search_down = {
        kind = "search",
        pattern = "^/",
        icon = "󰩊 ",
        lang = "regex",
      },
      search_up = {
        kind = "search",
        pattern = "^%?",
        icon = "󰩊 ",
        lang = "regex",
      },
      filter = { pattern = "^:%s*!", icon = "󰻿 ", lang = "bash" },
      lua = {
        pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
        icon = "",
        lang = "lua",
      },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "󰞋 " },
    },
  },
  popupmenu = {
    enabled = true, -- enables the Noice popupmenu UI
    backend = "nui", -- backend to use to show regular cmdline completions
  },
  routes = {
    -- Skip LSP progress messages
    {
      filter = {
        event = "lsp",
        any = {
          { find = "formatting" },
          { find = "[Dd]iagnostic" },
          { find = "code_action" },
          { find = "semantic tokens" },
          { find = "symbols" },
          { find = "completion" },
        },
      },
      opts = { skip = true },
    },
    -- Skip common "no results" messages
    {
      filter = {
        any = {
          { find = "No information available" },
          { find = "No references found" },
          { find = "No lines in buffer" },
          { find = "No code actions available" },
          { find = "Nothing currently selected" },
          { find = "no manual entry for" },
          { find = "not have parser for" },
          { find = "_ts_parse_query" },
        },
      },
      opts = { skip = true },
    },
    -- Skip verbose edit/save/undo messages
    {
      filter = {
        event = "msg_show",
        kind = "",
        any = {
          { find = "%d+.* lines?" },      -- lines added/removed/yanked/moved/indented
          { find = "%d+ changes?;?" },    -- undo/redo changes
          { find = "%d+L, %d+B" },        -- file stats
          { find = "bytes written" },     -- save
          { find = "^Hunk %d+ of %d+$" }, -- git hunks
          { find = "^[/?]" },             -- search patterns
          { find = "E486:" },             -- pattern not found
          { find = "Already at .* change" },
          { find = "E21:" },              -- modifiable off
        },
      },
      opts = { skip = true },
    },
  },
  lsp = {
    progress = {
      enabled = false,
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true,
        luasnip = true,
        throttle = 50,
      },
      view = nil, -- when nil, use defaults from documentation
      opts = {
        focusable = false,
        size = {
          max_height = 15,
          max_width = 60,
        },
        win_options = {
          wrap = false,
        },
      },
    },
    hover = {
      silent = true,
      opts = {
        size = {
          max_width = vim.api.nvim_win_get_width(0) - 6,
        },
      },
    },
    documentation = {
      opts = {
        border = {
          padding = { 0, 0 },
        },
      },
    },
    override = {
      -- override the default lsp markdown formatter with Noice
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      -- override the lsp markdown formatter with Noice
      ["vim.lsp.util.stylize_markdown"] = true,
      -- override cmp documentation with Noice (needs the other options to work)
      ["cmp.entry.get_documentation"] = true,
    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = 3,
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
    mini = {
      zindex = 100,
      win_options = { winblend = 0 },
    },
  },

  presets = {
    bottom_search = true,
    command_palette = true,
    lsp_doc_border = true,
    inc_rename = true,
  },
}
