# Yousef's Neovim Configuration

A comprehensive, modern Neovim configuration focused on software development with AI integration, custom theming, and an extensive plugin ecosystem.

## 🚀 Features

- **Custom Slate Theme**: Beautiful dark colorscheme applied consistently across all UI components
- **Dual Search Systems**: Both Telescope and FZF-Lua for different fuzzy finding needs
- **Complete LSP Setup**: Multi-language support with enhanced diagnostics and features
- **AI Integration**: GitHub Copilot and Claude Sonnet 4 for enhanced productivity
- **Modern UI**: Enhanced interfaces with Noice, custom dashboard, and cohesive theming
- **Git Workflow**: Comprehensive git integration and visualization tools
- **Testing Support**: Multi-language test runners with Neotest
- **Session Management**: Automatic session saving and restoration

## 📁 Configuration Structure

```
.config/nvim/
├── init.lua                    # Entry point
├── lazy-lock.json             # Plugin lock file
├── lua/yousef/
│   ├── config/
│   │   ├── init.lua           # Configuration loader
│   │   ├── options.lua        # Neovim options and settings
│   │   ├── keymaps.lua        # Key mappings and shortcuts
│   │   └── autocmds.lua       # Autocommands and events
│   ├── lazy.lua               # Lazy.nvim plugin manager setup
│   └── plugins/               # Individual plugin configurations
└── queries/                   # Custom Treesitter queries
```

## ⚡ Quick Start

1. **Prerequisites**:
   - Neovim 0.9+ 
   - Git
   - A Nerd Font for icons
   - Node.js (for some LSP servers)
   - Go, Python, etc. (for language-specific features)

2. **Installation**:
   ```bash
   git clone <this-repo> ~/.config/nvim
   nvim
   ```

3. **First Launch**: Lazy.nvim will automatically install all plugins on first startup.

## 🎯 Key Bindings

### Leader Key
- **Leader**: `<Space>`
- **Local Leader**: `<Space>`

### Essential Mappings
| Key | Mode | Action |
|-----|------|--------|
| `jk` | Insert | Exit insert mode |
| `<Esc>` | Normal | Clear search highlight |
| `<Tab>` | Normal | Next buffer |
| `<S-Tab>` | Normal | Previous buffer |

### Navigation & Movement
| Key | Mode | Action |
|-----|------|--------|
| `<C-h/j/k/l>` | Normal/Visual | Window navigation |
| `<C-d/u>` | Normal | Scroll half page (centered) |
| `n/N` | Normal | Search next/previous (centered) |
| `<A-k/j>` | Normal/Visual | Move lines up/down |

