#!/usr/bin/env bash
set -euo pipefail

# Logging function using echo to prevent recursion
log() {
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] $*"
}

# Define the directory containing your dotfiles
DOTFILES_DIR="${HOME}/dotfiles"
OS=$(uname)

log "Detected OS: $OS"

# Update system based on OS
if [ "$OS" == "Darwin" ]; then
  log "Running macOS specific commands..."
  log "Updating macOS..."
  sudo softwareupdate -i -a

  log "Checking for Xcode Command Line Tools..."
  xcode-select --install 2>/dev/null
elif [ "$OS" == "Linux" ]; then
  log "Running Linux specific commands..."
  if command -v apt-get >/dev/null 2>&1; then
    log "Using apt-get to update Linux..."
    sudo apt-get update && sudo apt-get upgrade -y
  elif command -v yum >/dev/null 2>&1; then
    log "Using yum to update Linux..."
    sudo yum update -y
  elif command -v dnf >/dev/null 2>&1; then
    log "Using dnf to update Linux..."
    sudo dnf upgrade -y
  else
    log "No supported package manager found. Please update your system manually."
  fi
fi

# -------------------------------
# Install Homebrew if needed
# -------------------------------
if ! command -v brew &>/dev/null; then
  log "Homebrew not found. Installing Homebrew..."
  if [ "$OS" == "Linux" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/HEAD/install.sh)"
  elif [ "$OS" == "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$($(brew --prefix)/bin/brew shellenv)"
else
  log "Homebrew is already installed."
fi

log "Updating Homebrew..."
brew update

if ! command -v zsh &>/dev/null; then
  log "zsh is not installed. Installing zsh..."
  brew install zsh
fi

if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  log "Installing oh‑my‑zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ "$(basename "$SHELL")" != "zsh" ]; then
  log "zsh is not the default shell. Changing the default shell to zsh..."
  sudo chsh -s "$(which zsh)" "$USER"
  # After changing the default shell, re-run the script with zsh.
  exec zsh "$0" "$@"
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
cp -R scripts ~/scripts

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

  # Ask the user whether to stow this package
  read -p "Stow package '$package'? (y/N): " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    log "Stowing package: $package"
    stow -t "$HOME" "$package"
    if [ "$package" = "zsh" ]; then
      read -p "Enter your GIT_AUTHOR_NAME: " git_author_name
      read -p "Enter your GIT_AUTHOR_EMAIL: " git_author_email
      echo "export GIT_AUTHOR_NAME=\"$git_author_name\"" >>~/.zshrc
      echo "export GIT_AUTHOR_EMAIL=\"$git_author_email\"" >>~/.zshrc
    fi
  else
    log "Skipping package: $package"
  fi
done

# Source the updated .zshrc
source ~/.zshrc

log "All dotfiles packages have been stowed successfully."
