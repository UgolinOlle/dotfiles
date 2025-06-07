# Dotfiles

A carefully curated collection of configuration files for a modern macOS development environment.

## 🌟 Overview

This repository contains my personal dotfiles, featuring configurations for:

- Neovim (WhoaIDE custom configuration)
- WezTerm Terminal
- ZSH with Oh My Zsh
- Karabiner-Elements
- Aerospace (Window Manager)
- Raycast
- Lazydocker
- Oh My Posh
- GitHub CLI

## ⚡ Key Features

### [🚀 WhoaIDE (Neovim Configuration)](https://github.com/UgolinOlle/WhoaIDE)

A powerful Neovim-based IDE with features including:

- LSP integration with automatic server installation
- Intelligent code completion
- Git integration
- File tree and fuzzy finding
- Diagnostic tools
- Custom note-taking system
- AI assistance (GitHub Copilot)
- Beautiful UI with custom dashboard

### 🖥️ Terminal Setup

#### WezTerm Terminal

- Modern GPU-accelerated terminal emulator
- Custom configuration for optimal development experience
- Multiple profiles for different use cases
- Custom keybindings and shortcuts

#### ZSH Configuration

- Oh My Zsh with custom plugins
- Powerlevel10k theme
- Custom aliases and functions
- Enhanced tab completion
- Syntax highlighting
- Auto-suggestions
- Zoxide for smart directory jumping

### 🎯 Window Management

#### Aerospace

- Tiling window manager for macOS
- Custom keybindings for window management
- Workspace management
- Layout presets

#### Karabiner-Elements

- Custom keyboard shortcuts
- Modifier key remapping
- Application-specific keybindings
- Complex modifications

### 🛠️ Development Tools

#### Lazydocker

- Terminal UI for Docker
- Container management
- Image management
- Volume management
- Network management

#### GitHub CLI

- Enhanced GitHub workflow
- Custom aliases and configurations
- Repository management
- Issue and PR management

## 🛠️ Installation

### Prerequisites

- macOS (tested on macOS Sonoma)
- Homebrew
- Git
- ZSH
- Node.js (LTS version recommended)
- Python 3
- Nerd Fonts

### Installation Steps

1. Clone the repository:

```bash
git clone https://github.com/UgolinOlle/dotfiles.git
cd dotfiles
```

2. Create symbolic links:

```bash
# Neovim
ln -s ~/dotfiles/nvim ~/.config/nvim

# WezTerm
ln -s ~/dotfiles/wezterm ~/.config/wezterm

# ZSH
ln -s ~/dotfiles/.zshrc ~/.zshrc

# Karabiner
ln -s ~/dotfiles/karabiner ~/.config/karabiner

# Aerospace
ln -s ~/dotfiles/aerospace ~/.config/aerospace

# Raycast
ln -s ~/dotfiles/raycast ~/.config/raycast

# Lazydocker
ln -s ~/dotfiles/lazydocker ~/.config/lazydocker

# Oh My Posh
ln -s ~/dotfiles/oh-my-posh ~/.config/oh-my-posh
```

3. Install dependencies:

```bash
# Install Homebrew packages
brew bundle

# Install Node.js dependencies
npm install -g typescript-language-server typescript

# Install Python dependencies
pip3 install pynvim

# Install Rust dependencies
cargo install exa
```

## 📦 Dependencies

### Core Dependencies

- Neovim (>= 0.9.0)
- WezTerm
- ZSH
- Oh My Zsh
- Powerlevel10k
- Karabiner-Elements
- Aerospace
- Raycast
- Lazydocker
- GitHub CLI

### Development Dependencies

- Node.js
- Python 3
- Rust
- Git
- Ripgrep
- FZF
- Zoxide
- Exa
- Bat

## ⚙️ Configuration

### Neovim (WhoaIDE)

The Neovim configuration is modular and can be customized through:

- `~/.config/nvim/lua/whoa/configs/features.lua` - Toggle features
- `~/.config/nvim/user/main.lua` - User-specific configurations

### ZSH Configuration

Key configuration files:

- `~/.zshrc` - Main ZSH configuration
- `~/.p10k.zsh` - Powerlevel10k theme configuration

### Window Management

- Aerospace configuration: `~/.config/aerospace/config.yaml`
- Karabiner configuration: `~/.config/karabiner/karabiner.json`

## 🔧 Customization

### Adding New Configurations

1. Create a new directory in the root of the repository
2. Add your configuration files
3. Update the installation instructions in this README
4. Create symbolic links in the installation script

### Modifying Existing Configurations

1. Locate the configuration file in the repository
2. Make your changes
3. Test the changes
4. Commit and push your changes

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Neovim](https://neovim.io/)
- [WezTerm](https://wezfurlong.org/wezterm/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Aerospace](https://github.com/nikitabobko/AeroSpace)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
- [Raycast](https://raycast.com/)
- [Lazydocker](https://github.com/jesseduffield/lazydocker)

## 📧 Contact

For questions or suggestions, feel free to reach out through:

- GitHub Issues
- Email: [hello@ugolin-olle.com](mailto:hello@ugolin-olle.com)
