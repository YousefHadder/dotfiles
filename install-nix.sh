#!/usr/bin/env bash
set -euo pipefail

# Colors for logging
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
  echo -e "${CYAN}[$(date '+%Y-%m-%d %H:%M:%S')] $*${NC}"
}

success() {
  echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $*${NC}"
}

warn() {
  echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] $*${NC}"
}

error() {
  echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] $*${NC}"
}

# Detect OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)

log "Detected OS: $OS"
log "Detected Architecture: $ARCH"

# Get current username
USERNAME=$(whoami)

# Determine the correct home-manager configuration
if [ "$OS" = "Darwin" ]; then
  if [ "$ARCH" = "arm64" ]; then
    HM_CONFIG="${USERNAME}@darwin"
    log "Using macOS Apple Silicon configuration"
  else
    HM_CONFIG="${USERNAME}@darwin-x86"
    log "Using macOS Intel configuration"
  fi
elif [ "$OS" = "Linux" ]; then
  HM_CONFIG="${USERNAME}@linux"
  log "Using Linux configuration"
else
  error "Unsupported operating system: $OS"
  exit 1
fi

# Detect if running in GitHub Codespaces
if [ "${CODESPACES:-false}" = "true" ]; then
  DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"
  log "Codespace environment detected"
else
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  log "Standard environment detected"
fi

log "Dotfiles directory: $DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Install Nix if not present
if ! command -v nix &> /dev/null; then
  log "Nix not found. Installing Nix..."
  
  if [ "$OS" = "Darwin" ]; then
    # Use the official installer for macOS
    curl -L https://nixos.org/nix/install | sh
  else
    # Use the multi-user installation for Linux
    curl -L https://nixos.org/nix/install | sh -s -- --daemon
  fi
  
  # Source the Nix profile
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
  
  success "Nix installed successfully"
else
  log "Nix is already installed"
fi

# Enable experimental features (flakes and nix-command)
log "Configuring Nix with experimental features..."
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
auto-optimise-store = true
EOF

# Install home-manager if not present
if ! command -v home-manager &> /dev/null; then
  log "Installing home-manager..."
  nix run home-manager/master -- init --switch
else
  log "home-manager is already available"
fi

# Replace placeholder username with actual username in config files
log "Updating configuration files with username: $USERNAME"
sed -i.bak "s/builtins\.getEnv \"USER\"/\"$USERNAME\"/g" flake.nix
sed -i.bak "s/builtins\.getEnv \"USER\"/\"$USERNAME\"/g" home.nix
sed -i.bak "s/builtins\.getEnv \"HOME\"/\"$HOME\"/g" home.nix

# Apply the home-manager configuration
log "Applying home-manager configuration: $HM_CONFIG"
if nix run home-manager/master -- switch --flake ".#$HM_CONFIG"; then
  success "Home-manager configuration applied successfully"
  
  # Restore original files after successful application
  log "Restoring original configuration files"
  mv flake.nix.bak flake.nix 2>/dev/null || true
  mv home.nix.bak home.nix 2>/dev/null || true
else
  error "Failed to apply home-manager configuration"
  
  # Restore original files on failure
  log "Restoring original configuration files due to failure"
  mv flake.nix.bak flake.nix 2>/dev/null || true
  mv home.nix.bak home.nix 2>/dev/null || true
  
  warn "You may need to resolve conflicts manually"
  exit 1
fi

# Install oh-my-zsh if not present (home-manager doesn't install it, just configures it)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "oh-my-zsh installed"
else
  log "oh-my-zsh is already installed"
fi

# Change default shell to zsh if needed
if [ "$(basename "$SHELL")" != "zsh" ]; then
  log "Changing default shell to zsh..."
  if command -v zsh >/dev/null 2>&1; then
    ZSH_PATH=$(command -v zsh)
    if ! grep -q "$ZSH_PATH" /etc/shells; then
      echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    sudo chsh -s "$ZSH_PATH" "$USER"
    success "Default shell changed to zsh"
  else
    error "zsh not found in PATH"
    exit 1
  fi
else
  log "zsh is already the default shell"
fi

success ""
success "################################################################"
success "#                                                              #"
success "#  Nix-based dotfiles setup is complete!                      #"
success "#                                                              #"
success "#  To update your configuration in the future, run:           #"
success "#  home-manager switch --flake '.#$HM_CONFIG'"
success "#                                                              #"
success "#  Reloading shell to apply all changes...                    #"
success "#                                                              #"
success "################################################################"
success ""

# Start a new zsh session
exec zsh -l