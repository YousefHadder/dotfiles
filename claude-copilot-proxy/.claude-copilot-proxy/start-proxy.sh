#!/bin/bash
# Claude Code → GitHub Copilot Proxy Startup Script (for launchd)

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"

# Refresh Copilot API key on startup (uses cached OAuth token)
OAUTH_TOKEN=$(cat ~/.config/litellm/github_copilot/oauth-token.json 2>/dev/null | /opt/homebrew/bin/jq -r '.access_token')
if [ -n "$OAUTH_TOKEN" ] && [ "$OAUTH_TOKEN" != "null" ]; then
    curl -s https://api.github.com/copilot_internal/v2/token \
        -H "Authorization: token $OAUTH_TOKEN" \
        -H "Editor-Version: vscode/1.95.0" > ~/.config/litellm/github_copilot/api-key.json
fi

exec /Users/yousefhadder/.local/bin/litellm \
    --config /Users/yousefhadder/.claude-copilot-proxy/config.yaml \
    --port 4000 \
    --host 0.0.0.0
