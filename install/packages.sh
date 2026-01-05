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

    # Try to install essential packages, but don't fail completely if some packages fail
    if brew bundle --file="${DOTFILES_DIR}/Brewfile.essential" 2>&1 | tee -a "$LOG_FILE"; then
      log_with_timing "Essential packages" "$essential_start"
    else
      local exit_code=$?
      log_warning "Some essential packages failed to install (exit code: $exit_code)"
      log_warning "Continuing installation - check log for details"
      log_with_timing "Essential packages (with errors)" "$essential_start"
    fi
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
    # Use || true to prevent the background job from failing the entire installation
    (
      # Install packages, allowing failures
      if brew bundle --file="${DOTFILES_DIR}/Brewfile.optional" 2>&1 | while IFS= read -r line; do
        echo "[OPTIONAL] $line" >> "$LOG_FILE"
      done; then
        local optional_end=$(date +%s)
        local optional_duration=$((optional_end - optional_start))
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Optional packages (background) (${optional_duration}s)" >> "$LOG_FILE"
        exit 0
      else
        local exit_code=$?
        local optional_end=$(date +%s)
        local optional_duration=$((optional_end - optional_start))
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️  Optional packages completed with some failures (${optional_duration}s, exit: $exit_code)" >> "$LOG_FILE"
        # Exit with 0 to prevent marking the entire job as failed
        exit 0
      fi
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

    if brew bundle --file="${DOTFILES_DIR}/Brewfile" 2>&1 | tee -a "$LOG_FILE"; then
      log_with_timing "Package installation" "$single_start"
    else
      log_warning "Some packages failed to install - continuing anyway"
      log_with_timing "Package installation (with errors)" "$single_start"
    fi
  fi

  log "--- Package Installation Complete (background jobs may still be running) ---"
}