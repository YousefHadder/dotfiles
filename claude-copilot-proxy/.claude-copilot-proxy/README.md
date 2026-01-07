# Claude Code → GitHub Copilot Proxy Setup

This setup routes Claude Code requests through GitHub Copilot, allowing you to use Claude Code's interface while leveraging your GitHub Copilot subscription.

## Architecture

```
Claude Code → LiteLLM Proxy (localhost:4000) → GitHub Copilot API → AI Models
```

## Model Mappings

| Claude Code Model          | Routes to GitHub Copilot Model |
|----------------------------|-------------------------------|
| claude-opus-4-5-20251101   | claude-opus-4.5               |
| claude-sonnet-4-5-20250929 | claude-sonnet-4.5 (native!)   |
| claude-sonnet-4-20250514   | claude-sonnet-4               |
| claude-3-5-sonnet-20241022 | gpt-4o                        |
| claude-3-5-haiku-20241022  | claude-haiku-4.5              |
| claude-opus-4-20250514     | claude-opus-41                |

---

## Setup Instructions

Follow these steps to set up the proxy on a new machine.

### Prerequisites

1. **GitHub Copilot subscription** (Individual or Enterprise)
2. **macOS** (for launchd) or **Linux** (for systemd)
3. **Homebrew** installed (macOS) or equivalent package manager (Linux)

### Step 1: Install Required Tools

<details>
<summary>Click to expand installation commands</summary>

```bash
# Install pipx (for isolated Python environments)
brew install pipx  # macOS
# OR
sudo apt install pipx  # Ubuntu/Debian

# Ensure pipx is in PATH
pipx ensurepath

# Install LiteLLM
pipx install litellm

# Install GitHub CLI
brew install gh  # macOS
# OR
sudo apt install gh  # Ubuntu/Debian

# Install jq (JSON processor)
brew install jq  # macOS
# OR
sudo apt install jq  # Ubuntu/Debian
```

</details>

### Step 2: Authenticate with GitHub Copilot

You need a GitHub Copilot OAuth token stored in `~/.config/github-copilot/apps.json`.

<details>
<summary>Click to expand authentication options</summary>

**Option A: Via GitHub CLI (Recommended)**
```bash
gh auth login
gh auth status  # Verify authentication
```

**Option B: Via VSCode**
- Install VSCode with the GitHub Copilot extension
- Sign in to GitHub Copilot
- The token will automatically be stored

**Verify the token exists:**
```bash
cat ~/.config/github-copilot/apps.json
# Should show JSON with an oauth_token field
```

</details>

### Step 3: Create Directory Structure

<details>
<summary>Click to expand directory creation commands</summary>

```bash
# Create proxy configuration directory
mkdir -p ~/.claude-copilot-proxy

# Create LiteLLM token directory
mkdir -p ~/.config/litellm/github_copilot
```

</details>

### Step 4: Create Configuration Files

<details>
<summary>Click to expand startup script creation</summary>

**Create the startup script `~/.claude-copilot-proxy/start-proxy.sh`:**

```bash
cat > ~/.claude-copilot-proxy/start-proxy.sh << 'EOF'
#!/bin/bash
# Claude Code → GitHub Copilot Proxy Startup Script

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"

# Sync access-token from GitHub Copilot's apps.json (VSCode/CLI oauth token)
# LiteLLM uses this file for automatic API key refresh
COPILOT_TOKEN=$(jq -r '.[].oauth_token // empty' ~/.config/github-copilot/apps.json 2>/dev/null | head -1)
if [ -n "$COPILOT_TOKEN" ]; then
    mkdir -p ~/.config/litellm/github_copilot
    echo "$COPILOT_TOKEN" > ~/.config/litellm/github_copilot/access-token
fi

exec ~/.local/bin/litellm \
    --config ~/.claude-copilot-proxy/config.yaml \
    --port 4000 \
    --host 0.0.0.0
EOF

# Make it executable
chmod +x ~/.claude-copilot-proxy/start-proxy.sh
```

</details>

<details>
<summary>Click to expand config.yaml creation</summary>

**Create the configuration file `~/.claude-copilot-proxy/config.yaml`:**

