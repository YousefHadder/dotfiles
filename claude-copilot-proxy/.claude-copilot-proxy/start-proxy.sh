#!/bin/bash
# Claude Code → GitHub Copilot Proxy Startup Script (for launchd)

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"

# Sync access-token from GitHub Copilot's apps.json (VSCode/CLI oauth token)
# LiteLLM uses this file for automatic API key refresh
COPILOT_TOKEN=$(/opt/homebrew/bin/jq -r '.[].oauth_token // empty' ~/.config/github-copilot/apps.json 2>/dev/null | head -1)
if [ -n "$COPILOT_TOKEN" ]; then
    echo "$COPILOT_TOKEN" > ~/.config/litellm/github_copilot/access-token
fi

exec /Users/yousefhadder/.local/bin/litellm \
    --config /Users/yousefhadder/.claude-copilot-proxy/config.yaml \
    --port 4000 \
    --host 0.0.0.0
