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
      │ GitHub PAT (env var or Keychain)
      ▼
┌─────────────────────────────────────────────┐
│   GitHub Copilot API                        │
│   - Claude, GPT, Gemini, Grok models        │
└─────────────────────────────────────────────┘
```

## Supported Models

Last updated: 2026-01-12

| Model                    | Vendor       | Category    |
| ------------------------ | ------------ | ----------- |
| `claude-haiku-4.5`       | Anthropic    | versatile   |
| `claude-opus-4.5`        | Anthropic    | powerful    |
| `claude-sonnet-4`        | Anthropic    | versatile   |
| `claude-sonnet-4.5`      | Anthropic    | versatile   |
| `gemini-2.5-pro`         | Google       | powerful    |
| `gemini-3-flash-preview` | Google       | lightweight |
| `gemini-3-pro-preview`   | Google       | powerful    |
| `gpt-4.1`                | Azure OpenAI | versatile   |
| `gpt-4o`                 | Azure OpenAI | versatile   |
| `gpt-5`                  | Azure OpenAI | versatile   |
| `gpt-5-mini`             | Azure OpenAI | lightweight |
| `grok-code-fast-1`       | xAI          | lightweight |

Run `./update-models` to refresh this list from the Copilot API.

---

## Setup Instructions

### Prerequisites

1. **GitHub Copilot subscription** (Individual or Enterprise)
2. **macOS**, **Linux**, or **Container** (Codespaces, Docker, etc.)
3. **Python 3.9+** with pip

### Step 1: Install Required Tools

#### macOS (Homebrew)

```bash
# Install pipx (for isolated Python environments)
brew install pipx jq
pipx ensurepath

# Install LiteLLM with proxy dependencies
pipx install 'litellm[proxy]'
```

#### Linux (apt-based)

```bash
# Install pipx and jq
sudo apt update && sudo apt install -y pipx jq
pipx ensurepath

# Install LiteLLM with proxy dependencies
pipx install 'litellm[proxy]'
```

#### Containers / Codespaces (pip fallback)

If pipx fails to build `uvloop`, install directly with pip:

```bash
# Install with pip (use prebuilt wheels only to avoid compilation)
pip3 install --user --break-system-packages litellm fastapi uvicorn orjson \
    apscheduler cryptography email-validator websockets

# If uvloop is available as a wheel:
pip3 install --user --break-system-packages --only-binary :all: uvloop

# Install jq
sudo apt install -y jq || brew install jq
```

### Step 2: Create GitHub PAT with Copilot Scope

1. Go to: https://github.com/settings/tokens/new?scopes=copilot&description=LiteLLM%20Copilot%20Proxy
2. Set expiration (90 days recommended)
3. Click **Generate token**
4. Copy the token (starts with `ghp_...`)

### Step 3: Store PAT Securely

#### Option A: Environment Variable (All platforms)

Add to your shell config (`~/.bashrc`, `~/.zshrc`, or Codespaces secrets):

```bash
export LITELLM_TOKEN="ghp_YOUR_TOKEN_HERE"
```

#### Option B: macOS Keychain

```bash
security add-generic-password -s "litellm-copilot-token" -w "ghp_YOUR_TOKEN_HERE"
```

To verify:

```bash
security find-generic-password -s "litellm-copilot-token" -w | head -c 10
# Should show: ghp_xxxxxx
```

#### Option C: Linux Secret Service (GNOME Keyring)

```bash
# Requires libsecret
sudo apt install -y libsecret-tools
secret-tool store --label="LiteLLM Copilot Token" service litellm-copilot-token username token <<< "ghp_YOUR_TOKEN"
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

Add to your shell configuration (`~/.zshrc` or `~/.bashrc`):

```bash
# Claude Code -> GitHub Copilot Proxy Configuration
export ANTHROPIC_BASE_URL="http://localhost:4000"
export ANTHROPIC_AUTH_TOKEN="fake-key"  # Required but not validated by proxy

# If using env var for PAT (recommended for Linux/containers)
export LITELLM_TOKEN="ghp_YOUR_TOKEN_HERE"
```

Reload:

```bash
source ~/.zshrc  # or ~/.bashrc
```

### Step 6: Set Up Auto-Start Service

#### macOS (launchd)

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

#### Linux (systemd)

```bash
# Create systemd user service
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/claude-copilot-proxy.service << EOF
[Unit]
Description=Claude Code -> GitHub Copilot Proxy
After=network.target

[Service]
Type=simple
Environment="LITELLM_TOKEN=${LITELLM_TOKEN}"
ExecStart=%h/.claude-copilot-proxy/start-proxy.sh
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
EOF

# Enable and start the service
systemctl --user daemon-reload
systemctl --user enable claude-copilot-proxy
systemctl --user start claude-copilot-proxy
```

#### Containers / Codespaces (no systemd)

For environments without systemd (Docker, Codespaces, WSL1):

```bash
# Start manually as background process
nohup ~/.claude-copilot-proxy/start-proxy.sh > /tmp/claude-copilot-proxy.log 2>&1 &

# For Codespaces: add to .devcontainer/postStartCommand or ~/.bashrc
echo 'pgrep -f "litellm" || ~/.claude-copilot-proxy/start-proxy.sh &' >> ~/.bashrc
```

### Step 7: Verify Setup

