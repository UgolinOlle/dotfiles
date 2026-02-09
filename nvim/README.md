# Neovim Configuration

A modern, feature-rich Neovim configuration built on [NvChad v2.5](https://nvchad.com/) with automatic system theme detection, TypeScript/JavaScript-first development experience, and Zellij integration.

## Features

- **Automatic Theme Switching** - Detects macOS system appearance and switches between `github_dark` and `github_light` themes
- **TypeScript/JavaScript First** - Enhanced TS/JS experience with `typescript-tools.nvim` for auto-imports, code fixes, and intelligent completions
- **LSP & Formatting** - Pre-configured language servers with Mason auto-installation and format-on-save via Conform
- **Zellij Integration** - Seamless pane navigation between Neovim and Zellij
- **Modern UI** - Noice.nvim for enhanced command line, notifications, and LSP hover/signature
- **Discord Presence** - Show what you're editing via Cord.nvim

## Requirements

- **Neovim** >= 0.10.0
- **Git**
- **Nerd Font** (recommended: JetBrains Mono)
- **Node.js** (for LSP servers)
- **ripgrep** (for Telescope live grep)

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone the repository
git clone https://github.com/mehmetozguldev/nvim.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point, lazy.nvim bootstrap
├── lua/
│   ├── chadrc.lua           # NvChad configuration (theme, UI, statusline)
│   ├── options.lua          # Vim options
│   ├── mappings.lua         # Key mappings
│   ├── autocmds.lua         # Autocommands
│   ├── commands.lua         # Custom commands
│   ├── configs/
│   │   ├── conform.lua      # Formatter configuration
│   │   ├── lspconfig.lua    # LSP server setup
│   │   ├── lint.lua         # Linter configuration
│   │   ├── noice.lua        # Noice UI configuration
│   │   ├── nvdash.lua       # Dashboard buttons
│   │   ├── lazy.lua         # Lazy.nvim options
│   │   ├── cmp.lua          # Completion configuration
│   │   └── luasnip.lua      # Snippet configuration
│   └── plugins/
│       ├── init.lua         # Plugin specifications
│       ├── telescope.lua    # Telescope setup
│       └── gitgraph.lua     # Git graph plugin
```

## Plugins

| Category | Plugin | Description |
|----------|--------|-------------|
| **Core** | [NvChad](https://github.com/NvChad/NvChad) | Base configuration framework |
| **LSP** | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configurations |
| | [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP/Linter installer |
| | [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim) | Enhanced TypeScript support |
| **Completion** | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion engine |
| | [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| **Formatting** | [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatter runner |
| | [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Async linting |
| **UI** | [noice.nvim](https://github.com/folke/noice.nvim) | Enhanced UI for messages, cmdline, popupmenu |
| | [nvim-notify](https://github.com/rcarriga/nvim-notify) | Notification manager |
| | [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| | [markview.nvim](https://github.com/OXY2DEV/markview.nvim) | Markdown preview |
| **Navigation** | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| | [zellij-nav.nvim](https://git.sr.ht/~swaits/zellij-nav.nvim) | Zellij pane navigation |
| **Git** | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git decorations |
| | [gitgraph.nvim](https://github.com/isakbm/gitgraph.nvim) | Git graph visualization |
| **Editing** | [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround text objects |
| | [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Smart commenting |
| | [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets |
| | [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Syntax-aware text objects |
| **Terminal** | [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Terminal management |
| **Other** | [cord.nvim](https://github.com/vyfor/cord.nvim) | Discord Rich Presence |

## Key Mappings

Leader key: `Space`

### General

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | n | Save file |
| `Q` | n | Close window |
| `;` | n | Command mode |
| `jk` / `kj` | i | Exit insert mode |
| `<leader><leader>` | n | Find files (Telescope) |
| `sv` | n | Vertical split |
| `ss` | n | Horizontal split |
| `<leader>b` | n | New buffer |
| `<leader>th` | n | Change theme |

### LSP

| Key | Mode | Description |
|-----|------|-------------|
| `K` | n | Hover documentation |
| `<leader>ca` | n | Code actions |
| `<leader>fm` | n, v | Format file/selection |
| `<leader>dy` | n | Copy diagnostic to clipboard |
| `<leader>ih` | n | Toggle inlay hints |

### Imports (TypeScript)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>io` | n | Import symbol under cursor |
| `<leader>ia` | n | Import all missing symbols |
| `<leader>to` | n | Organize imports |
| `<leader>ts` | n | Sort imports |
| `<leader>tr` | n | Remove unused imports |
| `<leader>ti` | n | Add missing imports |
| `<leader>tf` | n | Fix all TS issues |

### Git

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gp` | n | Preview hunk |
| `<leader>gb` | n | Blame line |
| `<leader>gl` | n | Git graph |

### Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h/j/k/l>` | n | Navigate Zellij panes |
| `<C-\>` | n, t | Toggle terminal |

### Notifications

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>nn` | n | Dismiss notifications |

## LSP Servers

Automatically installed via Mason:

| Language | Server |
|----------|--------|
| Lua | `lua_ls` |
| TypeScript/JavaScript | `typescript-tools` (dedicated plugin) |
| HTML | `html` |
| CSS | `cssls` |
| Tailwind | `tailwindcss` |
| Emmet | `emmet_ls` |
| ESLint | `eslint` |
| JSON | `json-lsp` |
| Bash | `bashls` |
| Docker | `dockerfile-language-server`, `docker-compose-language-service` |
| Markdown | `marksman` |

## Formatters

Configured via Conform with format-on-save:

| Language | Formatter |
|----------|-----------|
| Lua | `stylua` |
| JavaScript/TypeScript | `prettier` |
| JSON/JSONC | `prettier` |
| HTML/CSS | `prettier` |
| Markdown | `prettier` |
| YAML | `prettier` |
| SQL | `sqlfmt` |
| Shell | `shfmt` |

## Treesitter Languages

Auto-installed: `vim`, `lua`, `vimdoc`, `html`, `css`, `javascript`, `typescript`, `tsx`, `json`, `yaml`, `markdown`, `bash`

## Customization

### Theme

The theme automatically syncs with macOS system appearance. To manually set a theme:

```lua
-- lua/chadrc.lua
M.base46 = {
  theme = "github_dark", -- or any NvChad theme
}
```

### Adding LSP Servers

```lua
-- lua/configs/lspconfig.lua
local servers = {
  "html",
  "cssls",
  -- Add your server here
}
```

### Adding Formatters

```lua
-- lua/configs/conform.lua
formatters_by_ft = {
  python = { "black" },
  -- Add your formatter here
}
```

## License

MIT
