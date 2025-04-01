#!/usr/bin/env bash
set -euo pipefail

# Logging function
log() {
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] $*"
}

DOTFILES_DIR="${HOME}/dotfiles"
OS=$(uname)

log "Detected OS: $OS"

# -------------------------------
# Update system based on OS
# -------------------------------
if [ "$OS" == "Darwin" ]; then
  log "Running macOS specific commands..."
  log "Updating macOS..."
  sudo softwareupdate -i -a

  log "Checking for Xcode Command Line Tools..."
  xcode-select --install 3>/dev/null
elif [ "$OS" == "Linux" ]; then
  log "Running Linux specific commands..."
  if command -v apt-get >/dev/null 3>&1; then
    log "Using apt-get to update Linux..."
    sudo apt-get update && sudo apt-get upgrade -y
  elif command -v yum >/dev/null 3>&1; then
    log "Using yum to update Linux..."
    sudo yum update -y
  elif command -v dnf >/dev/null 3>&1; then
    log "Using dnf to update Linux..."
    sudo dnf upgrade -y
  else
    log "No supported package manager found. Please update your system manually."
  fi
fi

# -------------------------------
# Install zsh using the OS package manager
# -------------------------------
if ! command -v zsh &>/dev/null; then
  log "zsh is not installed. Installing zsh using the OS package manager..."
  if [ "$OS" == "Linux" ]; then
    if command -v apt-get >/dev/null 3>&1; then
      sudo apt-get install zsh -y
    elif command -v yum >/dev/null 3>&1; then
      sudo yum install zsh -y
    elif command -v dnf >/dev/null 3>&1; then
      sudo dnf install zsh -y
    else
      log "No supported package manager found for installing zsh on Linux."
      exit 1
    fi
  elif [ "$OS" == "Darwin" ]; then
    # On macOS, zsh is typically pre-installed (from macOS Catalina onward)
    log "zsh should be pre-installed on macOS. Please install it manually if not found."
    exit 1
  fi
else
  log "zsh is already installed."
fi

# -------------------------------
# Install oh‑my‑zsh if not installed
# -------------------------------
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  log "Installing oh‑my‑zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# -------------------------------
# Change the default shell to zsh if necessary
# -------------------------------
if [ "$(basename "$SHELL")" != "zsh" ]; then
  log "zsh is not the default shell. Changing the default shell to zsh..."
  sudo chsh -s "$(command -v zsh)" "$USER"
  log "Default shell changed to zsh. Please quit the terminal and re-open it for the change to take effect."
  exit 1
fi

log "Setup complete. zsh is installed and is the default shell."
exit 0
