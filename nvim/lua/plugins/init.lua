return {

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "InsertLeave" },
    cmd = { "ConformInfo" },
    opts = require "configs.conform",
  },

  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
  },

  -- Mason opts come from NvChad (nvchad.configs.mason); mason.nvim itself is declared there
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "html",
          "cssls",
          "tailwindcss",
          "emmet_ls",
          -- ts_ls removed: typescript-tools.nvim handles TypeScript
          "eslint",
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason.nvim", "mason-lspconfig.nvim", "b0o/schemastore.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Discord Rich Presence
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    build = ":Cord update",
    -- opts = {}
    config = function()
      require("cord").setup()
    end,
  },

  -- main branch ignores ensure_installed: parsers must be requested via install()
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "json5",
        "yaml",
        "markdown",
        "bash",
        "dockerfile",
        "terraform",
        "hcl",
        "toml",
        "ini",
        "git_config",
        "gitignore",
        "gitcommit",
        "ssh_config",
      }
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  { import = "plugins.telescope" },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = require("chadrc").gitsigns.signs,
      current_line_blame_opts = { delay = 300 },
      preview_config = { border = "rounded" },
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation (falls back to native ]c/[c inside diff mode)
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gs.nav_hunk "next"
          end
        end, "Git: next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gs.nav_hunk "prev"
          end
        end, "Git: prev hunk")

        -- Hunk actions
        map("n", "<leader>gs", gs.stage_hunk, "Git: stage/unstage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Git: reset hunk")
        map("v", "<leader>gs", function()
          gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Git: stage selection")
        map("v", "<leader>gr", function()
          gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Git: reset selection")
        map("n", "<leader>gS", gs.stage_buffer, "Git: stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Git: reset buffer")
        map("n", "<leader>gi", gs.preview_hunk_inline, "Git: preview hunk inline")
        map("n", "<leader>gB", gs.blame, "Git: blame file")
        map("n", "<leader>gQ", function()
          gs.setqflist "all"
        end, "Git: hunks to quickfix")

        -- Toggles
        map("n", "<leader>gT", gs.toggle_current_line_blame, "Git: toggle line blame")
        map("n", "<leader>gw", gs.toggle_word_diff, "Git: toggle word diff")

        -- Text object: ih = inner hunk
        map({ "o", "x" }, "ih", gs.select_hunk, "Git: select hunk")
      end,
    },
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
      -- Detect system theme (macOS only, fallback for other OS)
      local function get_system_theme()
        if vim.fn.has "mac" ~= 1 then
          return "dark"
        end
        local ok, handle = pcall(io.popen, "defaults read -g AppleInterfaceStyle 2>/dev/null")
        if not ok or not handle then
          return "dark"
        end
        local result = handle:read "*a"
        handle:close()
        return result:match "Dark" and "dark" or "light"
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
    branch = "main",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
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
    cmd = { "LspImportCurrent", "LspImportAll" },
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
      { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", silent = true, desc = "navigate left" },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>", silent = true, desc = "navigate down" },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>", silent = true, desc = "navigate up" },
      { "<c-l>", "<cmd>ZellijNavigateRight<cr>", silent = true, desc = "navigate right" },
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
            sources = cmp.config.sources(
              { { name = "async_path" } },
              { { name = "cmdline" } }
            ),
            matching = { disallow_symbol_nonprefix_matching = false },
          })
        end,
      },
    },

    opts = function()
      return require "nvchad.configs.cmp"
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          top_down = false,
        },
        init = function()
          local banned_messages = {
            "No information available",
          }
          vim.notify = function(msg, ...)
            for _, banned in ipairs(banned_messages) do
              if msg == banned then
                return
              end
            end
            return require "notify"(msg, ...)
          end
        end,
      },
    },
    config = function()
      require "configs.noice"
    end,
  },

  -- JSON/YAML schemas (Kubernetes, docker-compose, CI configs, etc.)
  { "b0o/schemastore.nvim", lazy = true },

  -- Git diff/review UI, handy for reviewing infra-as-code changes
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    opts = { enhanced_diff_hl = true },
  },

  -- Aggregated diagnostics list across buffers
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
  },

  -- REST client for testing cloud/HTTP APIs from .http files
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
    },
  },

  -- Kubernetes cluster browser (pods, deployments, logs, etc.)
  {
    "ramilito/kubectl.nvim",
    cmd = "Kubectl",
    dependencies = { "saghen/blink.download" },
    config = function()
      require("kubectl").setup()
    end,
  },

  -- File tree on the right (merged into NvChad's nvim-tree opts)
  {
    "nvim-tree/nvim-tree.lua",
    opts = { view = { side = "right" } },
  },
}
