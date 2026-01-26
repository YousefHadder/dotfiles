# Claude Code -> GitHub Copilot Proxy Setup

This setup routes Claude Code requests through GitHub Copilot, allowing you to use Claude Code's interface while leveraging your GitHub Copilot subscription.

## Quick Start (Automated)

```bash
# Run the interactive setup script
./bin/setup.sh

# Or for non-interactive setup
./bin/setup.sh --quiet
```

The setup script automatically:

- Detects your environment (macOS/Linux/Container)
- Installs dependencies (pipx, litellm, jq, prisma)
- Guides you through PAT creation and secure storage
- Configures shell environment variables
- Sets up auto-start service (launchd/systemd)
- Verifies the setup

To uninstall: `./bin/uninstall.sh`

---

## Architecture

```
Claude Code CLI
      │
      │ ANTHROPIC_BASE_URL=http://localhost:4000
      ▼
┌─────────────────────────────────────────────┐
│   LiteLLM Proxy (localhost:4000)            │
│   - Model routing with aliases              │
│   - Adds required Copilot headers           │
│   - PAT from Keychain/env var               │
└─────────────────────────────────────────────┘
      │
      │ GitHub PAT + Copilot headers
      ▼
┌─────────────────────────────────────────────┐
│   GitHub Copilot API                        │
│   - Claude, GPT, Gemini, Grok models        │
└─────────────────────────────────────────────┘
```

## Directory Structure

```
~/.claude-copilot-proxy/
├── config.yaml                 # LiteLLM routing config
├── config.yaml.example         # Template
├── README.md                   # This file
│
├── bin/                        # Executable scripts
│   ├── setup.sh                # Main installer
│   ├── start-proxy.sh          # Startup script
│   ├── update-models.sh        # Model sync script
│   └── uninstall.sh            # Uninstaller
│
├── lib/                        # Library modules
│   ├── common.sh               # Colors, logging, prompts
│   ├── detect.sh               # Platform detection
│   ├── config.sh               # Directory/shell config
│   │
│   ├── token/                  # Token management
│   │   ├── main.sh             # Dispatcher
│   │   ├── macos.sh            # macOS Keychain
│   │   ├── linux.sh            # GNOME Keyring
│   │   └── env.sh              # Environment variable
│   │
│   ├── deps/                   # Dependency installation
│   │   ├── main.sh             # Dispatcher
│   │   ├── brew.sh             # Homebrew
│   │   ├── apt.sh              # apt-get
│   │   └── pip.sh              # pip fallback
│   │
│   └── service/                # Service management
│       ├── main.sh             # Dispatcher
│       ├── launchd.sh          # macOS launchd
│       ├── systemd.sh          # Linux systemd
│       └── manual.sh           # Manual/container
│
└── test/                       # Test suite
    ├── run-tests.sh            # Main test runner
    ├── check-file.sh           # File existence tests
    ├── check-syntax.sh         # Bash syntax validation
    ├── check-command.sh        # Dependency checks
    ├── check-token.sh          # Token storage tests
    ├── check-token-api.sh      # API validation tests
    ├── check-env.sh            # Environment variable tests
    ├── check-port.sh           # Port listening tests
    ├── check-health.sh         # Proxy health tests
    └── check-model.sh          # Model request tests
```

## Supported Models

Last updated: 2026-01-26

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
| `gpt-5-codex`            | Azure OpenAI | versatile   |
| `gpt-5-mini`             | Azure OpenAI | lightweight |
| `gpt-5.1`                | Azure OpenAI | versatile   |
| `gpt-5.1-codex`          | Azure OpenAI | versatile   |
| `gpt-5.1-codex-max`      | Azure OpenAI | powerful    |
| `gpt-5.1-codex-mini`     | Azure OpenAI | lightweight |
| `gpt-5.2`                | Azure OpenAI | versatile   |
| `gpt-5.2-codex`          | Azure OpenAI | versatile   |
| `grok-code-fast-1`       | xAI          | lightweight |

Run `./bin/update-models.sh` to refresh this list from the Copilot API.

---

## Setup Instructions

### Prerequisites

1. **GitHub Copilot subscription** (Individual or Enterprise)
2. **macOS**, **Linux**, or **Container** (Codespaces, Docker, etc.)
3. **Python 3.9-3.13** (Python 3.14 has compatibility issues with uvloop)

### Automated Setup (Recommended)

```bash
./bin/setup.sh
```

Follow the interactive prompts. The script handles everything below automatically.

### Manual Setup

### Step 1: Install Required Tools

#### macOS (Homebrew)

