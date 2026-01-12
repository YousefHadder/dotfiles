# Claude Code -> GitHub Copilot Proxy Setup

This setup routes Claude Code requests through GitHub Copilot, allowing you to use Claude Code's interface while leveraging your GitHub Copilot subscription.

## Architecture

```
Claude Code CLI
      │
      │ ANTHROPIC_BASE_URL=http://localhost:4000
      ▼
┌─────────────────────────────────────────────┐
│   LiteLLM Proxy (localhost:4000)            │
│   - Wildcard model routing                  │
│   - Model alias translation                 │
│   - Adds required Copilot headers           │
└─────────────────────────────────────────────┘
      │
      │ GitHub PAT from macOS Keychain
      ▼
┌─────────────────────────────────────────────┐
│   GitHub Copilot API                        │
│   - Claude, GPT, Gemini, Grok models        │
└─────────────────────────────────────────────┘
```

## Supported Models

Last updated: 2026-01-12

| Model | Vendor | Category |
| --- | --- | --- |
| `claude-haiku-4.5` | Anthropic | versatile |
| `claude-opus-4.5` | Anthropic | powerful |
| `claude-sonnet-4` | Anthropic | versatile |
| `claude-sonnet-4.5` | Anthropic | versatile |
| `gemini-2.5-pro` | Google | powerful |
| `gemini-3-flash-preview` | Google | lightweight |
| `gemini-3-pro-preview` | Google | powerful |
| `gpt-4.1` | Azure OpenAI | versatile |
| `gpt-4o` | Azure OpenAI | versatile |
| `gpt-5` | Azure OpenAI | versatile |
| `gpt-5-mini` | Azure OpenAI | lightweight |
| `grok-code-fast-1` | xAI | lightweight |

Run `./update-models` to refresh this list from the Copilot API.

---

## Setup Instructions

### Prerequisites

1. **GitHub Copilot subscription** (Individual or Enterprise)
2. **macOS** (for launchd) or **Linux** (for systemd)
3. **Homebrew** installed (macOS)

### Step 1: Install Required Tools

```bash
# Install pipx (for isolated Python environments)
brew install pipx
pipx ensurepath

# Install LiteLLM
pipx install litellm

# Install jq (JSON processor)
brew install jq
```

### Step 2: Create GitHub PAT with Copilot Scope

1. Go to: https://github.com/settings/tokens/new?scopes=copilot&description=LiteLLM%20Copilot%20Proxy
2. Set expiration (90 days recommended)
3. Click **Generate token**
4. Copy the token (starts with `ghp_...`)

### Step 3: Store PAT in macOS Keychain

```bash
security add-generic-password -s "litellm-copilot-token" -w "ghp_YOUR_TOKEN_HERE"
```

To verify:
```bash
security find-generic-password -s "litellm-copilot-token" -w | head -c 10
# Should show: ghp_xxxxxx
```

### Step 4: Create Directory Structure

```bash
# Create proxy configuration directory
mkdir -p ~/.claude-copilot-proxy

# Copy files from this repo (if tracking in dotfiles)
cp config.yaml start-proxy.sh update-models ~/.claude-copilot-proxy/
chmod +x ~/.claude-copilot-proxy/start-proxy.sh
chmod +x ~/.claude-copilot-proxy/update-models
```

### Step 5: Configure Environment Variables

Add to your shell configuration (`~/.zshrc`):

```bash
# Claude Code -> GitHub Copilot Proxy Configuration
export ANTHROPIC_BASE_URL="http://localhost:4000"
export ANTHROPIC_AUTH_TOKEN="fake-key"  # Required but not validated by proxy
```

Reload:
```bash
source ~/.zshrc
```

### Step 6: Set Up Auto-Start Service (macOS)

```bash
# Get your username
USERNAME=$(whoami)

# Create launchd plist
cat > ~/Library/LaunchAgents/com.claude-copilot-proxy.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude-copilot-proxy</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/$USERNAME/.claude-copilot-proxy/start-proxy.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/claude-copilot-proxy.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/claude-copilot-proxy.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
</dict>
</plist>
EOF

# Load and start the service
launchctl load ~/Library/LaunchAgents/com.claude-copilot-proxy.plist
launchctl start com.claude-copilot-proxy
```

### Step 7: Verify Setup

