#!/usr/bin/env bash
set -euo pipefail

# Define a log function for consistent logging
log() {
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] $*"
}

# Define the directory containing your dotfiles
DOTFILES_DIR="${HOME}/dotfiles"

#-------------------------------
# Switch default shell to zsh
# -------------------------------
log "Changing default shell to zsh..."
if ! command -v zsh &>/dev/null; then
  log "zsh is not installed. Please install it first."
  exit 1
fi

# -------------------------------
# Install oh-my-zsh if needed
# -------------------------------
if ! -d "${HOME}/.oh-my-zsh"; then
  log "Installing oh-my-zsh..."
  # The installation script will switch your shell; adjust options if needed.
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  sudo chsh -s "$(which zsh)" "$USER"
fi

# -------------------------------
# Install Homebrew if needed
# -------------------------------
if ! command -v brew &>/dev/null; then
  log "Homebrew not found. Installing Homebrew..."

  if [ "$(uname)" = "Linux" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ "$(uname)" = "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
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
    echo "Stowing package: $package"
    stow -t "$HOME" "$package"
    if [ "$package" = "zsh" ]; then
      read -p "Enter your GIT_AUTHOR_NAME: " git_author_name
      read -p "Enter your GIT_AUTHOR_EMAIL: " git_author_email
      echo "export GIT_AUTHOR_NAME=\"$git_author_name\"" >>~/.zshrc
      echo "export GIT_AUTHOR_EMAIL=\"$git_author_email\"" >>~/.zshrc
    fi
  else
    echo "Skipping package: $package" n
  fi
done

source ~/.zshrc

log "All dotfiles packages have been stowed successfully."