```bash
# Install pipx (for isolated Python environments)
brew install pipx jq
pipx ensurepath

# Install LiteLLM with proxy dependencies (use Python 3.13, not 3.14)
pipx install --python /opt/homebrew/opt/python@3.13/bin/python3.13 'litellm[proxy]'

# Install prisma for auth handling
~/.local/pipx/venvs/litellm/bin/python3 -m pip install prisma
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
4. Copy the token (starts with `ghp_...` for classic tokens or `github_pat_...` for fine-grained tokens)

### Step 3: Store PAT Securely

#### Option A: Environment Variable (All platforms)

Add to your shell config (`~/.bashrc`, `~/.zshrc`, or Codespaces secrets):

```bash
export LITELLM_TOKEN="ghp_YOUR_TOKEN_HERE"
```

#### Option B: macOS Keychain

```bash
security add-generic-password -s "litellm-copilot-token" -a "$USER" -w "ghp_YOUR_TOKEN_HERE"
```

To verify:

```bash
security find-generic-password -s "litellm-copilot-token" -a "$USER" -w | head -c 10
# Should show: ghp_xxxxxx
```

#### Option C: Linux Secret Service (GNOME Keyring)

```bash
# Requires libsecret
sudo apt install -y libsecret-tools
secret-tool store --label="LiteLLM Copilot Token" service litellm-copilot-token username token <<< "ghp_YOUR_TOKEN"
```

### Step 4: Configure Environment Variables

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

### Step 5: Set Up Auto-Start Service

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
        <string>/Users/$USERNAME/.claude-copilot-proxy/bin/start-proxy.sh</string>
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
        <string>/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
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
ExecStart=%h/.claude-copilot-proxy/bin/start-proxy.sh
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
nohup ~/.claude-copilot-proxy/bin/start-proxy.sh > /tmp/claude-copilot-proxy.log 2>&1 &

# For Codespaces: add to .devcontainer/postStartCommand or ~/.bashrc
echo 'pgrep -f "litellm" || ~/.claude-copilot-proxy/bin/start-proxy.sh &' >> ~/.bashrc
```

### Step 6: Verify Setup

```bash
# Quick health check
curl http://localhost:4000/health

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

# Run the full test suite
./test/run-tests.sh
```

### Step 7: Use with Claude Code

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

| Action | Command                                                |
| ------ | ------------------------------------------------------ |
| Start  | `~/.claude-copilot-proxy/bin/start-proxy.sh &`         |
| Stop   | `pkill -f litellm` or `kill $(lsof -t -i:4000)`        |
| Status | `lsof -i :4000`                                        |
| Logs   | `tail -f /tmp/claude-copilot-proxy.log`                |

### Update Available Models

```bash
# Dry run (show what would change)
~/.claude-copilot-proxy/bin/update-models.sh --dry-run

# Update config.yaml with working models
~/.claude-copilot-proxy/bin/update-models.sh

# Restart proxy to pick up changes
# macOS:
launchctl kickstart -k gui/$(id -u)/com.claude-copilot-proxy
# Linux:
systemctl --user restart claude-copilot-proxy
# Containers:
kill $(lsof -t -i:4000) && ~/.claude-copilot-proxy/bin/start-proxy.sh &
```

---

## Running Tests

Verify your setup with the included test suite:

```bash
# Run all tests
./test/run-tests.sh

# Run quick tests (skip API calls)
./test/run-tests.sh --quick

# Run with detailed output
./test/run-tests.sh --verbose
```

The test suite checks:
- File structure and permissions
- Bash syntax for all scripts
- Dependencies (jq, curl, litellm)
- Token storage accessibility
- Environment variables
- Proxy port and health endpoint
- API token validation
- Model request through proxy

---

## Environment Variables

| Variable              | Default                    | Description                              |
| --------------------- | -------------------------- | ---------------------------------------- |
| `ANTHROPIC_BASE_URL`  | (none)                     | Must be set to `http://localhost:4000`   |
| `ANTHROPIC_AUTH_TOKEN`| (none)                     | Any value (e.g., `fake-key`)             |
| `LITELLM_TOKEN`       | (none)                     | GitHub PAT (fallback if not in Keychain) |
| `PROXY_PORT`          | `4000`                     | Port the proxy listens on                |
| `KEYCHAIN_SERVICE`    | `litellm-copilot-token`    | Keychain/secret-tool service name        |
| `LAUNCHD_LABEL`       | `com.claude-copilot-proxy` | macOS launchd service label              |
| `SYSTEMD_SERVICE`     | `claude-copilot-proxy`     | Linux systemd service name               |

---

## Troubleshooting

### PAT Not Found

#### macOS (Keychain)

