#!/usr/bin/env bash
# GNU Stow symlink creation

# Standalone script setup
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
  source "${SCRIPT_DIR}/utils.sh"
  detect_os
  export DOTFILES_DIR

  # Parse arguments
  PACKAGES=("$@")
  if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: $0 [PACKAGES...]"
    echo "Stow dotfiles packages. If no packages specified, stow all non-stowed packages."
    exit 0
  fi
fi

create_symlinks() {
  log "--- Starting Symlink Creation ---"

  if ! command -v stow &>/dev/null; then
    log "GNU Stow is not installed. Installing with Homebrew..."
    brew install stow
  fi

  cd "$DOTFILES_DIR" || exit 1

  # Determine packages to process
  if [[ ${#PACKAGES[@]} -gt 0 ]]; then
    packages_to_process=("${PACKAGES[@]}")
  else
    packages_to_process=()
    for package in */; do
      package="${package%/}"
      [[ $package == install ]] && continue
      [[ ${CODESPACES:-false} == true ]] && [[ $package =~ ^(git|ghostty|claude)$ ]] && continue
      packages_to_process+=("$package")
    done
  fi

  # Process packages
  for package in "${packages_to_process[@]}"; do
    [[ ! -d "$package" ]] && {
      log "Package '$package' not found, skipping..."
      continue
    }

    # Skip if already stowed (stow -n shows what would be done)
    if [[ ${#PACKAGES[@]} -eq 0 ]] && stow -n -t "$HOME" "$package" &>/dev/null; then
      log "Package '$package' already stowed, skipping..."
      continue
    fi

    log "Stowing package: $package"
    [[ $package == zsh && -f ~/.zshrc ]] && rm -f ~/.zshrc
    stow -R -t "$HOME" "$package"
  done

  log "--- Symlink Creation Complete ---"
}

# Run if standalone
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && create_symlinks
