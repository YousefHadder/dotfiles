#!/bin/bash
# Claude Code -> GitHub Copilot Proxy Startup Script
# Cross-platform (macOS, Linux, Containers)

set -euo pipefail

# Add common paths
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

# Get GitHub token
get_token() {
    local token=""

    # Try macOS Keychain (with account first, then legacy without account)
    if command -v security &>/dev/null; then
        token=$(security find-generic-password -s "litellm-copilot-token" -a "$USER" -w 2>/dev/null) || true
        # Fallback: try without account for legacy tokens
        if [[ -z "$token" ]]; then
            token=$(security find-generic-password -s "litellm-copilot-token" -w 2>/dev/null) || true
        fi
    fi

    # Try Linux secret-tool
    if [[ -z "$token" ]] && command -v secret-tool &>/dev/null; then
        token=$(secret-tool lookup service "litellm-copilot-token" username token 2>/dev/null) || true
    fi

    # Try environment variable
    if [[ -z "$token" ]]; then
        token="${LITELLM_TOKEN:-}"
    fi

    echo "$token"
}

GITHUB_TOKEN=$(get_token)
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Error: GitHub PAT not found"
    echo "Options:"
    echo "  macOS:   security add-generic-password -s \"litellm-copilot-token\" -w \"ghp_YOUR_TOKEN\""
    echo "  Linux:   secret-tool store --label=\"LiteLLM Copilot Token\" service litellm-copilot-token username token"
    echo "  Any:     export LITELLM_TOKEN=\"ghp_YOUR_TOKEN\""
    exit 1
fi
# Export token for LiteLLM GitHub Copilot provider (it checks multiple env vars)
export GITHUB_TOKEN
export COPILOT_GITHUB_TOKEN="$GITHUB_TOKEN"
export GITHUB_API_KEY="$GITHUB_TOKEN"

# Config and port
PROXY_DIR="${HOME}/.claude-copilot-proxy"
CONFIG_FILE="${PROXY_DIR}/config.yaml"
PORT="${LITELLM_PORT:-4000}"

# Disable uvloop (not compatible with Python 3.14)
export UVICORN_LOOP="asyncio"

# Find litellm binary
LITELLM_BIN=""
for path in "$HOME/.local/bin/litellm" "/opt/homebrew/bin/litellm" "/usr/local/bin/litellm" "$(which litellm 2>/dev/null)"; do
    if [[ -x "$path" ]]; then
        LITELLM_BIN="$path"
        break
    fi
done

if [[ -z "$LITELLM_BIN" ]]; then
    echo "Error: litellm not found in PATH"
    exit 1
fi

echo "Starting LiteLLM proxy on port $PORT..."
echo "Config: $CONFIG_FILE"

exec "$LITELLM_BIN" \
    --config "$CONFIG_FILE" \
    --port "$PORT" \
    --host 0.0.0.0
