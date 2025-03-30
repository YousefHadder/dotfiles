#!/usr/bin/env zsh
set -euo pipefail

# Logging function
log() {
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] $*"
}

DOTFILES_DIR="${HOME}/dotfiles"
OS=$(uname)

# -------------------------------
# Install Homebrew if needed
# -------------------------------
if ! command -v brew &>/dev/null; then
  log "Homebrew not found. Installing Homebrew..."
  if [ "$OS" == "Linux" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ "$OS" == "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  eval "$($(brew --prefix)/bin/brew shellenv)"
else
  log "Homebrew is already installed."
fi

log "Updating Homebrew..."
brew update

# -------------------------------
# Install packages from Brewfile
# -------------------------------
if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
  log "Installing packages from Brewfile..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile"
fi

# -------------------------------
# Copy scripts to home directory
# -------------------------------
log "Copying scripts..."
cd "$DOTFILES_DIR"
cp -R scripts "${HOME}/scripts"

# -------------------------------
# Create symlinks for dotfiles using GNU Stow
# -------------------------------
if ! command -v stow &>/dev/null; then
  log "GNU Stow is not installed. Please install it (e.g., via Homebrew: 'brew install stow')."
  exit 1
fi

log "Creating symlinks for dotfiles using GNU Stow..."
cd "$DOTFILES_DIR" || {
  log "Failed to cd into ${DOTFILES_DIR}"
  exit 1
}

# Loop through all subdirectories (each representing a dotfiles package)
for package in */; do
  # Remove trailing slash from the package name
  package="${package%/}"

  read "answer?Stow package '$package'? (y/N): "
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    log "Stowing package: $package"
    stow -t "$HOME" "$package"
    if [ "$package" = "zsh" ]; then
      read "git_author_name?Enter your GIT_AUTHOR_NAME: "
      read "git_author_email?Enter your GIT_AUTHOR_EMAIL: "
      echo "export GIT_AUTHOR_NAME=\"$git_author_name\"" >>"${HOME}/.zshrc"
      echo "export GIT_AUTHOR_EMAIL=\"$git_author_email\"" >>"${HOME}/.zshrc"
    fi
  else
    log "Skipping package: $package"
  fi
done

# Source the updated .zshrc to load any new configurations
source "${HOME}/.zshrc"

log "All dotfiles packages have been stowed successfully."
