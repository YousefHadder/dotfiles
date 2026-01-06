#!/usr/bin/env bash
# Language and development tools installation

install_languages() {
  log "--- Starting Language Tools Installation ---"

  # -------------------------------
  # Install Rust & Cargo in Background
  # -------------------------------
  if ! command -v cargo >/dev/null 2>&1; then
    log "Installing Rust & Cargo in background..."

    (
      # Calculate start time inside the subshell
      local rust_start=$(date +%s)
      local timestamp
      timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

      # Source utils.sh to get access to _log_append function in subshell
      source "${DOTFILES_DIR}/install/utils.sh"

      # Try to install Rust, but don't fail if it doesn't work
      if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>&1 | while IFS= read -r line; do
        _log_append "[RUST] $line"
      done; then
        local rust_end=$(date +%s)
        local rust_duration=$((rust_end - rust_start))
        timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
        _log_append "[${timestamp}] ✅ Rust installation (background) (${rust_duration}s)"
        exit 0
      else
        local exit_code=$?
        local rust_end=$(date +%s)
        local rust_duration=$((rust_end - rust_start))
        timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
        _log_append "[${timestamp}] ⚠️ Rust installation failed (${rust_duration}s, exit: $exit_code)"
        # Exit with 0 to prevent marking the entire job as failed
        exit 0
      fi
    ) &

    RUST_PID=$!
    log "Rust installing in background (PID: $RUST_PID)"
    track_background_job "$RUST_PID" "Rust installation"
  else
    log "Rust & Cargo already installed: $(cargo --version)"
  fi

  # -------------------------------
  # Install GitHub Copilot CLI in Background
  # -------------------------------
  if ! command -v copilot >/dev/null 2>&1; then
    if command -v npm >/dev/null 2>&1; then
      log "Installing GitHub Copilot CLI in background..."

      (
        # Calculate start time inside the subshell
        local copilot_start=$(date +%s)
        local timestamp
        timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

        # Source utils.sh to get access to _log_append function in subshell
        source "${DOTFILES_DIR}/install/utils.sh"

        # Try to install Copilot CLI, but don't fail if it doesn't work
        if npm install -g @github/copilot 2>&1 | while IFS= read -r line; do
          _log_append "[COPILOT] $line"
        done; then
          local copilot_end=$(date +%s)
          local copilot_duration=$((copilot_end - copilot_start))
          timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
          _log_append "[${timestamp}] ✅ Copilot CLI (background) (${copilot_duration}s)"
          exit 0
        else
          local exit_code=$?
          local copilot_end=$(date +%s)
          local copilot_duration=$((copilot_end - copilot_start))
          timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
          _log_append "[${timestamp}] ⚠️ Copilot CLI installation failed (${copilot_duration}s, exit: $exit_code)"
          # Exit with 0 to prevent marking the entire job as failed
          exit 0
        fi
      ) &

      COPILOT_PID=$!
      log "GitHub Copilot CLI installing in background (PID: $COPILOT_PID)"
      track_background_job "$COPILOT_PID" "Copilot CLI"
    else
      log "Skipping GitHub Copilot CLI installation (npm not available)"
    fi
  else
    log "GitHub Copilot CLI already installed"
  fi

  log "--- Language Tools Installation Initiated (running in background) ---"
}
