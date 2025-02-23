#!/usr/bin/env bash
set -euo pipefail

# Define the directory containing your dotfiles
DOTFILES_DIR="${HOME}/dotfiles"

# Helper function for printing messages
log() {
  echo "==> $1"
}

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
# Install Homebrew if needed
# -------------------------------
if ! command -v brew &>/dev/null; then
  log "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>$HOME/.zshrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/vscode/.zshrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  log "Homebrew is already installed."
fi

# -------------------------------
# Install other needed software
# -------------------------------
# Example: Installing packages via Homebrew
if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
  log "Installing packages from Brewfile..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile"
fi

# You can also add more installation commands here for other software
# For example, using apt-get, npm, pip, etc.

# -------------------------------
# Create symlinks for dotfiles
# -------------------------------
log "Creating symlinks for dotfiles..."

stow .

# -------------------------------
# Create scripts
# -------------------------------
cp -R custom_modules/ ~/
