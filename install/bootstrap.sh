#!/usr/bin/env bash
# Bootstrap system with zsh and Oh My Zsh

bootstrap_system() {
  log "--- Starting Bootstrap Phase ---"

  # -------------------------------
  # Install zsh using the OS package manager
  # -------------------------------
  if ! command -v zsh &>/dev/null; then
    log "zsh is not installed. Installing zsh..."
    if [ "$OS" == "Linux" ]; then
      if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get install -y zsh
      elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y zsh
      elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y zsh
      else
        log "ERROR: No supported package manager found for installing zsh on Linux."
        exit 1
      fi
    elif [ "$OS" == "Darwin" ]; then
      log "ERROR: zsh should be pre-installed on modern macOS. Please install it manually if not found."
      exit 1
    fi
  else
    log "zsh is already installed."
  fi

  # -------------------------------
  # Install oh‑my‑zsh if not installed
  # -------------------------------
  if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    log "Installing oh‑my‑zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    log "Oh My Zsh is already installed."
  fi

  # -------------------------------
  # Change the default shell to zsh if necessary
  # -------------------------------
  if [ "$(basename "$SHELL")" != "zsh" ]; then
    log "zsh is not the default shell. Changing the default shell to zsh..."
    if command -v zsh >/dev/null 2>&1; then
      # Add zsh to /etc/shells if not already present
      if ! grep -q "$(command -v zsh)" /etc/shells; then
        echo "$(command -v zsh)" | sudo tee -a /etc/shells >/dev/null
      fi
      sudo chsh -s "$(command -v zsh)" "$USER"
      log "Default shell has been changed to zsh. The script will continue."
    else
      log "ERROR: zsh command not found, cannot change shell."
      exit 1
    fi
  fi

  log "--- Bootstrap Phase Complete ---"
}