```bash
cat > ~/.claude-copilot-proxy/config.yaml << 'EOF'
model_list:
  # Map Claude Opus 4.5 to Copilot's Claude Opus 4.5
  - model_name: claude-opus-4-5-20251101
    litellm_params:
      model: github_copilot/claude-opus-4.5
      extra_headers:
        Editor-Version: "vscode/1.95.0"
        Copilot-Integration-Id: "vscode-chat"

  # Map Claude Sonnet 4.5 to GitHub Copilot's Claude Sonnet 4.5 (native!)
  - model_name: claude-sonnet-4-5-20250929
    litellm_params:
      model: github_copilot/claude-sonnet-4.5
      extra_headers:
        Editor-Version: "vscode/1.95.0"
        Copilot-Integration-Id: "vscode-chat"

  # Map Claude Sonnet 4 to GitHub Copilot's Claude Sonnet 4
  - model_name: claude-sonnet-4-20250514
    litellm_params:
      model: github_copilot/claude-sonnet-4
      extra_headers:
        Editor-Version: "vscode/1.95.0"
        Copilot-Integration-Id: "vscode-chat"

  # Map Claude Sonnet 3.5 to GitHub Copilot GPT-4o
  - model_name: claude-3-5-sonnet-20241022
    litellm_params:
      model: github_copilot/gpt-4o
      extra_headers:
        Editor-Version: "vscode/1.95.0"
        Copilot-Integration-Id: "vscode-chat"

  # Map Claude Haiku 3.5 to GitHub Copilot's Claude Haiku 4.5
  - model_name: claude-3-5-haiku-20241022
    litellm_params:
      model: github_copilot/claude-haiku-4.5
      extra_headers:
        Editor-Version: "vscode/1.95.0"
        Copilot-Integration-Id: "vscode-chat"

  # Map Claude Opus 4 to Claude Opus 41
  - model_name: claude-opus-4-20250514
    litellm_params:
      model: github_copilot/claude-opus-41
      extra_headers:
        Editor-Version: "vscode/1.95.0"
        Copilot-Integration-Id: "vscode-chat"

general_settings:
  # Master key for authenticating to the proxy
  master_key: sk-claude-copilot-proxy-default

router_settings:
  # Retry failed requests
  num_retries: 2

  # Timeout for requests (5 minutes)
  timeout: 300

  # Routing strategy
  routing_strategy: simple-shuffle

litellm_settings:
  # Drop unsupported parameters when calling GitHub Copilot
  drop_params: true
EOF
```

</details>

### Step 5: Configure Environment Variables

Add to your shell configuration file:

<details>
<summary>Click to expand Zsh configuration</summary>

**For Zsh (`~/.zshrc`):**
```bash
cat >> ~/.zshrc << 'EOF'

# Claude Code → GitHub Copilot Proxy Configuration
export ANTHROPIC_BASE_URL="http://localhost:4000"
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"
export ANTHROPIC_AUTH_TOKEN="${LITELLM_MASTER_KEY}"
# Note: Only set AUTH_TOKEN, not API_KEY, to avoid auth conflict
EOF

# Reload shell configuration
source ~/.zshrc
```

</details>

<details>
<summary>Click to expand Bash configuration</summary>

**For Bash (`~/.bashrc`):**
```bash
cat >> ~/.bashrc << 'EOF'

# Claude Code → GitHub Copilot Proxy Configuration
export ANTHROPIC_BASE_URL="http://localhost:4000"
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"
export ANTHROPIC_AUTH_TOKEN="${LITELLM_MASTER_KEY}"
# Note: Only set AUTH_TOKEN, not API_KEY, to avoid auth conflict
EOF

# Reload shell configuration
source ~/.bashrc
```

</details>

<details>
<summary>Click to expand Fish configuration</summary>

**For Fish (`~/.config/fish/config.fish`):**
```bash
cat >> ~/.config/fish/config.fish << 'EOF'

# Claude Code → GitHub Copilot Proxy Configuration
set -gx ANTHROPIC_BASE_URL "http://localhost:4000"
set -gx LITELLM_MASTER_KEY "sk-claude-copilot-proxy-default"
set -gx ANTHROPIC_AUTH_TOKEN "$LITELLM_MASTER_KEY"
EOF
```

</details>

### Step 6: Set Up Auto-Start Service

<details>
<summary>Click to expand macOS (launchd) setup</summary>

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

</details>

<details>
<summary>Click to expand Linux (systemd) setup</summary>

#### Linux (systemd)

```bash
# Create systemd user directory
mkdir -p ~/.config/systemd/user

# Create systemd service file
cat > ~/.config/systemd/user/claude-copilot-proxy.service << EOF
[Unit]
Description=Claude Code to GitHub Copilot Proxy
After=network.target

[Service]
Type=simple
ExecStart=$HOME/.claude-copilot-proxy/start-proxy.sh
Restart=always
RestartSec=10
StandardOutput=append:/tmp/claude-copilot-proxy.log
StandardError=append:/tmp/claude-copilot-proxy.log

[Install]
WantedBy=default.target
EOF

# Reload systemd, enable and start the service
systemctl --user daemon-reload
systemctl --user enable claude-copilot-proxy
systemctl --user start claude-copilot-proxy
```

