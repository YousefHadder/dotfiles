#!/bin/bash
# Refresh Copilot API key and restart proxy

OAUTH_TOKEN=$(cat ~/.config/litellm/github_copilot/oauth-token.json 2>/dev/null | /opt/homebrew/bin/jq -r '.access_token')

if [ -n "$OAUTH_TOKEN" ] && [ "$OAUTH_TOKEN" != "null" ]; then
    curl -s https://api.github.com/copilot_internal/v2/token \
        -H "Authorization: token $OAUTH_TOKEN" \
        -H "Editor-Version: vscode/1.95.0" > ~/.config/litellm/github_copilot/api-key.json
    
    # Restart proxy to pick up new token
    launchctl stop com.claude-copilot-proxy 2>/dev/null
fi
