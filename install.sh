#!/usr/bin/env bash
set -euo pipefail

# Set environment variables for non-interactive operation
export DEBIAN_FRONTEND=noninteractive
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ANALYTICS=1

# ==============================================================================
# MODULAR DOTFILES INSTALLER
#
# This script orchestrates the installation of dotfiles using modular components.
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

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${SCRIPT_DIR}/install"

# Source utility functions
source "${INSTALL_DIR}/utils.sh"

# Initialize environment
detect_os
setup_dotfiles_dir

# Source all installation modules
source "${INSTALL_DIR}/bootstrap.sh"
source "${INSTALL_DIR}/homebrew.sh"
source "${INSTALL_DIR}/languages.sh"
source "${INSTALL_DIR}/packages.sh"
source "${INSTALL_DIR}/scripts.sh"
source "${INSTALL_DIR}/symlinks.sh"

# ==============================================================================
# RUN INSTALLATION MODULES
# ==============================================================================

# Execute installation steps in order
bootstrap_system
install_homebrew
install_languages
install_packages
copy_scripts
create_symlinks

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
