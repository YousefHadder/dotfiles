#!/usr/bin/env bash
# lib/deps/brew.sh - Homebrew dependency installation (macOS)
#
# Requires: lib/common.sh must be sourced first (provides info, success, warn, error, command_exists)

# Install dependencies using Homebrew
install_with_brew() {
    # Install jq if missing
    if ! command_exists jq; then
        info "Installing jq with Homebrew..."
        brew install jq
    fi

    # Install pipx if missing
    if ! command_exists pipx; then
        info "Installing pipx with Homebrew..."
        brew install pipx
        pipx ensurepath
        export PATH="$HOME/.local/bin:$PATH"
    fi

    # Install litellm with pipx
    if ! command_exists litellm; then
        info "Installing litellm with pipx..."
        if ! pipx install 'litellm[proxy]'; then
            warn "pipx install failed, trying pip fallback..."
            return 1  # Signal to try pip fallback
        fi

        # Install prisma in litellm venv for auth handling
        if [[ -d "$HOME/.local/pipx/venvs/litellm" ]]; then
            info "Installing prisma..."
            "$HOME/.local/pipx/venvs/litellm/bin/python3" -m pip install prisma 2>/dev/null || true
        fi
    fi

    return 0
}
