#!/usr/bin/env bash
# Language and development tools installation

install_languages() {
  log "--- Starting Language Tools Installation ---"

  # -------------------------------
  # Install Rust & Cargo in Background
  # -------------------------------
  if ! command -v cargo >/dev/null 2>&1; then
    log "Installing Rust & Cargo in background..."
    local rust_start
    rust_start=$(start_operation "Rust installation (background)")

    (
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>&1 | while IFS= read -r line; do
        echo "[RUST] $line" >> "$LOG_FILE"
      done
      local rust_end=$(date +%s)
      local rust_duration=$((rust_end - rust_start))
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Rust installation (background) (${rust_duration}s)" >> "$LOG_FILE"
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
      local copilot_start
      copilot_start=$(start_operation "Copilot CLI (background)")

      (
        npm install -g @github/copilot 2>&1 | while IFS= read -r line; do
          echo "[COPILOT] $line" >> "$LOG_FILE"
        done
        local copilot_end=$(date +%s)
        local copilot_duration=$((copilot_end - copilot_start))
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Copilot CLI (background) (${copilot_duration}s)" >> "$LOG_FILE"
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
