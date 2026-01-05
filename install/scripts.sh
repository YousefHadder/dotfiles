#!/usr/bin/env bash
# Scripts copying functionality

copy_scripts() {
  log_section "PHASE: Scripts Copy"
  local start_time
  start_time=$(start_operation "Scripts copy")

  # -------------------------------
  # Copy scripts to home directory
  # -------------------------------
  if [ -d "${DOTFILES_DIR}/scripts" ]; then
    log "Copying scripts directory to ${HOME}..."
    cp -R "${DOTFILES_DIR}/scripts" "${HOME}/scripts"
    chmod +x "${HOME}/scripts"/*.sh 2>/dev/null || true
  else
    log "No scripts directory found. Skipping copy."
  fi

  log_with_timing "Scripts copy" "$start_time"
  
}