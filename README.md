# My Dotfiles 🚀

A carefully curated collection of configuration files and scripts for a streamlined development environment across macOS and Linux systems.

## 📋 Table of Contents

- [Overview](#overview)
- [What's Included](#whats-included)
- [Quick Start](#quick-start)
- [Repository Structure](#repository-structure)
- [Installation Guide](#installation-guide)
- [Configuration Details](#configuration-details)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🎯 Overview

This dotfiles repository contains my personal development environment configuration, optimized for productivity and efficiency. It includes configurations for modern terminal tools, editors, version control, and development utilities.

### Key Features
- **Automated Installation**: One-command setup with `install.sh`
- **Cross-Platform**: Works on both macOS and Linux
- **Modern Tools**: Curated selection of powerful CLI utilities
- **Organized Structure**: Clean organization using GNU Stow
- **Regular Updates**: Continuously maintained and improved

## 🛠 What's Included

### Shell & Terminal
- **Zsh**: Enhanced shell with Oh My Zsh framework
- **Starship**: Fast, customizable prompt
- **Tmux**: Terminal multiplexer with modern plugins
- **Ghostty**: Terminal emulator configuration

### Development Tools
- **Neovim**: Modern text editor configuration
- **Git**: Version control with helpful aliases and delta integration
- **Lazygit**: Beautiful Git UI
- **FZF**: Fuzzy finder for enhanced navigation

### Utilities & Enhancements
- **Yazi**: Modern file manager
- **Bat**: Syntax-highlighted `cat` replacement
- **Eza**: Modern `ls` replacement
- **Ripgrep**: Fast text search
- **Zoxide**: Smart directory jumping
- **Tree-sitter**: Advanced syntax highlighting

### Package Management
- **Homebrew**: Package manager with curated Brewfile
- **NVM**: Node.js version management

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yousefhadder/dotfiles.git ~/dotfiles

# Navigate to the directory
cd ~/dotfiles

# Run the installation script
./install.sh
```

The installation script will:
1. Update your system
2. Install Zsh and Oh My Zsh
3. Install Homebrew and all packages from the Brewfile
4. Copy utility scripts
5. Create symlinks for all configuration files
6. Set up your shell environment

## 📁 Repository Structure

```
dotfiles/
├── Brewfile                 # Homebrew package definitions
├── install.sh              # Automated installation script
├── README.md               # This file
├── .gitignore              # Git ignore patterns
├── .stowrc                 # GNU Stow configuration
│
├── git/
│   └── .gitconfig          # Git configuration and aliases
│
├── ghostty/                # Ghostty terminal configuration
│
├── lazygit/               # Lazygit UI configuration
│
├── nvim/                  # Neovim configuration and plugins
│
├── scripts/               # Utility scripts
│   ├── custom_modules/    # Custom tmux status modules
│   │   ├── ctp_battery.conf
│   │   ├── ctp_cpu.conf
│   │   ├── ctp_memory.conf
│   │   ├── pane_size.conf
│   │   └── primary_ip.conf
│   └── fzf-git.sh        # Enhanced git operations with fzf
│
├── starship/              # Starship prompt configuration
│
├── tmux/
│   └── .tmux.conf         # Tmux configuration with plugins
│
├── vim/
│   └── .vimrc             # Vim configuration
│
├── yazi/                  # Yazi file manager configuration
│
└── zsh/
    └── .zshrc             # Zsh shell configuration
```

## 📖 Installation Guide

### Prerequisites

- **macOS**: Xcode Command Line Tools
- **Linux**: `curl`, `git`, and your system's package manager
- **Both**: Internet connection for downloading packages

### Detailed Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yousefhadder/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Review the Brewfile** (optional):
   ```bash
   cat Brewfile
   ```

3. **Run Installation**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

4. **Restart Your Terminal** or run:
   ```bash
   exec zsh -l
   ```

### Manual Installation (Alternative)

If you prefer manual control:

1. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install packages:
   ```bash
   brew bundle --file=Brewfile
   ```

3. Install GNU Stow:
   ```bash
   brew install stow
   ```

4. Stow individual packages:
   ```bash
   stow zsh tmux nvim git
   ```

## ⚙️ Configuration Details

### Zsh Configuration
- **Oh My Zsh**: Framework with curated plugins
- **Aliases**: Modern alternatives (`eza` for `ls`, `bat` for `cat`)
- **Environment Variables**: Optimized PATH and tool configurations
- **Plugin Support**: Git integration, syntax highlighting, autosuggestions

### Tmux Setup
- **Plugin Manager**: Automatic TPM installation
- **Theme**: Catppuccin Mocha theme
- **Key Plugins**: 
  - Vim navigation integration
  - Battery and system monitoring
  - Session management
  - Text extraction tools

### Git Configuration
- **Delta Integration**: Enhanced diff viewing
- **LFS Support**: Large file handling
- **Editor**: Neovim as default editor
- **Aliases**: Convenient shortcuts for common operations

### Development Environment
- **Node.js**: NVM for version management
- **Go**: GOPATH and GOROOT configuration
- **Ruby**: Homebrew Ruby with gem paths
- **Editor**: Neovim with modern features

## 🎨 Customization

### Adding New Packages

1. **Add to Brewfile**:
   ```ruby
   brew "package-name"
   ```

2. **Create configuration directory**:
   ```bash
   mkdir package-name
   ```

3. **Add configuration files** and stow:
   ```bash
   stow package-name
   ```

### Modifying Existing Configurations

1. **Edit files directly** in their respective directories
2. **Re-stow** if needed:
   ```bash
   stow -R package-name
   ```

### Environment-Specific Settings

Use conditional logic in configurations:
```bash
# In .zshrc
if [ "$(uname)" = "Darwin" ]; then
    # macOS specific settings
elif [ "$(uname)" = "Linux" ]; then
    # Linux specific settings
fi
```

## 🔧 Troubleshooting

### Common Issues

**Stow conflicts**:
```bash
stow -D package-name  # Remove existing links
stow package-name     # Re-create links
```

**Permission errors**:
```bash
sudo chown -R $(whoami) ~/.config
```

**Homebrew path issues**:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
```

**Oh My Zsh installation fails**:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

### Getting Help

1. Check the [Issues](https://github.com/yousefhadder/dotfiles/issues) page
2. Review individual tool documentation
3. Test configurations in isolation

## 🤝 Contributing

This repository is in active development and contributions are welcome!

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Test thoroughly** on both macOS and Linux if possible
5. **Submit a pull request**

### Guidelines

- Maintain cross-platform compatibility
- Document new features or significant changes
- Test installation script changes
- Follow existing code style and organization
- Add appropriate comments for complex configurations

### Reporting Issues

When reporting issues, please include:
- Operating system and version
- Terminal emulator being used
- Complete error messages
- Steps to reproduce the problem

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) community
- [Homebrew](https://brew.sh/) maintainers
- [GNU Stow](https://www.gnu.org/software/stow/) developers
- Various open-source tool creators and maintainers

---

**Happy coding!** 🎉

If you find these dotfiles helpful, please consider giving the repository a star ⭐