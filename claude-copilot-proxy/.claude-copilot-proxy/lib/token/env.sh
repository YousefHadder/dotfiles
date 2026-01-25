#!/usr/bin/env bash
# lib/token/env.sh - Environment variable token storage (fallback for all platforms)

# Get token from environment variable
env_get() {
    echo "${LITELLM_TOKEN:-}"
}

# Store token in shell config as environment variable
env_store() {
    local token="$1"

    add_to_shell_config "export LITELLM_TOKEN=\"$token\""
    export LITELLM_TOKEN="$token"
    success "Token stored in $SHELL_CONFIG"
}

# Verify LITELLM_TOKEN is set
env_verify() {
    [[ -n "${LITELLM_TOKEN:-}" ]]
}
