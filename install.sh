#!/usr/bin/env bash
set -euo pipefail

# Define the directory containing your dotfiles
DOTFILES_DIR="${HOME}/dotfiles"

# -------------------------------
# Install oh-my-zsh if needed
# -------------------------------
if [ -d "${HOME}/.oh-my-zsh" ]; then
  echo "oh-my-zsh already exists. Removing existing installation..."
  rm -rf "${HOME}/.oh-my-zsh"
fi

echo "Installing oh-my-zsh..."
# The installation script will switch your shell; adjust options if needed.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# -------------------------------
# Install Homebrew if needed
# -------------------------------
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>"$HOME/.zshrc"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>$HOME/.zshrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Switch the default shell to zsh
echo "Changing default shell to zsh..."
sudo chsh -s "$(which zsh)" "$USER"

# -------------------------------
# Install other needed software
# -------------------------------
# Example: Installing packages via Homebrew
if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
  echo "Installing packages from Brewfile..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile"
fi

# You can also add more installation commands here for other software
# For example, using apt-get, npm, pip, etc.

# -------------------------------
# Copy scripts
# -------------------------------

cd $DOTFILES_DIR
cp -R scripts ~

# -------------------------------
# Create symlinks for dotfiles using GNU Stow
# -------------------------------

# Check if GNU Stow is installed
if ! command -v stow &>/dev/null; then
  echo "GNU Stow is not installed. Please install it (e.g., via Homebrew: 'brew install stow')."
  exit 1
fi

echo "Creating symlinks for dotfiles using GNU Stow..."

# Change to your dotfiles directory
cd "${DOTFILES_DIR}" || {
  echo "Failed to cd into ${DOTFILES_DIR}"
  exit 1
}

# Loop through all subdirectories (each representing a dotfiles package)
for package in */; do
  # Remove the trailing slash from the package name
  package="${package%/}"
  echo "Stowing package: ${package}"
  # -t ${HOME} tells stow to create symlinks in the home directory
  stow -t "${HOME}" "${package}"
done

echo "All dotfiles packages have been stowed successfully."
