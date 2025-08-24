#!/usr/bin/env bash
# Scripts copying functionality

copy_scripts() {
  log "--- Starting Scripts Copy ---"

  # -------------------------------
  # Copy scripts to home directory
  # -------------------------------
  if [ -d "${DOTFILES_DIR}/scripts" ]; then
    log "Copying scripts directory to ${HOME}..."
    cp -R "${DOTFILES_DIR}/scripts" "${HOME}/scripts"
  else
    log "No scripts directory found. Skipping copy."
  fi

  log "--- Scripts Copy Complete ---"
}