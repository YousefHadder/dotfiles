#!/usr/bin/env bash
# Language and development tools installation

install_languages() {
  log "--- Starting Language Tools Installation ---"

  # -------------------------------
  # Install Rust & Cargo
  # -------------------------------
  if ! command -v cargo >/dev/null 2>&1; then
    log "Installing Rust & Cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Load cargo into PATH for this session
    source "$HOME/.cargo/env"
  else
    log "Rust & Cargo already installed: $(cargo --version)"
  fi

  log "--- Language Tools Installation Complete ---"
}