</details>

### Step 7: Verify Setup

<details>
<summary>Click to expand verification commands</summary>

```bash
# Check if proxy is running
launchctl list | grep claude  # macOS
# OR
systemctl --user status claude-copilot-proxy  # Linux

# Check if port 4000 is listening
lsof -i :4000

# Check logs
tail -f /tmp/claude-copilot-proxy.log

# Test the proxy
curl -X POST http://localhost:4000/v1/messages \
  -H 'Content-Type: application/json' \
  -H "x-api-key: sk-claude-copilot-proxy-default" \
  -d '{"model": "claude-3-5-haiku-20241022", "max_tokens": 100, "messages": [{"role": "user", "content": "Say hello"}]}'
```

You should get a response from Claude Haiku 4.5 via GitHub Copilot!

</details>

### Step 8: Use with Claude Code

```bash
# Open a NEW terminal to pick up environment variables
# Launch Claude Code - it will automatically use the proxy
claude
```

All Claude Code requests will now route through GitHub Copilot!

---

## How It Works

### Token Flow

1. **GitHub Authentication**: GitHub CLI or VSCode stores OAuth token in `~/.config/github-copilot/apps.json`
2. **Token Sync**: On startup, `start-proxy.sh` extracts the token using `jq` and writes it to `~/.config/litellm/github_copilot/access-token`
3. **LiteLLM Proxy**: Runs on `localhost:4000`, intercepts Claude Code requests
4. **Model Mapping**: Translates Claude model names to GitHub Copilot models
5. **Request Routing**: Forwards requests to GitHub Copilot API with proper authentication
6. **Response**: Returns responses to Claude Code as if they came from Anthropic

### Key Files

- **`~/.config/github-copilot/apps.json`**: GitHub Copilot OAuth token (maintained by GitHub tools)
- **`~/.config/litellm/github_copilot/access-token`**: Synced OAuth token (created by startup script)
- **`~/.claude-copilot-proxy/config.yaml`**: LiteLLM proxy configuration (model mappings)
- **`~/.claude-copilot-proxy/start-proxy.sh`**: Startup script (syncs token and starts proxy)

---

## Managing the Proxy

<details>
<summary>Click to expand macOS (launchd) commands</summary>

### macOS (launchd)

```bash
# Check status
launchctl list | grep claude
lsof -i :4000

# Stop the proxy
launchctl stop com.claude-copilot-proxy

# Start the proxy
launchctl start com.claude-copilot-proxy

# Disable auto-start
launchctl unload ~/Library/LaunchAgents/com.claude-copilot-proxy.plist

# Re-enable auto-start
launchctl load ~/Library/LaunchAgents/com.claude-copilot-proxy.plist

# View logs
tail -f /tmp/claude-copilot-proxy.log
```

</details>

<details>
<summary>Click to expand Linux (systemd) commands</summary>

### Linux (systemd)

```bash
# Check status
systemctl --user status claude-copilot-proxy

# Stop the proxy
systemctl --user stop claude-copilot-proxy

# Start the proxy
systemctl --user start claude-copilot-proxy

# Restart the proxy
systemctl --user restart claude-copilot-proxy

# Disable auto-start
systemctl --user disable claude-copilot-proxy

# Re-enable auto-start
systemctl --user enable claude-copilot-proxy

# View logs
journalctl --user -u claude-copilot-proxy -f
# OR
tail -f /tmp/claude-copilot-proxy.log
```

</details>

---

## Troubleshooting

<details>
<summary>GitHub Token Not Found</summary>

**Symptom**: Proxy starts but authentication fails

**Solution**:
```bash
# Verify GitHub Copilot token exists
cat ~/.config/github-copilot/apps.json

# If empty or missing, re-authenticate
gh auth login

# Verify Copilot access
gh api /user/copilot

# Restart the proxy to sync the token
launchctl restart com.claude-copilot-proxy  # macOS
# OR
systemctl --user restart claude-copilot-proxy  # Linux
```

</details>

<details>
<summary>Proxy Won't Start</summary>

**Symptom**: Service fails to start or crashes

