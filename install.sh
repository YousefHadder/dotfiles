#!/usr/bin/env bash
set -euo pipefail

# Define a log function for consistent logging
log() {
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] $*"
}

# Define the directory containing your dotfiles
DOTFILES_DIR="${HOME}/dotfiles"

# -------------------------------
# Install oh-my-zsh if needed
# -------------------------------
if [ -d "${HOME}/.oh-my-zsh" ]; then
  log "oh-my-zsh already exists. Removing existing installation..."
  rm -rf "${HOME}/.oh-my-zsh"
fi

log "Installing oh-my-zsh..."
# The installation script will switch your shell; adjust options if needed.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# -------------------------------
# Switch default shell to zsh
# -------------------------------
log "Changing default shell to zsh..."
sudo chsh -s "$(which zsh)" "$USER"

# -------------------------------
# Install Homebrew if needed
# -------------------------------
if ! command -v brew &>/dev/null; then
  log "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  rm ~/.zshrc

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  log "Homebrew is already installed."
fi

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
cp -R scripts ~/

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
  log "Stowing package: ${package}"
  stow -t "${HOME}" "${package}"
done

source ~/.zshrc

log "All dotfiles packages have been stowed successfully."
