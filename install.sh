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

# Initialize logging
init_log_file

# Welcome banner
echo ""
echo -e "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${MAGENTA}║                                                            ║${NC}"
echo -e "${BOLD}${MAGENTA}║           🚀  DOTFILES INSTALLATION SYSTEM  🚀             ║${NC}"
echo -e "${BOLD}${MAGENTA}║                                                            ║${NC}"
echo -e "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

log "Starting dotfiles installation..."
log_info "OS: $OS | User: $(whoami) | Directory: $DOTFILES_DIR"
echo ""

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
install_packages
install_languages
copy_scripts
create_symlinks

# ==============================================================================
# PART 3: WAIT FOR BACKGROUND JOBS
# ==============================================================================

# Wait for all background installations to complete
wait_for_background_jobs

# ==============================================================================
# PART 4: FINALIZATION
# ==============================================================================

# Generate timing summary
generate_timing_summary

# Completion banner
echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║                                                            ║${NC}"
echo -e "${BOLD}${GREEN}║               ✨  INSTALLATION COMPLETE!  ✨              ║${NC}"
echo -e "${BOLD}${GREEN}║                                                            ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

log_success "Dotfiles setup is complete!"
log_info "Installation log saved to: $LOG_FILE"
echo ""

# Replace the current shell with a new zsh login shell.
# This is the crucial final step that makes all changes take effect.
# Only do this in interactive mode, not in CI/Docker environments
if [ -t 0 ]; then
  log_info "Reloading shell to apply all changes..."
  exec zsh -l
else
  log_info "Non-interactive mode detected. Installation complete!"
  log_info "Run 'zsh -l' manually to start using your new shell."
fi