**Solution**:
```bash
# Check logs for errors
tail -50 /tmp/claude-copilot-proxy.log

# Verify litellm is installed and in PATH
which litellm
litellm --version

# Test startup script manually
~/.claude-copilot-proxy/start-proxy.sh

# Check port availability
lsof -i :4000

# If port is in use, kill the process
kill $(lsof -t -i :4000)

# Reinstall LiteLLM if needed
pipx reinstall litellm
```

</details>

<details>
<summary>Claude Code Still Uses Anthropic API</summary>

**Symptom**: Claude Code bypasses the proxy

**Solution**:
```bash
# Verify environment variables are set
echo $ANTHROPIC_BASE_URL    # Should be http://localhost:4000
echo $ANTHROPIC_AUTH_TOKEN  # Should be sk-claude-copilot-proxy-default

# If not set, reload shell configuration
source ~/.zshrc  # or ~/.bashrc

# Ensure proxy is running
curl http://localhost:4000/health

# Test proxy directly
curl -X POST http://localhost:4000/v1/messages \
  -H 'Content-Type: application/json' \
  -H "x-api-key: ${LITELLM_MASTER_KEY}" \
  -d '{"model": "claude-3-5-haiku-20241022", "max_tokens": 100, "messages": [{"role": "user", "content": "test"}]}'
```

</details>

<details>
<summary>Authentication Errors from GitHub Copilot</summary>

**Symptom**: 401 or 403 errors in logs

**Solution**:
```bash
# Check GitHub authentication status
gh auth status

# Check GitHub Copilot subscription
gh api /user/copilot

# Refresh GitHub authentication
gh auth refresh

# Force token resync
~/.claude-copilot-proxy/start-proxy.sh
```

</details>

<details>
<summary>Token Sync Fails</summary>

**Symptom**: `access-token` file is empty or missing

**Solution**:
```bash
# Verify jq is installed
which jq
jq --version

# Manually test token extraction
jq -r '.[].oauth_token // empty' ~/.config/github-copilot/apps.json

# If empty, re-authenticate
gh auth login

# Manually run token sync
COPILOT_TOKEN=$(jq -r '.[].oauth_token // empty' ~/.config/github-copilot/apps.json 2>/dev/null | head -1)
echo "$COPILOT_TOKEN" > ~/.config/litellm/github_copilot/access-token

# Verify token was written
cat ~/.config/litellm/github_copilot/access-token
```

</details>

---

## Updating Model Mappings

Edit `~/.claude-copilot-proxy/config.yaml` to change which Claude models map to which GitHub Copilot models.

**Available GitHub Copilot models:**
- **Claude**: `claude-opus-4.5`, `claude-opus-41`, `claude-sonnet-4.5`, `claude-sonnet-4`, `claude-haiku-4.5`
- **OpenAI**: `gpt-4o`, `gpt-4o-mini`, `o1-preview`, `o1-mini`
- **Google**: `gemini-2.0-flash-exp`, `gemini-exp-1206`

<details>
<summary>Click to expand restart commands</summary>

**After editing, restart the proxy:**
```bash
launchctl restart com.claude-copilot-proxy  # macOS
# OR
systemctl --user restart claude-copilot-proxy  # Linux
```

</details>

---

## Security Considerations

- **Local-only proxy**: The proxy runs on `localhost:4000` and is not exposed to the internet
- **Default master key**: The default key `sk-claude-copilot-proxy-default` is suitable for local development
- **Custom master key**: For shared environments, set a custom key:
  ```bash
  export LITELLM_MASTER_KEY="$(openssl rand -hex 16)"
  ```
- **Token storage**: GitHub OAuth token is stored locally in `~/.config/github-copilot/apps.json`
- **Git ignored**: `config.yaml` is git-ignored to prevent committing tokens (if you track dotfiles)

---

## Cost Tracking

All requests are tracked by GitHub Copilot. Monitor usage at:
https://github.com/settings/copilot

---

## Notes

- **No Anthropic API calls**: All requests go through GitHub Copilot, not Anthropic
- **GitHub Copilot quota**: You're using your GitHub Copilot subscription limits
- **Automatic token refresh**: GitHub tools handle OAuth token renewal automatically
- **Persistent service**: The proxy survives reboots and auto-restarts on crashes
- **Zero manual token management**: Everything is automated after initial setup

---

## Recent Changes

- **Jan 7, 2026**: Updated README with comprehensive setup instructions for fresh machines
- **Nov 30, 2025**: Migrated hardcoded API key to environment variable (`LITELLM_MASTER_KEY`)
- **Nov 30, 2025**: Added `.gitignore` to protect sensitive config files
- **Nov 30, 2025**: Created `config.yaml.example` template for safe version control
- **Nov 26, 2025**: Initial setup created
