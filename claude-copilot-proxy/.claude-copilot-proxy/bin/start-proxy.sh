#!/usr/bin/env bash
# bin/start-proxy.sh - Start the LiteLLM proxy
#
# This script retrieves the GitHub PAT from secure storage and starts
# the LiteLLM proxy server.

set -euo pipefail

# Determine script and proxy directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROXY_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
export PROXY_DIR

# Add common paths
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

# Source minimal required modules
source "${PROXY_DIR}/lib/common.sh"
source "${PROXY_DIR}/lib/token/macos.sh"
source "${PROXY_DIR}/lib/token/linux.sh"
source "${PROXY_DIR}/lib/token/env.sh"

# =============================================================================
# Get Token
# =============================================================================

get_github_token() {
    local token=""

    # Try macOS Keychain
    token=$(keychain_get 2>/dev/null) || true

    # Try Linux secret-tool
    if [[ -z "$token" ]]; then
        token=$(secret_tool_get 2>/dev/null) || true
    fi

    # Try environment variable
    if [[ -z "$token" ]]; then
        token=$(env_get)
    fi

    echo "$token"
}

# =============================================================================
# Main
# =============================================================================

GITHUB_TOKEN=$(get_github_token)

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Error: GitHub PAT not found"
    echo "Options:"
    echo "  macOS:   security add-generic-password -s \"litellm-copilot-token\" -a \"\$USER\" -w \"ghp_YOUR_TOKEN\""
    echo "  Linux:   secret-tool store --label=\"LiteLLM Copilot Token\" service litellm-copilot-token username token"
    echo "  Any:     export LITELLM_TOKEN=\"ghp_YOUR_TOKEN\""
    exit 1
fi

# Export token for LiteLLM GitHub Copilot provider
export GITHUB_TOKEN
export COPILOT_GITHUB_TOKEN="$GITHUB_TOKEN"
export GITHUB_API_KEY="$GITHUB_TOKEN"

# Config and port
CONFIG_FILE="${PROXY_DIR}/config.yaml"
PORT="${PROXY_PORT:-4000}"

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
