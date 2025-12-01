#!/bin/bash
# Refresh GitHub Copilot token for LiteLLM proxy

echo "Starting GitHub device flow..."
RESP=$(curl -s -X POST https://github.com/login/device/code \
  -H "Accept: application/json" \
  -d "client_id=Iv1.b507a08c87ecfe98&scope=read:user")

USER_CODE=$(echo "$RESP" | jq -r '.user_code')
DEVICE_CODE=$(echo "$RESP" | jq -r '.device_code')

echo ""
echo "Please visit: https://github.com/login/device"
echo "Enter code:   $USER_CODE"
echo ""
read -p "Press Enter after you've authorized..."

# Get access token
TOKEN_RESP=$(curl -s -X POST https://github.com/login/oauth/access_token \
  -H "Accept: application/json" \
  -d "client_id=Iv1.b507a08c87ecfe98&device_code=$DEVICE_CODE&grant_type=urn:ietf:params:oauth:grant-type:device_code")

ACCESS_TOKEN=$(echo "$TOKEN_RESP" | jq -r '.access_token')

if [ "$ACCESS_TOKEN" = "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "❌ Failed to get token. Try again."
  exit 1
fi

# Save tokens
mkdir -p ~/.config/litellm/github_copilot
echo "{\"access_token\":\"$ACCESS_TOKEN\",\"token_type\":\"bearer\"}" > ~/.config/litellm/github_copilot/oauth-token.json

curl -s https://api.github.com/copilot_internal/v2/token \
  -H "Authorization: token $ACCESS_TOKEN" \
  -H "Editor-Version: vscode/1.95.0" > ~/.config/litellm/github_copilot/api-key.json

# Restart proxy
pkill -f litellm 2>/dev/null; sleep 1
nohup litellm --config ~/.claude-copilot-proxy/config.yaml --port 4000 --host 0.0.0.0 > /tmp/litellm.log 2>&1 &
sleep 3

if lsof -i :4000 | grep -q LISTEN; then
  echo "✅ Token refreshed and proxy restarted!"
else
  echo "❌ Proxy failed to start. Check /tmp/litellm.log"
fi