```bash
# Check if proxy is running
launchctl list | grep claude
lsof -i :4000

# Check logs
tail -f /tmp/claude-copilot-proxy.log

# Test the proxy
curl -X POST http://localhost:4000/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{"model": "claude-sonnet-4", "messages": [{"role": "user", "content": "Say hello"}]}'
```

### Step 8: Use with Claude Code

```bash
# Open a NEW terminal to pick up environment variables
claude
```

All Claude Code requests will now route through GitHub Copilot!

---

## Managing the Proxy

### macOS (launchd)

| Action | Command |
|--------|---------|
| Start | `launchctl start com.claude-copilot-proxy` |
| Stop | `launchctl stop com.claude-copilot-proxy` |
| Restart | `launchctl kickstart -k gui/$(id -u)/com.claude-copilot-proxy` |
| Status | `launchctl list \| grep claude` |
| Logs | `tail -f /tmp/claude-copilot-proxy.log` |
| Disable | `launchctl unload ~/Library/LaunchAgents/com.claude-copilot-proxy.plist` |
| Enable | `launchctl load ~/Library/LaunchAgents/com.claude-copilot-proxy.plist` |

### Update Available Models

```bash
# Dry run (show what would change)
~/.claude-copilot-proxy/update-models --dry-run

# Update config.yaml with working models
~/.claude-copilot-proxy/update-models

# Restart proxy to pick up changes
launchctl kickstart -k gui/$(id -u)/com.claude-copilot-proxy
```

---

## Troubleshooting

### PAT Not Found in Keychain

```bash
# Check if entry exists
security find-generic-password -s "litellm-copilot-token" 2>&1

# Re-add if missing
security add-generic-password -s "litellm-copilot-token" -w "ghp_YOUR_TOKEN"

# Update existing token
security delete-generic-password -s "litellm-copilot-token"
security add-generic-password -s "litellm-copilot-token" -w "ghp_NEW_TOKEN"
```

### Proxy Won't Start

```bash
# Check logs
tail -50 /tmp/claude-copilot-proxy.log

# Verify litellm is installed
which litellm
litellm --version

# Test startup script manually
~/.claude-copilot-proxy/start-proxy.sh

# Check port availability
lsof -i :4000
```

### Claude Code Bypasses Proxy

```bash
# Verify environment variables
echo $ANTHROPIC_BASE_URL    # Should be http://localhost:4000

# Reload shell config
source ~/.zshrc

# Test proxy health
curl http://localhost:4000/health
```

### Authentication Errors (401/403)

```bash
# Test PAT directly
GITHUB_TOKEN=$(security find-generic-password -s "litellm-copilot-token" -w)
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     -H "Editor-Version: vscode/1.95.0" \
     https://api.githubcopilot.com/models

# If unauthorized, create a new PAT with copilot scope
```

---

## File Inventory

| File | Purpose |
|------|---------|
| `config.yaml` | LiteLLM wildcard routing + model aliases |
| `config.yaml.example` | Git-safe template |
| `start-proxy.sh` | Startup script (fetches PAT, runs LiteLLM) |
| `update-models` | Syncs available models from Copilot API |
| `README.md` | This documentation |

---

## Security Notes

- **Local-only proxy**: Runs on `localhost:4000`, not exposed to internet
- **PAT in Keychain**: Stored securely in macOS Keychain, not in files
- **Minimal PAT scope**: Only `copilot` scope needed
- **No secrets in config**: `config.yaml` references `os.environ/GITHUB_TOKEN`

---

## Updating Your PAT

When your PAT expires:

```bash
# 1. Create new PAT at https://github.com/settings/tokens/new?scopes=copilot
# 2. Delete old Keychain entry
security delete-generic-password -s "litellm-copilot-token"

# 3. Add new token
security add-generic-password -s "litellm-copilot-token" -w "ghp_NEW_TOKEN"

# 4. Restart proxy
launchctl kickstart -k gui/$(id -u)/com.claude-copilot-proxy
```

---

## Changelog

| Date | Change |
|------|--------|
| Jan 12, 2026 | Hybrid approach: PAT auth + wildcard config + update-models script |
| Jan 7, 2026 | Comprehensive fresh machine setup guide |
| Nov 30, 2025 | Environment variable migration |
| Nov 26, 2025 | Initial setup |
