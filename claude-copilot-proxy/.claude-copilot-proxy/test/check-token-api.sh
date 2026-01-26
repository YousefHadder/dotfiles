#!/usr/bin/env bash
# test/check-token-api.sh - Validate token with GitHub Copilot API

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

get_token() {
    local token=""

    # Try macOS Keychain
    if command -v security &>/dev/null; then
        token=$(security find-generic-password -s "$KEYCHAIN_SERVICE" -a "$USER" -w 2>/dev/null) || true
        [[ -z "$token" ]] && token=$(security find-generic-password -s "$KEYCHAIN_SERVICE" -w 2>/dev/null) || true
    fi

    # Try Linux secret-tool
    if [[ -z "$token" ]] && command -v secret-tool &>/dev/null; then
        token=$(secret-tool lookup service "$KEYCHAIN_SERVICE" username token 2>/dev/null) || true
    fi

    # Try environment variable
    [[ -z "$token" ]] && token="${LITELLM_TOKEN:-}"

    echo "$token"
}

TOKEN=$(get_token)

if [[ -z "$TOKEN" ]]; then
    echo "No token found"
    exit 1
fi

# Call GitHub Copilot models endpoint
response=$(curl -s -w "\n%{http_code}" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Editor-Version: vscode/1.95.0" \
    -H "Copilot-Integration-Id: vscode-chat" \
    "https://api.githubcopilot.com/models" \
    --max-time 10 2>/dev/null) || true

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [[ "$http_code" == "200" ]]; then
    model_count=$(echo "$body" | jq '.data | length' 2>/dev/null || echo "?")
    echo "Token validated - $model_count models available"
    exit 0
fi

echo "Token validation failed (HTTP $http_code)"
exit 1
