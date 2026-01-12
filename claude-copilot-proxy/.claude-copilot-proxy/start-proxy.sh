#!/bin/bash
# Claude Code -> GitHub Copilot Proxy Startup Script (for launchd)
#
# Uses GitHub PAT stored in macOS Keychain for authentication.
# The PAT must have the 'copilot' scope.
#
# To store your PAT:
#   security add-generic-password -s "litellm-copilot-token" -w "ghp_YOUR_TOKEN"
#
# To update your PAT:
#   security delete-generic-password -s "litellm-copilot-token"
#   security add-generic-password -s "litellm-copilot-token" -w "ghp_NEW_TOKEN"

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Retrieve GitHub PAT from macOS Keychain
GITHUB_TOKEN=$(security find-generic-password -s "litellm-copilot-token" -w 2>/dev/null)
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GitHub PAT not found in Keychain"
    echo "Store it with: security add-generic-password -s \"litellm-copilot-token\" -w \"ghp_YOUR_TOKEN\""
    exit 1
fi
export GITHUB_TOKEN

# Config and log paths
CONFIG_FILE="/Users/yousefhadder/.claude-copilot-proxy/config.yaml"
PORT="${LITELLM_PORT:-4000}"

echo "Starting LiteLLM proxy on port $PORT..."
echo "Config: $CONFIG_FILE"

exec /Users/yousefhadder/.local/bin/litellm \
    --config "$CONFIG_FILE" \
    --port "$PORT" \
    --host 0.0.0.0
