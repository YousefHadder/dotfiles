#!/usr/bin/env bash
# Package installation from Brewfile

install_packages() {
  log_section "PHASE: Package Installation"

  # -------------------------------
  # Install Essential Packages First (Blocking)
  # -------------------------------
  if [ -f "${DOTFILES_DIR}/Brewfile.essential" ]; then
    log "Installing essential packages (priority, blocking)..."
    local essential_start
    essential_start=$(start_operation "Essential packages")
    brew bundle --file="${DOTFILES_DIR}/Brewfile.essential"
    log_with_timing "Essential packages" "$essential_start"
  else
    log "⚠️  No Brewfile.essential found. Falling back to single Brewfile."
  fi

  # -------------------------------
  # Install Optional Packages in Background (Non-blocking)
  # -------------------------------
  if [ -f "${DOTFILES_DIR}/Brewfile.optional" ]; then
    log "Installing optional packages in background..."
    local optional_start
    optional_start=$(start_operation "Optional packages (background)")

    # Run optional package installation in background
    (
      brew bundle --file="${DOTFILES_DIR}/Brewfile.optional" 2>&1 | while IFS= read -r line; do
        echo "[OPTIONAL] $line" >> "$LOG_FILE"
      done
      local optional_end=$(date +%s)
      local optional_duration=$((optional_end - optional_start))
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Optional packages (background) (${optional_duration}s)" >> "$LOG_FILE"
    ) &

    # Store the background job PID
    OPTIONAL_PACKAGES_PID=$!
    log "Optional packages installing in background (PID: $OPTIONAL_PACKAGES_PID)"

    # Track this background job
    track_background_job "$OPTIONAL_PACKAGES_PID" "Optional packages"
  else
    log "No Brewfile.optional found. Skipping optional packages."
  fi

  # -------------------------------
  # Fallback: Single Brewfile (for backward compatibility)
  # -------------------------------
  if [ ! -f "${DOTFILES_DIR}/Brewfile.essential" ] && [ -f "${DOTFILES_DIR}/Brewfile" ]; then
    log "Installing packages from single Brewfile..."
    local single_start
    single_start=$(start_operation "Package installation")
    brew bundle --file="${DOTFILES_DIR}/Brewfile"
    log_with_timing "Package installation" "$single_start"
  fi

  log "--- Package Installation Complete (background jobs may still be running) ---"
}