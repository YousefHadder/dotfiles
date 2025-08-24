#!/usr/bin/env bash
# Package installation from Brewfile

install_packages() {
  log "--- Starting Package Installation ---"

  # -------------------------------
  # Install packages from Brewfile
  # -------------------------------
  if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
    log "Installing packages from Brewfile..."
    brew bundle --file="${DOTFILES_DIR}/Brewfile"
  else
    log "No Brewfile found at ${DOTFILES_DIR}/Brewfile. Skipping package installation."
  fi

  log "--- Package Installation Complete ---"
}