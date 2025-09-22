return {

  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  -- Mason for automatic LSP server installation
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "html",
          "cssls",
          "tailwindcss",
          "emmet_ls",
          "ts_ls",
          "eslint",
        },
        automatic_installation = true,
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Discord Rich Presence
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    -- opts = {}
    config = function()
      require("cord").setup()
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "markdown",
        "bash",
      },
    },
  },

  { import = "plugins.telescope" },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap(
        "i",
        "<C-J>",
        'copilot#Accept("<CR>")',
        { expr = true, silent = true }
      )
      vim.g.copilot_filetypes = {
        ["*"] = false,
        ["javascript"] = true,
        ["typescript"] = true,
        ["lua"] = true,
        ["rust"] = true,
        ["c"] = true,
        ["c#"] = true,
        ["c++"] = true,
        ["go"] = true,
        ["python"] = true,
      }
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Better commenting
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- File explorer improvements
  {
    "nvim-tree/nvim-web-devicons",
  },

  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    config = function()
      -- Detect system theme on macOS
      local function get_system_theme()
        local handle =
          io.popen "defaults read -g AppleInterfaceStyle 2>/dev/null"
        if handle then
          local result = handle:read "*a"
          handle:close()
          return result:match "Dark" and "dark" or "light"
        end
        return "dark" -- fallback
      end

      local theme = get_system_theme()
      local shade_factor = theme == "dark" and 2 or 1
      local shade_terminals = theme == "dark"

      require("toggleterm").setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = shade_terminals,
        shading_factor = shade_factor,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      }
    end,
  },

  -- Better syntax highlighting for multiple languages
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- TypeScript/JavaScript autoimport support
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("typescript-tools").setup {
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },
          tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
          },
        },
      }
    end,
  },

  -- Auto import functionality for multiple languages
  {
    "stevanmilic/nvim-lspimport",
    config = function()
      require("lspimport").setup()
    end,
  },

  -- ESLint support
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  -- Zellij integration
  {
    "https://git.sr.ht/~swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      {
        "<c-h>",
        "<cmd>ZellijNavigateLeft<cr>",
        { silent = true, desc = "navigate left" },
      },
      {
        "<c-j>",
        "<cmd>ZellijNavigateDown<cr>",
        { silent = true, desc = "navigate down" },
      },
      {
        "<c-k>",
        "<cmd>ZellijNavigateUp<cr>",
        { silent = true, desc = "navigate up" },
      },
      {
        "<c-l>",
        "<cmd>ZellijNavigateRight<cr>",
        { silent = true, desc = "navigate right" },
      },
    },
    opts = {},
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done()
          )
        end,
      },

{
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        config = function()
          local cmp = require "cmp"

          cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
          })

          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            matching = { disallow_symbol_nonprefix_matching = false },
          })
        end,
      },
    },

    {
      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "https://codeberg.org/FelipeLema/cmp-async-path.git",
      },
    },
    opts = function()
      return require "nvchad.configs.cmp"
    end,
  },
}
