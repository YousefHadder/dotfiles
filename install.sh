#!/bin/bash
set -e



# Install xCode cli tools
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS deteted..."

    if xcode-select -p &>/dev/null; then
        echo "Xcode already installed"
    else
        echo "Installing commandline tools..."
        xcode-select --install
    fi
fi

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
## install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
## install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap homebrew/cask-fonts
brew tap FelixKratz/formulae

## Formulae
echo "Installing Brew Formulae..."
### Must Have things
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
brew install stow
brew install fzf
brew install bat
brew install fd
brew install zoxide
brew install lua
brew install luajit
brew install luarocks
brew install prettier
brew install make
brew install qmk
brew install ripgrep

### Terminal
brew install git
brew install lazygit
brew install tmux
brew install neovim
brew install starship
brew install tree-sitter
brew install tree
brew install borders

### dev things
brew install node
brew install nvm

## Casks
brew install --cask raycast
brew install --cask karabiner-elements
brew install --cask wezterm
brew install --cask aerospace
brew install --cask keycastr
brew install --cask betterdisplay
brew install --cask linearmouse
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-sf-pro

csrutil status
echo "Installation complete..."

# The directory where your dotfiles repository is located.
DOTFILES_DIR="$HOME/dotfiles"

# Clone dotfiles repository
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/yousefhadder/dotfiles.git $HOME/dotfiles
fi

# Navigate to dotfiles directory
cd $DOTFILES_DIR || exit

# A backup directory for any existing dotfiles that are not symlinks.
BACKUP_DIR="$HOME/dotfiles_backup"
mkdir -p "$BACKUP_DIR"

# Ensure the target configuration directory exists.
mkdir -p "$HOME/.config"

# Declare an array of mappings in the format "relative_source:target_path"
declare -a FILES_TO_LINK=(
  "git/.gitconfig:$HOME/.gitconfig"
  "zsh/.zshrc:$HOME/.zshrc"
  "tmux/.tmux.conf:$HOME/.tmux.conf"
  "vim/.vimrc:$HOME/.vimrc"
  "starship.toml:$HOME/.config/starship.toml"
  "config/nvim:$HOME/.config/nvim"
)

echo "Linking dotfiles..."

for mapping in "${FILES_TO_LINK[@]}"; do
    # Split the mapping on the colon to get source and destination
    src="${mapping%%:*}"
    dest="${mapping#*:}"
    
    SOURCE="$DOTFILES_DIR/$src"
    TARGET="$dest"
    
    # Backup any existing target file if it's not already a symlink
    if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "Backing up existing $TARGET to $BACKUP_DIR"
        mv "$TARGET" "$BACKUP_DIR"
    fi

    # Remove existing symlink if it exists
    if [ -L "$TARGET" ]; then
        rm "$TARGET"
    fi

    # Create the symlink
    echo "Linking $SOURCE to $TARGET"
    ln -s "$SOURCE" "$TARGET"
done

echo "All dotfiles have been symlinked successfully."

echo "Dotfiles setup complete!"
