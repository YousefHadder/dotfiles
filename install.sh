#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# CONSOLIDATED DOTFILES INSTALLER
#
# This script combines the 'bootstrap' and 'install.sh' scripts into a single
# file suitable for automated execution in environments like GitHub Codespaces.
#
# It performs the following steps:
# 1.  (Bootstrap) Updates the system and installs zsh and Oh My Zsh.
# 2.  (Bootstrap) Changes the default shell to zsh without exiting.
# 3.  (Install) Installs Homebrew non-interactively and packages from the Brewfile.
# 4.  (Install) Copies script files.
# 5.  (Install) Uses GNU Stow to symlink all dotfile packages non-interactively,
#     skipping specified packages ('git', 'ghostty').
# 6.  Replaces the current shell process with a new zsh login shell to apply
#     all changes immediately.
# ==============================================================================

# --- Logging Function with Color ---
CYAN='\033[0;36m'
NC='\033[0m' # No Color
log() {
  # -e flag enables interpretation of backslash escapes (for colors)
  echo -e "${CYAN}[ $(date '+%Y-%m-%d %H:%M:%S') ] $*${NC}"
}

# --- Initial Setup ---
OS=$(uname)
log "Detected OS: $OS"

# Detect if running in a GitHub Codespace and set dotfiles directory accordingly
if [ "${CODESPACES:-false}" = "true" ]; then
  DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"
  log "Codespace environment detected."
else
  DOTFILES_DIR="${HOME}/dotfiles"
  log "Standard environment detected."
fi
log "Dotfiles directory set to: ${DOTFILES_DIR}"

# ==============================================================================
# PART 1: BOOTSTRAP LOGIC (from bootstrap script)
# ==============================================================================

log "--- Starting Bootstrap Phase ---"

# -------------------------------
# Update system based on OS
# -------------------------------
if [ "$OS" == "Darwin" ]; then
  log "Running macOS specific commands..."
  log "Updating macOS..."
  sudo softwareupdate -i -a

  log "Checking for Xcode Command Line Tools..."
  # This will prompt for installation if not already installed.
  # In a non-interactive environment, this might need pre-configuration.
  # For GitHub Codespaces, these tools are usually available.
  xcode-select --install >/dev/null 2>&1 || log "Xcode Command Line Tools already installed."
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
# Install zsh using the OS package manager
# -------------------------------
if ! command -v zsh &>/dev/null; then
  log "zsh is not installed. Installing zsh..."
  if [ "$OS" == "Linux" ]; then
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get install -y zsh
    elif command -v yum >/dev/null 2>&1; then
      sudo yum install -y zsh
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y zsh
    else
      log "ERROR: No supported package manager found for installing zsh on Linux."
      exit 1
    fi
  elif [ "$OS" == "Darwin" ]; then
    log "ERROR: zsh should be pre-installed on modern macOS. Please install it manually if not found."
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
else
  log "Oh My Zsh is already installed."
fi

# -------------------------------
# Change the default shell to zsh if necessary
# -------------------------------
if [ "$(basename "$SHELL")" != "zsh" ]; then
  log "zsh is not the default shell. Changing the default shell to zsh..."
  if command -v zsh >/dev/null 2>&1; then
    sudo chsh -s "$(command -v zsh)" "$USER"
    log "Default shell has been changed to zsh. The script will continue."
  else
    log "ERROR: zsh command not found, cannot change shell."
    exit 1
  fi
fi

log "--- Bootstrap Phase Complete ---"

# ==============================================================================
# PART 2: INSTALLATION LOGIC (from install.sh script)
# ==============================================================================

log "--- Starting Installation Phase ---"

# -------------------------------
# Install Homebrew if needed
# -------------------------------
if ! command -v brew &>/dev/null; then
  log "Homebrew not found. Installing Homebrew non-interactively..."
  NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to the current shell session's PATH
  if [ "$OS" = "Linux" ]; then
    log "Adding Linuxbrew to PATH for this session..."
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ "$OS" = "Darwin" ]; then
    log "Adding Homebrew to PATH for this session..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  log "Homebrew is already installed."
fi

log "Updating Homebrew and checking status..."
brew update

# -------------------------------
# Install packages from Brewfile
# -------------------------------
if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
  log "Installing packages from Brewfile..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile"
else
  log "No Brewfile found at ${DOTFILES_DIR}/Brewfile. Skipping package installation."
fi

# -------------------------------
# Copy scripts to home directory
# -------------------------------
if [ -d "${DOTFILES_DIR}/scripts" ]; then
  log "Copying scripts directory to ${HOME}..."
  cp -R "${DOTFILES_DIR}/scripts" "${HOME}/scripts"
else
  log "No scripts directory found. Skipping copy."
fi

# -------------------------------
# Create symlinks for dotfiles using GNU Stow
# -------------------------------
if ! command -v stow &>/dev/null; then
  log "GNU Stow is not installed. Installing with Homebrew..."
  brew install stow
fi

log "Creating symlinks for packages using GNU Stow..."
cd "$DOTFILES_DIR" || {
  log "ERROR: Failed to cd into ${DOTFILES_DIR}"
  exit 1
}

# Non-interactive loop for automated environments
for package in */; do
  package="${package%/}"

  # Skip specified packages
  if [[ "$package" == "git" || "$package" == "ghostty" ]]; then
    log "Skipping package: $package"
    continue
  fi

  log "Stowing package: $package"
  # If a .zshrc from oh-my-zsh exists, remove it before stowing our own.
  if [ "$package" = "zsh" ] && [ -f "${HOME}/.zshrc" ]; then
    log "Removing existing .zshrc to be replaced by stowed version."
    rm -f "${HOME}/.zshrc"
  fi
  stow -R -t "$HOME" "$package"
done

log "All dotfiles packages have been stowed successfully."
log "--- Installation Phase Complete ---"

# ==============================================================================
# PART 3: FINALIZATION
# ==============================================================================
log ""
log "################################################################"
log "#                                                              #"
log "#  Dotfiles setup is complete.                                 #"
log "#  Reloading shell to apply all changes...                     #"
log "#                                                              #"
log "################################################################"
log ""

# Replace the current shell with a new zsh login shell.
# This is the crucial final step that makes all changes take effect.
exec zsh -l
