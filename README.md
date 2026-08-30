# Dotfiles

A carefully curated collection of configuration files for a modern macOS development environment.

## Overview

This repository contains my personal dotfiles, featuring configurations for development tools, window management, and terminal customization.

### Development Environment

**Neovim**

- Custom IDE configuration with LSP integration
- Intelligent code completion and diagnostics
- Git integration and file navigation
- Custom dashboard and UI theming
- AI assistance integration

**Zed**

- Modern code editor configuration
- Custom keybindings and settings
- Optimized for performance

### Terminal Experience

**Ghostty**

- GPU-accelerated terminal emulator
- Custom themes and color schemes
- Performance-optimized configuration

**Zellij**

- Terminal workspace manager
- Custom layouts and keybindings
- Session management

**ZSH**

- Enhanced shell configuration
- Custom aliases and functions
- Advanced tab completion and syntax highlighting

### Window Management

**Aerospace**

- Tiling window manager for macOS
- Workspace management and custom layouts
- Keyboard-driven workflow

**SKHD**

- Custom keyboard shortcuts
- System-wide hotkey daemon
- Application launcher integration

### Development Tools

**Lazygit**

- Terminal UI for Git operations
- Streamlined version control workflow

**Lazydocker**

- Terminal UI for Docker management
- Container, image, and network management

**Mise**

- Runtime version manager
- Development environment configuration

**Starship**

- Cross-shell prompt
- Git status, language versions, custom segments

**Raycast**

- Productivity launcher
- Custom scripts and workflows

## Installation

### Prerequisites

- macOS (tested on macOS Sequoia)
- Homebrew
- Git
- ZSH
- Nerd Fonts

### Setup

Clone the repository to your `.config` directory:

```bash
cd ~/.config
git clone git@github.com:UgolinOlle/dotfiles.git .
```

### Dependencies

Install required packages via Homebrew:

```bash
brew install neovim
brew install ghostty
brew install --cask zed
brew install zellij
brew install aerospace
brew install koekeishiya/formulae/skhd
brew install lazygit
brew install lazydocker
brew install mise
brew install starship
brew install --cask raycast
```

## Configuration

### Neovim

Location: `~/.config/nvim` — see [nvim/README.md](nvim/README.md) for the full breakdown (plugins, keymaps, LSP servers).

Custom IDE configuration with modular structure. Modify settings through configuration files in `lua/` directory.

### Ghostty

Location: `~/.config/ghostty/config`

Terminal emulator settings including themes, fonts, and performance options.

### Zed

Location: `~/.config/zed/`

Editor configuration with custom keybindings in `keymap.json` and settings in `settings.json`.

### Aerospace

Location: `~/.config/aerospace/` — see [aerospace/README.md](aerospace/README.md) for workspace layout and keybindings.

Window manager configuration for tiling layouts and workspace management.

### SKHD

Location: `~/.config/skhd/`

System-wide keyboard shortcut configuration.

### ZSH

Location: `~/.config/zsh/`

Shell configuration including aliases, functions, and environment setup.

### Zellij

Location: `~/.config/zellij/`

Terminal multiplexer with custom layouts and keybindings.

### Lazygit

Location: `~/.config/lazygit/config.yml`

Git client configuration: Nerd Font icons, file tree view, auto-fetch, emoji parsing.

### Lazydocker

Location: `~/.config/lazydocker/config.yml`

Docker management interface configuration: log timestamps and lookback window.

### Mise

Location: `~/.config/mise/`

Runtime version manager configuration for development tools.

### Starship

Location: `~/.config/starship.toml`

Prompt segments, colors, and module ordering for the shell prompt.

## Customization

Configuration files are organized by tool. Navigate to the respective directory to modify settings:

```bash
cd ~/.config/<tool-name>
```

Each tool's configuration is self-contained and can be modified independently.

## Acknowledgments

- [Neovim](https://neovim.io/)
- [Ghostty](https://ghostty.org/)
- [Zed](https://zed.dev/)
- [Aerospace](https://github.com/nikitabobko/AeroSpace)
- [SKHD](https://github.com/koekeishiya/skhd)
- [Zellij](https://zellij.dev/)
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [Lazydocker](https://github.com/jesseduffield/lazydocker)
- [Mise](https://mise.jdx.dev/)
- [Starship](https://starship.rs/)
- [Raycast](https://raycast.com/)
