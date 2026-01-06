#!/usr/bin/env bash
# GNU Stow symlink creation

stow_packages() {
  local packages=("$@")

  # Ensure stow is installed
  if ! command -v stow &>/dev/null; then
    log "GNU Stow is not installed. Installing with Homebrew..."
    brew install stow
  fi

  cd "$DOTFILES_DIR" || {
    log "ERROR: Failed to cd into ${DOTFILES_DIR}"
    exit 1
  }

  # If no packages specified, stow all packages
  if [ ${#packages[@]} -eq 0 ]; then
    log "Creating symlinks for all packages using GNU Stow..."
    for package in */; do
      package="${package%/}"

      # Skip specified packages
      if [[ "$package" == "git" || "$package" == "ghostty" || "$package" == "install" ]]; then
        log "Skipping package: $package"
        continue
      fi

      packages+=("$package")
    done
  fi

  # Stow specified packages
  for package in "${packages[@]}"; do
    if [ ! -d "$package" ]; then
      log "WARNING: Package directory '$package' does not exist. Skipping."
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

  log "Stow operation complete."
}

create_symlinks() {
  log_section "PHASE: Symlink Creation"
  local start_time
  start_time=$(start_operation "Symlink creation")

  stow_packages

  log_with_timing "Symlink creation" "$start_time"
}

# Allow running this script directly for manual stowing
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # Script is being run directly
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

  # Source utils for log function
  source "${SCRIPT_DIR}/utils.sh"

  if [ $# -eq 0 ]; then
    echo "Usage: $0 <package1> [package2] [...]"
    echo ""
    echo "Available packages:"
    cd "$DOTFILES_DIR"
    for dir in */; do
      dir="${dir%/}"
      if [[ "$dir" != "install" && "$dir" != ".git" ]]; then
        echo "  - $dir"
      fi
    done
    exit 1
  fi

  log "--- Manual Stow Operation ---"
  stow_packages "$@"
fi
