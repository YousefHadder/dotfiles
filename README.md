# My Dotfiles 🚀

A carefully curated collection of configuration files and scripts for a streamlined development environment across macOS and Linux systems.

# Table of Contents

- [My Dotfiles 🚀](#my-dotfiles)
- [Table of Contents](#table-of-contents)
  - [🎯 Overview](#overview)
    - [Key Features](#key-features)
  - [🛠 What's Included](#whats-included)
    - [Shell & Terminal](#shell-terminal)
    - [Development Tools](#development-tools)
    - [Utilities & Enhancements](#utilities-enhancements)
    - [Package Management](#package-management)
  - [🚀 Quick Start](#quick-start)
- [Clone the repository](#clone-the-repository)
- [Navigate to the directory](#navigate-to-the-directory)
- [Run the installation script](#run-the-installation-script)
    - [GitHub Codespaces Support](#github-codespaces-support)
  - [📁 Repository Structure](#repository-structure)
  - [📖 Installation Guide](#installation-guide)
    - [Prerequisites](#prerequisites)
    - [Detailed Installation Steps](#detailed-installation-steps)
    - [What Gets Installed](#what-gets-installed)
    - [Manual Installation (Alternative)](#manual-installation-alternative)
  - [⚙️ Configuration Details](#configuration-details)
    - [Zsh Configuration](#zsh-configuration)
    - [Neovim Setup (Comprehensive Development Environment)](#neovim-setup-comprehensive-development-environment)
    - [Tmux Setup](#tmux-setup)
    - [Git Configuration](#git-configuration)
    - [Starship Prompt](#starship-prompt)
  - [🎨 Customization](#customization)
    - [Adding New Packages](#adding-new-packages)
    - [Modifying Existing Configurations](#modifying-existing-configurations)
    - [Neovim Plugin Management](#neovim-plugin-management)
    - [Environment-Specific Settings](#environment-specific-settings)
- [In .zshrc - automatic platform detection](#in-zshrc-automatic-platform-detection)
    - [Stow Package Management](#stow-package-management)
  - [🔧 Troubleshooting](#troubleshooting)
    - [Common Issues](#common-issues)
- [Remove plugin cache and restart](#remove-plugin-cache-and-restart)
- [Manually install TPM and plugins](#manually-install-tpm-and-plugins)
    - [Getting Help](#getting-help)
  - [🚀 Key Features & Shortcuts](#key-features-shortcuts)
    - [Neovim Shortcuts (Some Highlights)](#neovim-shortcuts-some-highlights)
    - [Tmux Shortcuts](#tmux-shortcuts)
    - [Zsh Aliases](#zsh-aliases)
  - [🤝 Contributing](#contributing)
    - [How to Contribute](#how-to-contribute)
    - [Guidelines](#guidelines)
    - [Areas for Contribution](#areas-for-contribution)
    - [Reporting Issues](#reporting-issues)
  - [📄 License](#license)
  - [🙏 Acknowledgments](#acknowledgments)
  - [🔗 Related Projects](#related-projects)



## 🎯 Overview

This dotfiles repository contains my personal development environment configuration, optimized for productivity and efficiency. It includes configurations for modern terminal tools, editors, version control, and development utilities with full **GitHub Codespaces** support.

### Key Features
- **Modular Architecture**: Organized installation scripts and Zsh configuration for maintainability
- **Automated Installation**: One-command setup with comprehensive `install.sh`
- **Cross-Platform**: Works on macOS, Linux, and GitHub Codespaces
- **Modern Tools**: Curated selection of powerful CLI utilities
- **Organized Structure**: Clean organization using GNU Stow
- **Developer-Focused**: Optimized for coding with LSP, Copilot, and modern workflows
- **Extensive Neovim Setup**: Complete Lua-based configuration with 30+ plugins

## 🛠 What's Included

### Shell & Terminal
- **Zsh**: Enhanced shell with Oh My Zsh framework and modern plugins
- **Starship**: Fast, customizable prompt with Dracula theme
- **Tmux**: Terminal multiplexer with Catppuccin theme and productivity plugins
- **Ghostty**: High-performance terminal emulator configuration

### Development Tools
- **Neovim**: Comprehensive Lua configuration with:
  - LSP integration (Mason, nvim-lspconfig)
  - GitHub Copilot and CopilotChat
  - Modern completion with blink.cmp
  - File management with Neo-tree and fzf-lua
  - Testing framework (Neotest)
  - Session persistence and much more
- **Git**: Optimized configuration with helpful aliases
- **Lazygit**: Beautiful terminal Git UI with custom configuration
- **FZF**: Fuzzy finder with Git integration scripts

### Utilities & Enhancements
- **Yazi**: Modern file manager with custom themes and keymaps
- **Bat**: Syntax-highlighted `cat` replacement
- **Eza**: Modern `ls` replacement with icons
- **Ripgrep**: Ultra-fast text search
- **Zoxide**: Smart directory jumping (`cd` replacement)
- **Tree-sitter**: Advanced syntax highlighting
- **fd**: Fast alternative to `find`
- **pay-respects**: Command correction tool
- **yq**: YAML/JSON processor

### Package Management
- **Homebrew**: Package manager with comprehensive Brewfile
- **NVM**: Node.js version management
- **Lua/LuaJIT**: For Neovim configuration and tools

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/YousefHadder/dotfiles.git ~/dotfiles

# Navigate to the directory
cd ~/dotfiles

# Run the installation script
./install.sh
```

The installation script will:
1. **Bootstrap Phase**: Update system, install Zsh and Oh My Zsh
2. **Installation Phase**: Install Homebrew and all packages from Brewfile
3. **Configuration Phase**: Copy scripts and create symlinks using GNU Stow
4. **Finalization**: Switch to new Zsh shell with all configurations active

The `install.sh` script is now modular and organized into separate components in the `install/` directory for better maintainability.

### GitHub Codespaces Support
This repository is fully configured for GitHub Codespaces with automatic environment detection and non-interactive installation.

## 📁 Repository Structure

```
dotfiles/
├── Brewfile                 # Homebrew package definitions
├── install.sh              # Main installation script
├── README.md               # This comprehensive guide
├── .gitignore              # Git ignore patterns
├── .stowrc                 # GNU Stow configuration
├── .luarc.json             # Lua LSP configuration
│
├── install/               # Modular installation scripts
│   ├── bootstrap.sh       # System bootstrap and Zsh setup
│   ├── homebrew.sh        # Homebrew installation
│   ├── languages.sh       # Programming language setup
│   ├── packages.sh        # Package installation via Homebrew
│   ├── scripts.sh         # Script copying and permissions
│   ├── symlinks.sh        # GNU Stow symlink creation
│   └── utils.sh           # Utility functions and helpers
│
├── git/
│   └── .gitconfig          # Git configuration and aliases
│
├── ghostty/                # Ghostty terminal configuration
│   └── .config/ghostty/
│       └── config          # Terminal settings
│
├── lazygit/               # Lazygit UI configuration
│   └── .config/lazygit/
│       └── config.yml     # Lazygit settings
│
├── nvim/                  # Neovim configuration (30+ plugins)
│   └── .config/nvim/
│       ├── init.lua       # Main entry point
│       └── lua/yousef/    # Personal configuration modules
│           ├── config/    # Core settings (options, keymaps, autocmds)
│           ├── plugins/   # Plugin configurations (LSP, Copilot, etc.)
│           └── lazy.lua   # Lazy.nvim plugin manager setup
│
├── scripts/               # Utility scripts
│   ├── custom_modules/    # Custom tmux status modules
│   │   ├── ctp_battery.conf   # Battery status
│   │   ├── ctp_cpu.conf       # CPU monitoring
│   │   ├── ctp_memory.conf    # Memory usage
│   │   ├── pane_size.conf     # Pane size indicator
│   │   └── primary_ip.conf    # IP address display
│   ├── fzf-git.sh        # Enhanced git operations with fzf
│   └── update_pane_size.sh   # Tmux pane size updater
│
├── starship/              # Starship prompt configuration
│   └── .config/
│       └── starship.toml  # Custom prompt with Dracula theme
│
├── tmux/
│   └── .tmux.conf         # Tmux configuration with Catppuccin theme
│
├── vim/
│   └── .vimrc             # Vim configuration (fallback)
│
├── yazi/                  # Yazi file manager configuration
│   └── .config/yazi/
│       ├── keymaps.toml   # Custom key bindings
│       ├── theme.toml     # Visual theme
│       └── yazi.toml      # Main configuration
│
└── zsh/
    ├── .zshrc             # Main Zsh configuration
    └── conf.d/            # Modular Zsh configuration files
        ├── 00-paths.zsh   # PATH and environment paths
        ├── 01-environment.zsh  # Environment variables
        ├── 02-homebrew.zsh     # Homebrew configuration
        ├── 03-oh-my-zsh.zsh    # Oh My Zsh setup and plugins
        ├── 04-editor.zsh       # Editor preferences
        ├── 05-tools.zsh        # Tool-specific configurations
        ├── 06-fzf.zsh          # FZF fuzzy finder setup
        ├── 07-plugins.zsh      # Additional Zsh plugins
        └── 08-functions.zsh    # Custom shell functions
```

## 📖 Installation Guide

### Prerequisites

- **macOS**: Xcode Command Line Tools (automatically installed by script)
- **Linux**: `curl`, `git`, and system package manager (apt, yum, or dnf)
- **GitHub Codespaces**: Ready to use (no additional setup required)
- **Both**: Internet connection for downloading packages

### Detailed Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/YousefHadder/dotfiles.git ~/dotfiles
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

4. **Automatic Shell Switch**: The script automatically switches to Zsh with all configurations loaded

### What Gets Installed

The Brewfile includes these essential packages:
- **Core Tools**: `stow`, `fzf`, `bat`, `eza`, `ripgrep`, `fd`, `tree`, `yq`
- **Development**: `node`, `nvm`, `lua`, `luajit`, `luarocks`, `prettier`, `make`
- **Terminal**: `tmux`, `neovim`, `starship`, `tree-sitter`
- **Git Tools**: `lazygit`
- **Navigation**: `yazi`, `zoxide`, `pay-respects`
- **Shell**: `zsh-autosuggestions`, `zsh-syntax-highlighting`

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
   stow zsh tmux nvim git starship lazygit yazi
   ```

## ⚙️ Configuration Details

### Zsh Configuration
The Zsh configuration is now **modular and organized** into separate files in `zsh/conf.d/` for better maintainability:

- **Modular Structure**: Configuration split into logical components (paths, environment, tools, etc.)
- **Load Order**: Files are loaded in numerical order (00-08) for proper dependency management
- **Oh My Zsh**: Framework with Git and rbenv plugins configured in `03-oh-my-zsh.zsh`
- **Modern Aliases**: Defined in various files based on functionality
  - `ls` → `eza --icons=always` with variants (`ll`, `la`, `lt`)
  - `cd` → `z` (zoxide smart jumping)
  - `vim` → `nvim`
- **Environment Variables**: Optimized PATH, GOPATH, and tool configurations in dedicated files
- **Cross-Platform**: Automatic Homebrew path detection for macOS/Linux in `02-homebrew.zsh`

### Neovim Setup (Comprehensive Development Environment)
- **Plugin Manager**: Lazy.nvim for fast, lazy-loaded plugins
- **LSP Integration**:
  - Mason for LSP server management
  - Full language support with nvim-lspconfig
  - Intelligent completion with blink.cmp
- **AI Integration**:
  - GitHub Copilot for code suggestions
  - CopilotChat for AI conversations
- **File Management**:
  - Neo-tree for project exploration
  - fzf-lua for fuzzy finding
  - Telescope for advanced searching
- **Development Tools**:
  - Treesitter for syntax highlighting
  - Which-key for keybinding discovery
  - Neotest for testing frameworks
  - Conform for code formatting
- **UI Enhancements**:
  - Lualine for statusline
  - Bufferline for tab management
  - Alpha for dashboard
  - Noice for command line UI

### Tmux Setup
- **Theme**: Catppuccin Mocha with custom styling
- **Plugin Manager**: TPM with automatic installation
- **Key Plugins**:
  - Vim navigation integration (christoomey/vim-tmux-navigator)
  - System monitoring (CPU, battery, memory)
  - Enhanced copy/paste with tmux-yank
  - Session management with sessionx
  - Text extraction with extrakto
  - Window naming with nerd font support

### Git Configuration
- **Editor Integration**: Neovim as default editor
- **LFS Support**: Large file handling enabled
- **Cross-Platform**: Proper line ending handling
- **Performance**: Optimized with useful aliases

### Starship Prompt
- **Theme**: Custom Dracula palette
- **Modules**: OS, directory, Git status, Node.js, AWS, execution time
- **Layout**: Two-line format with comprehensive information display

## 🎨 Customization

### Adding New Packages

1. **Add to Brewfile**:
   ```ruby
   brew "package-name"
   # or for GUI applications
   cask "app-name"
   ```

2. **Install the package**:
   ```bash
   brew bundle --file=Brewfile
   ```

3. **Create configuration directory** (if needed):
   ```bash
   mkdir package-name
   # Add your config files
   ```

4. **Stow the configuration**:
   ```bash
   stow package-name
   ```

### Modifying Existing Configurations

1. **Edit files directly** in their respective directories:
   ```bash
   # Example: Edit Neovim config
   nvim nvim/.config/nvim/lua/yousef/config/options.lua

   # Example: Edit Zsh environment variables
   nvim zsh/conf.d/01-environment.zsh

   # Example: Edit installation script component
   nvim install/packages.sh
   ```

2. **Re-stow if needed**:
   ```bash
   stow -R package-name
   ```

### Neovim Plugin Management

Add new plugins to the appropriate file in `nvim/.config/nvim/lua/yousef/plugins/`:
```lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

### Environment-Specific Settings

The configurations include cross-platform compatibility:
```bash
# In .zshrc - automatic platform detection
if [ "$(uname)" = "Darwin" ]; then
  BREW_HOME="/opt/homebrew"
elif [ "$(uname)" = "Linux" ]; then
  BREW_HOME="/home/linuxbrew/.linuxbrew"
fi
```

### Stow Package Management

The `.stowrc` file automatically ignores certain files:
- `.stowrc` itself
- `DS_Store` files
- `Brewfile`
- `install.sh`
- `scripts` directory

**Note**: The `git` and `ghostty` packages are intentionally skipped during automated stowing in the install script.

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

**Homebrew path issues** (macOS):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
```

**Homebrew path issues** (Linux):
```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
```

**Oh My Zsh installation fails**:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

**Neovim plugins not loading**:
```bash
# Remove plugin cache and restart
rm -rf ~/.local/share/nvim
nvim --headless "+Lazy! sync" +qa
```

**Tmux plugins not working**:
```bash
# Manually install TPM and plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

**GitHub Codespaces specific issues**:
- The dotfiles are automatically copied to `/workspaces/.codespaces/.persistedshare/dotfiles`
- Environment variables are automatically configured for Codespaces
- No manual intervention required during installation

### Getting Help

1. Check the [Issues](https://github.com/YousefHadder/dotfiles/issues) page
2. Review individual tool documentation:
   - [Neovim](https://neovim.io/doc/)
   - [Tmux](https://github.com/tmux/tmux/wiki)
   - [Oh My Zsh](https://ohmyz.sh/)
   - [Starship](https://starship.rs/)
3. Test configurations in isolation
4. Check plugin-specific documentation for Neovim issues

## 🚀 Key Features & Shortcuts

### Neovim Shortcuts (Some Highlights)
- **Leader Key**: `<Space>`
- **File Explorer**: `<leader>e` (Snacks Explorer)
- **Find Files**: `<leader>ff` (telescope find files)
- **Find Text**: `<leader>fg` (telescope grep text)
- **Git Status**: `<leader>gs` (telescope git status)
- **Copilot Chat**: `<leader>aa`
- **Format Code**: `<leader>cf` (code format)
- **LSP Actions**: `<leader>ca` (code actions)

### Tmux Shortcuts
- **Prefix**: `Ctrl+b`
- **Split Horizontal**: `Prefix + |`
- **Split Vertical**: `Prefix + -`
- **Vim Navigation**: `Ctrl+h/j/k/l`
- **Session Manager**: `Prefix + o` (sessionx)

### Zsh Aliases
- **Enhanced ls**: `l`, `ll`, `la`, `lt` (with icons)
- **Smart cd**: `z <directory>` (zoxide)
- **Git shortcuts**: Provided by Oh My Zsh git plugin

## 🤝 Contributing

This repository is in active development and contributions are welcome!

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes** following the existing structure
4. **Test thoroughly** on both macOS and Linux if possible
5. **Update documentation** if adding new features
6. **Submit a pull request**

### Guidelines

- **Maintain cross-platform compatibility** (macOS, Linux, Codespaces)
- **Document new features** or significant changes in the README
- **Test installation script changes** thoroughly
- **Follow existing code style** and organization
- **Add appropriate comments** for complex configurations
- **Update Brewfile** when adding new packages
- **Use proper Stow structure** for new configurations

### Areas for Contribution

- **New tool configurations** (following existing patterns)
- **Neovim plugin additions** (with proper configuration)
- **Tmux enhancements** (new plugins or themes)
- **Shell improvements** (new aliases or functions)
- **Cross-platform compatibility** fixes
- **Documentation improvements**
- **Installation script enhancements**

### Reporting Issues

When reporting issues, please include:
- **Operating system** and version (macOS/Linux/Codespaces)
- **Terminal emulator** being used
- **Complete error messages** (with full stack traces)
- **Steps to reproduce** the problem
- **Expected vs actual behavior**
- **Relevant configuration files** that might be involved

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

This dotfiles repository is built on the shoulders of giants. Special thanks to:

- **Framework Creators**:
  - [Oh My Zsh](https://ohmyz.sh/) community for shell enhancement
  - [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
  - [Starship](https://starship.rs/) for the amazing prompt

- **Package Managers**:
  - [Homebrew](https://brew.sh/) maintainers for cross-platform packages
  - [GNU Stow](https://www.gnu.org/software/stow/) developers for symlink management

- **Theme & Plugin Authors**:
  - [Catppuccin](https://github.com/catppuccin) for beautiful terminal themes
  - All Neovim plugin authors for extending editor capabilities
  - Tmux plugin ecosystem contributors

- **Tool Creators**:
  - Modern CLI tool authors (eza, bat, ripgrep, fd, yazi, etc.)
  - [fzf](https://github.com/junegunn/fzf) and related fuzzy finder tools

## 🔗 Related Projects

- **Neovim Configurations**: [LazyVim](https://github.com/LazyVim/LazyVim), [NvChad](https://github.com/NvChad/NvChad)
- **Dotfiles Inspiration**: [GitHub does dotfiles](https://dotfiles.github.io/)
- **Terminal Themes**: [Catppuccin](https://github.com/catppuccin/catppuccin)

---

**Happy coding!** 🎉

If you find these dotfiles helpful, please consider:
- ⭐ **Starring the repository**
- 🍴 **Forking for your own use**
- 🐛 **Reporting issues** you encounter
- 💡 **Contributing improvements**

*Built with ❤️ for developers who value productivity and beautiful terminals.*
