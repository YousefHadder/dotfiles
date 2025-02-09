#!/bin/zsh
set -e

# The directory where your dotfiles repository is located.
DOTFILES_DIR="$HOME/dotfiles"

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