```bash
# Check if entry exists
security find-generic-password -s "litellm-copilot-token" -a "$USER" 2>&1

# Re-add if missing (requires -a account parameter)
security add-generic-password -s "litellm-copilot-token" -a "$USER" -w "ghp_YOUR_TOKEN"

# Update existing token
security delete-generic-password -s "litellm-copilot-token" -a "$USER"
security add-generic-password -s "litellm-copilot-token" -a "$USER" -w "ghp_NEW_TOKEN"

# Also update the LiteLLM api-key.json
TOKEN=$(security find-generic-password -s "litellm-copilot-token" -a "$USER" -w)
cat > ~/.config/litellm/github_copilot/api-key.json << EOF
{
  "token": "$TOKEN",
  "expires_at": 4102444800,
  "endpoints": {"api": "https://api.githubcopilot.com"}
}
EOF
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
~/.claude-copilot-proxy/bin/start-proxy.sh

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

### "No connected db" or "prisma" Error

This happens when LiteLLM tries to validate API keys. Fix:

```bash
# Install prisma in litellm venv
~/.local/pipx/venvs/litellm/bin/python3 -m pip install prisma
```

Also ensure your `config.yaml` has:

```yaml
general_settings:
  allow_requests_on_db_unavailable: true
```

### Missing Copilot-Integration-Id Header

If you see `missing required Copilot-Integration-Id header`, ensure your `config.yaml` has `extra_headers` defined inside `litellm_params`:

```yaml
model_list:
  - model_name: "*"
    litellm_params:
      model: github_copilot/*
      api_key: os.environ/GITHUB_TOKEN
      extra_headers:
        Editor-Version: "vscode/1.95.0"
        Editor-Plugin-Version: "copilot-chat/0.22.4"
        Copilot-Integration-Id: "vscode-chat"
        Openai-Organization: "github-copilot"
        Openai-Intent: "conversation-panel"
        Copilot-Vision-Request: "true"
```

**Note:** Headers must be inside `litellm_params`, not in `router_settings`.

### Missing Module Errors (ModuleNotFoundError)

If the proxy fails with `ModuleNotFoundError` for packages like `backoff`, `fastapi_sso`, or `python-multipart`, install the missing proxy dependencies:

```bash
pip3 install --user --break-system-packages \
    backoff python-multipart fastapi-sso pyjwt httpx aiohttp
```

This commonly happens when:

- pipx fails to build `uvloop` (requires gcc) and falls back to pip
- The base `litellm` package is installed without the `[proxy]` extras

### uvloop Build Failures

If you see `gcc-12 not found` errors when installing `litellm[proxy]`, the environment lacks a C compiler. Solutions:

1. **Skip uvloop** (recommended for containers): The proxy works fine with asyncio
2. **Install gcc**: `sudo apt install build-essential` (if you have root)
3. **Use prebuilt wheel only**: `pip3 install --only-binary :all: uvloop`

---

## File Inventory

| File                       | Purpose                                     |
| -------------------------- | ------------------------------------------- |
| `bin/setup.sh`             | Automated interactive setup script          |
| `bin/start-proxy.sh`       | Startup script (fetches PAT, runs LiteLLM)  |
| `bin/update-models.sh`     | Syncs available models from Copilot API     |
| `bin/uninstall.sh`         | Remove proxy and all components             |
| `config.yaml`              | LiteLLM routing config with model aliases   |
| `config.yaml.example`      | Git-safe template (copy to config.yaml)     |
| `lib/`                     | Modular library code (token, deps, service) |
| `test/run-tests.sh`        | Test suite runner (--quick, --verbose)      |
| `README.md`                | This documentation                          |

---

## Security Notes

- **Local-only by default**: Proxy runs on port 4000. The default config binds to `0.0.0.0` for container compatibility; change to `127.0.0.1` in `config.yaml` if you want localhost-only access
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
security delete-generic-password -s "litellm-copilot-token" -a "$USER"

# 3. Add new token
security add-generic-password -s "litellm-copilot-token" -a "$USER" -w "ghp_NEW_TOKEN"

# 4. Update LiteLLM api-key.json
TOKEN=$(security find-generic-password -s "litellm-copilot-token" -a "$USER" -w)
cat > ~/.config/litellm/github_copilot/api-key.json << EOF
{"token": "$TOKEN", "expires_at": 4102444800, "endpoints": {"api": "https://api.githubcopilot.com"}}
EOF

# 5. Restart proxy
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

| Date         | Change                                                                     |
| ------------ | -------------------------------------------------------------------------- |
| Jan 26, 2026 | Fixed extra_headers location in config.yaml; added test suite docs        |
| Jan 25, 2026 | Refactored to modular structure (bin/ and lib/ directories)               |
| Jan 25, 2026 | Added setup.sh automated installer; fixed Keychain -a param; added prisma |
| Jan 24, 2026 | Added Linux, systemd, and container support; fixed config for PAT auth    |
| Jan 12, 2026 | Hybrid approach: PAT auth + wildcard config + update-models script        |
| Jan 7, 2026  | Comprehensive fresh machine setup guide                                   |
| Nov 30, 2025 | Environment variable migration                                            |
| Nov 26, 2025 | Initial setup                                                              |
