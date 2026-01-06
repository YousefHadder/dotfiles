#!/usr/bin/env bash
# Homebrew installation and setup

install_homebrew() {
  log_section "PHASE: Homebrew Installation"
  local start_time
  start_time=$(start_operation "Homebrew installation")

  # -------------------------------
  # Install Homebrew if needed
  # -------------------------------
  if ! command -v brew &>/dev/null; then
    log "Homebrew not found. Installing Homebrew non-interactively..."
    NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to the current shell session's PATH
    if [ "$OS" = "Linux" ]; then
      log "Adding Linuxbrew to PATH for this session..."
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ "$OS" = "Darwin" ]; then
      log "Adding Homebrew to PATH for this session..."
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    log "Homebrew is already installed."
  fi

  log "Updating Homebrew and checking status..."
  brew update

  log_with_timing "Homebrew installation" "$start_time"
}