### File Operations
| Key | Mode | Action |
|-----|------|--------|
| `<leader>wa` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<leader>Q` | Normal | Quit all |
| `<leader>rf` | Normal | Reload config |

### Window Management
| Key | Mode | Action |
|-----|------|--------|
| `<leader>|` | Normal | Vertical split |
| `<leader>-` | Normal | Horizontal split |
| `<leader>m[h/j/k/l]` | Normal | Move split |
| Arrow keys | Normal | Resize windows |

### Search & Navigation
| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | Find buffers |
| `<leader>fh` | Normal | Help tags |
| `s` | Normal | Flash navigation |

### AI & Copilot
| Key | Mode | Action |
|-----|------|--------|
| `<S-Tab>` | Insert | Accept Copilot suggestion |
| `<C-w>` | Insert | Accept Copilot word |
| `<C-l>` | Insert | Accept Copilot line |
| `<leader>ac` | Normal | Copilot Chat |
| `<leader>ae` | Normal | Explain code |

### LSP & Development
| Key | Mode | Action |
|-----|------|--------|
| `<leader>ca` | Normal | Code actions |
| `<leader>cf` | Normal | Format buffer |
| `<leader>th` | Normal | Toggle inlay hints |
| `gd` | Normal | Go to definition |
| `gr` | Normal | Go to references |

### Testing
| Key | Mode | Action |
|-----|------|--------|
| `<leader>tr` | Normal | Run test |
| `<leader>ts` | Normal | Run test suite |
| `<leader>tt` | Normal | Toggle test summary |

### Git
| Key | Mode | Action |
|-----|------|--------|
| `<leader>gg` | Normal | Lazygit |
| `<leader>gP` | Normal | Git praise |

### Terminal
| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Open terminal |
| `<leader>ts` | Normal | Terminal in split |
| `<leader>tv` | Normal | Terminal in vertical split |
| `<Esc><Esc>` | Terminal | Exit terminal mode |

## 🔧 Configuration Highlights

### Neovim Options
- **Line numbers**: Relative line numbers enabled
- **Mouse support**: Full mouse integration
- **Clipboard**: System clipboard integration
- **Persistent undo**: Undo history preserved across sessions
- **Smart search**: Case-insensitive with smart case detection
- **Performance**: Optimized updatetime and timeoutlen

### Autocommands
- **Auto-save formatting**: Removes trailing whitespace on save
- **Cursor positioning**: Remembers last cursor position
- **File type detection**: Enhanced file type recognition
- **Large file handling**: Disables features for files > 10MB
- **Terminal enhancements**: Auto-insert mode for terminals

## 🎨 Theme & UI

### Custom Slate Colorscheme
The configuration uses a custom slate colorscheme that provides:
- **Consistent theming** across all UI elements
- **Enhanced syntax highlighting** with carefully chosen colors
- **Modern transparency** effects where appropriate
- **LSP and diagnostic** color integration

### UI Enhancements
- **Alpha Dashboard**: Custom start screen with Palestine flag ASCII art
- **Lualine**: Informative status line with git, diagnostics, and file info
- **Bufferline**: Enhanced buffer tabs with diagnostic indicators
- **Noice**: Improved command line and notification UI

## 🔌 Plugin Ecosystem

### Core Plugins
- **Lazy.nvim**: Modern plugin manager
- **nvim-lspconfig**: LSP configuration
- **nvim-treesitter**: Advanced syntax highlighting
- **blink.cmp**: Modern completion engine

### Navigation & Search
- **Telescope**: Fuzzy finder for files and LSP
- **fzf-lua**: Alternative fuzzy finder with Git integration
- **flash.nvim**: Enhanced navigation with labels
- **snacks.nvim**: Multi-purpose utilities

### Development Tools
- **Mason**: LSP server and tool management
- **Conform**: Code formatting
- **Gitsigns**: Git integration in sign column
- **Neotest**: Test runner interface

### AI Integration
- **Copilot**: GitHub AI code completion
- **CopilotChat**: Claude Sonnet 4 integration for AI assistance

### Text Editing
- **nvim-surround**: Surround text objects
- **nvim-autopairs**: Automatic bracket pairing
- **mini.nvim**: Collection of useful utilities

### Quality of Life
- **which-key**: Keymap help and discovery
- **persistence**: Session management
- **guess-indent**: Automatic indentation detection
- **nvim-colorizer**: Color highlighting in files

## 🌍 Language Support

The configuration provides comprehensive support for:

- **Go**: gopls, gofmt, tests
- **TypeScript/JavaScript**: typescript-language-server, Prettier, ESLint
- **Python**: pyright, black, ruff
- **Lua**: lua_ls with Neovim API support
- **Rust**: rust-analyzer, rustfmt
- **Ruby**: solargraph, RuboCop
- **JSON/YAML**: Schema validation and formatting
- **Markdown**: Enhanced rendering and formatting

## 🛠️ Customization

### Adding New Plugins
1. Create a new file in `lua/yousef/plugins/`
2. Return a plugin specification table
3. Lazy.nvim will automatically load it

### Modifying Keymaps
Edit `lua/yousef/config/keymaps.lua` to add or modify key bindings.

### Changing Options
Modify `lua/yousef/config/options.lua` for Neovim settings.

### Theme Customization
The custom colorscheme is defined in `lua/yousef/plugins/colorscheme.lua`.

## 🔍 Troubleshooting

### Common Issues
1. **LSP not working**: Ensure language servers are installed via Mason
2. **Icons not showing**: Install a Nerd Font and set it in your terminal
3. **Slow startup**: Check for plugin conflicts or large files
4. **Clipboard issues**: Ensure system clipboard tools are installed

### Health Checks
Run `:checkhealth` to diagnose configuration issues.

### Logs
Check `:Lazy log` for plugin-related issues.

## 📚 Learning Resources

- **Which-Key**: Press `<leader>` and wait to see available keymaps
- **Telescope**: Use `<leader>fh` to search help tags
- **LSP**: Use `<leader>ca` for code actions and hover for documentation

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Report issues or bugs
- Suggest improvements
- Fork and adapt for your needs

## 📄 License

This configuration is provided as-is for educational and personal use.