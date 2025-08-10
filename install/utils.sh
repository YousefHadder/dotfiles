#!/usr/bin/env bash
# Shared utility functions for dotfiles installation

# --- Logging Function with Color ---
CYAN='\033[0;36m'
NC='\033[0m' # No Color
log() {
  # -e flag enables interpretation of backslash escapes (for colors)
  echo -e "${CYAN}[ $(date '+%Y-%m-%d %H:%M:%S') ] $*${NC}"
}

# --- OS Detection ---
detect_os() {
  export OS=$(uname)
  log "Detected OS: $OS"
}

# --- Directory Setup ---
setup_dotfiles_dir() {
  # Detect if running in a GitHub Codespace and set dotfiles directory accordingly
  if [ "${CODESPACES:-false}" = "true" ]; then
    export DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"
    log "Codespace environment detected."
  else
    export DOTFILES_DIR="${HOME}/dotfiles"
    log "Standard environment detected."
  fi
  log "Dotfiles directory set to: ${DOTFILES_DIR}"
}