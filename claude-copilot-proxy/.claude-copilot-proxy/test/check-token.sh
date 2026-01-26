#!/usr/bin/env bash
# test/check-token.sh - Verify GitHub PAT is accessible from secure storage

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

get_token() {
    local token=""

    # Try macOS Keychain
    if command -v security &>/dev/null; then
        token=$(security find-generic-password -s "$KEYCHAIN_SERVICE" -a "$USER" -w 2>/dev/null) || true
        if [[ -z "$token" ]]; then
            # Legacy: try without account
            token=$(security find-generic-password -s "$KEYCHAIN_SERVICE" -w 2>/dev/null) || true
        fi
    fi

    # Try Linux secret-tool
    if [[ -z "$token" ]] && command -v secret-tool &>/dev/null; then
        token=$(secret-tool lookup service "$KEYCHAIN_SERVICE" username token 2>/dev/null) || true
    fi

    # Try environment variable
    if [[ -z "$token" ]]; then
        token="${LITELLM_TOKEN:-}"
    fi

    echo "$token"
}

TOKEN=$(get_token)

if [[ -z "$TOKEN" ]]; then
    echo "No token found in Keychain, secret-tool, or LITELLM_TOKEN"
    exit 1
fi

# Verify format
if [[ ! "$TOKEN" =~ ^(ghp_|github_pat_) ]]; then
    echo "Token doesn't look like a GitHub PAT (should start with ghp_ or github_pat_)"
    exit 1
fi

echo "Token found (redacted)"
exit 0