```bash
# Check if proxy is running
lsof -i :4000

# macOS: check launchd status
launchctl list | grep claude

# Linux: check systemd status
systemctl --user status claude-copilot-proxy

# Check logs
tail -f /tmp/claude-copilot-proxy.log          # macOS/containers
journalctl --user -u claude-copilot-proxy -f   # Linux systemd

# Test the proxy
curl -X POST http://localhost:4000/chat/completions \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer fake-key' \
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

| Action  | Command                                                                  |
| ------- | ------------------------------------------------------------------------ |
| Start   | `launchctl start com.claude-copilot-proxy`                               |
| Stop    | `launchctl stop com.claude-copilot-proxy`                                |
| Restart | `launchctl kickstart -k gui/$(id -u)/com.claude-copilot-proxy`           |
| Status  | `launchctl list \| grep claude`                                          |
| Logs    | `tail -f /tmp/claude-copilot-proxy.log`                                  |
| Disable | `launchctl unload ~/Library/LaunchAgents/com.claude-copilot-proxy.plist` |
| Enable  | `launchctl load ~/Library/LaunchAgents/com.claude-copilot-proxy.plist`   |

### Linux (systemd)

| Action  | Command                                         |
| ------- | ----------------------------------------------- |
| Start   | `systemctl --user start claude-copilot-proxy`   |
| Stop    | `systemctl --user stop claude-copilot-proxy`    |
| Restart | `systemctl --user restart claude-copilot-proxy` |
| Status  | `systemctl --user status claude-copilot-proxy`  |
| Logs    | `journalctl --user -u claude-copilot-proxy -f`  |
| Disable | `systemctl --user disable claude-copilot-proxy` |
| Enable  | `systemctl --user enable claude-copilot-proxy`  |

### Containers / Manual

| Action | Command                                         |
| ------ | ----------------------------------------------- |
| Start  | `~/.claude-copilot-proxy/start-proxy.sh &`      |
| Stop   | `pkill -f litellm` or `kill $(lsof -t -i:4000)` |
| Status | `lsof -i :4000`                                 |
| Logs   | `tail -f /tmp/claude-copilot-proxy.log`         |

### Update Available Models

```bash
# Dry run (show what would change)
~/.claude-copilot-proxy/update-models --dry-run

# Update config.yaml with working models
~/.claude-copilot-proxy/update-models

# Restart proxy to pick up changes
# macOS:
launchctl kickstart -k gui/$(id -u)/com.claude-copilot-proxy
# Linux:
systemctl --user restart claude-copilot-proxy
# Containers:
kill $(lsof -t -i:4000) && ~/.claude-copilot-proxy/start-proxy.sh &
```

---

## Troubleshooting

### PAT Not Found

#### macOS (Keychain)

```bash
# Check if entry exists
security find-generic-password -s "litellm-copilot-token" 2>&1

# Re-add if missing
security add-generic-password -s "litellm-copilot-token" -w "ghp_YOUR_TOKEN"

# Update existing token
security delete-generic-password -s "litellm-copilot-token"
security add-generic-password -s "litellm-copilot-token" -w "ghp_NEW_TOKEN"
```

#### Linux / Containers (Environment Variable)

```bash
# Check if set
echo $LITELLM_TOKEN | head -c 10

# Add to shell config if missing
echo 'export LITELLM_TOKEN="ghp_YOUR_TOKEN"' >> ~/.bashrc
source ~/.bashrc
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
# Test PAT directly (works on any platform)
curl -H "Authorization: Bearer $LITELLM_TOKEN" \
     -H "Editor-Version: vscode/1.95.0" \
     -H "Copilot-Integration-Id: vscode-chat" \
     https://api.githubcopilot.com/models

# If unauthorized, create a new PAT with copilot scope
```

### "No connected db" Error

This happens when LiteLLM tries to validate API keys against a database. Add this to your `config.yaml`:

```yaml
general_settings:
  allow_requests_on_db_unavailable: true
```

---

## File Inventory

| File                  | Purpose                                    |
| --------------------- | ------------------------------------------ |
| `config.yaml`         | LiteLLM wildcard routing + model aliases   |
| `config.yaml.example` | Git-safe template                          |
| `start-proxy.sh`      | Startup script (fetches PAT, runs LiteLLM) |
| `update-models`       | Syncs available models from Copilot API    |
| `README.md`           | This documentation                         |

---

## Security Notes

- **Local-only proxy**: Runs on `localhost:4000`, not exposed to internet
- **PAT storage**: Use Keychain (macOS), Secret Service (Linux), or environment variables
- **Minimal PAT scope**: Only `copilot` scope needed
- **No secrets in config**: `config.yaml` references `os.environ/GITHUB_TOKEN`

---

## Updating Your PAT

When your PAT expires:

### macOS

```bash
# 1. Create new PAT at https://github.com/settings/tokens/new?scopes=copilot
# 2. Delete old Keychain entry
security delete-generic-password -s "litellm-copilot-token"

# 3. Add new token
security add-generic-password -s "litellm-copilot-token" -w "ghp_NEW_TOKEN"

# 4. Restart proxy
launchctl kickstart -k gui/$(id -u)/com.claude-copilot-proxy
```

### Linux / Containers

```bash
# 1. Create new PAT at https://github.com/settings/tokens/new?scopes=copilot
# 2. Update environment variable in ~/.bashrc or ~/.zshrc
export LITELLM_TOKEN="ghp_NEW_TOKEN"

# 3. Reload shell and restart proxy
source ~/.bashrc
systemctl --user restart claude-copilot-proxy  # or kill & restart manually
```

---

## Changelog

| Date         | Change                                                                 |
| ------------ | ---------------------------------------------------------------------- |
| Jan 24, 2026 | Added Linux, systemd, and container support; fixed config for PAT auth |
| Jan 12, 2026 | Hybrid approach: PAT auth + wildcard config + update-models script     |
| Jan 7, 2026  | Comprehensive fresh machine setup guide                                |
| Nov 30, 2025 | Environment variable migration                                         |
| Nov 26, 2025 | Initial setup                                                          |
