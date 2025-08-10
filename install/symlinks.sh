#!/usr/bin/env bash
# GNU Stow symlink creation

create_symlinks() {
  log "--- Starting Symlink Creation ---"

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
    if [[ "$package" == "git" || "$package" == "ghostty" || "$package" == "install" ]]; then
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
  log "--- Symlink Creation Complete ---"
}