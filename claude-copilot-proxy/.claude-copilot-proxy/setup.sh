#!/usr/bin/env bash

# setup.sh - Automated interactive setup for Claude Code → GitHub Copilot Proxy
#
# This script automates the 8-step setup process documented in README.md,
# detecting the environment and adapting accordingly.
#
# Usage:
#   ./setup.sh              # Interactive setup
#   ./setup.sh --uninstall  # Remove all components
#   ./setup.sh --quiet      # Non-interactive (use defaults)
#   ./setup.sh --help       # Show help
#
# Supported environments:
#   - macOS (Homebrew + launchd + Keychain)
#   - Linux (apt + systemd + env vars)
#   - Containers/Codespaces (pip + manual + env vars)

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

PROXY_DIR="$HOME/.claude-copilot-proxy"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROXY_PORT="${LITELLM_PORT:-4000}"
KEYCHAIN_SERVICE="litellm-copilot-token"
LAUNCHD_LABEL="com.claude-copilot-proxy"
SYSTEMD_SERVICE="claude-copilot-proxy"

# Token source (set by get_existing_token)
TOKEN_SOURCE=""

# Colors (with fallback for non-color terminals)
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' BOLD='' NC=''
fi

# Flags
QUIET=false
UNINSTALL=false

# Detected environment
OS=""
PKG_MANAGER=""
INIT_SYSTEM=""
SHELL_CONFIG=""
IS_CONTAINER=false

# =============================================================================
# Utility Functions
# =============================================================================

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[✓]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
fatal()   { error "$*"; exit 1; }

prompt_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    
    if $QUIET; then
        [[ "$default" == "y" ]]
        return
    fi
    
    local yn_hint="[Y/n]"
    [[ "$default" == "n" ]] && yn_hint="[y/N]"
    
    read -r -p "$prompt $yn_hint: " response
    response="${response:-$default}"
    [[ "$response" =~ ^[Yy] ]]
}

prompt_input() {
    local prompt="$1"
    local var_name="$2"
    local default="${3:-}"
    
    if $QUIET && [[ -n "$default" ]]; then
        eval "$var_name='$default'"
        return
    fi
    
    local hint=""
    [[ -n "$default" ]] && hint=" [$default]"
    
    read -r -p "$prompt$hint: " response
    response="${response:-$default}"
    eval "$var_name='$response'"
}

command_exists() {
    command -v "$1" &> /dev/null
}

# =============================================================================
# Environment Detection
# =============================================================================

detect_environment() {
    echo -e "\n${BOLD}Detecting environment...${NC}"
    
    # Detect OS
    case "$(uname -s)" in
        Darwin)
            OS="macos"
            ;;
        Linux)
            OS="linux"
            ;;
        *)
            fatal "Unsupported operating system: $(uname -s)"
            ;;
    esac
    
    # Detect if running in container
    if [[ -f /.dockerenv ]] || [[ -n "${CODESPACES:-}" ]] || [[ -n "${REMOTE_CONTAINERS:-}" ]]; then
        IS_CONTAINER=true
    fi
    
    # Detect package manager
    if command_exists brew; then
        PKG_MANAGER="brew"
    elif command_exists apt-get; then
        PKG_MANAGER="apt"
    else
        PKG_MANAGER="pip"
    fi
    
    # Detect init system
    if [[ "$OS" == "macos" ]]; then
        INIT_SYSTEM="launchd"
    elif $IS_CONTAINER; then
        INIT_SYSTEM="none"
    elif command_exists systemctl && systemctl --user status &>/dev/null; then
        INIT_SYSTEM="systemd"
    else
        INIT_SYSTEM="none"
    fi
    
    # Detect shell config file
    local shell_name
    shell_name=$(basename "${SHELL:-/bin/bash}")
    case "$shell_name" in
        zsh)  SHELL_CONFIG="$HOME/.zshrc" ;;
        bash) SHELL_CONFIG="$HOME/.bashrc" ;;
        *)    SHELL_CONFIG="$HOME/.profile" ;;
    esac
    
    # Summary
    echo "  OS:              $OS"
    echo "  Package manager: $PKG_MANAGER"
    echo "  Init system:     $INIT_SYSTEM"
    echo "  Shell config:    $SHELL_CONFIG"
    echo "  Container:       $IS_CONTAINER"
    success "Environment detected"
}

# =============================================================================
# Step 1: Install Dependencies
# =============================================================================

install_dependencies() {
    echo -e "\n${BOLD}[1/6] Installing dependencies...${NC}"
    
    # Install jq
    if ! command_exists jq; then
        info "Installing jq..."
        case "$PKG_MANAGER" in
            brew) brew install jq ;;
            apt)  sudo apt-get update && sudo apt-get install -y jq ;;
            pip)  warn "Please install jq manually: sudo apt install jq" ;;
        esac
    else
        success "jq already installed"
    fi
    
    # Install litellm
    if ! command_exists litellm; then
        info "Installing litellm..."
        
        case "$PKG_MANAGER" in
            brew|apt)
                # Install pipx first
                if ! command_exists pipx; then
                    info "Installing pipx..."
                    case "$PKG_MANAGER" in
                        brew) brew install pipx ;;
                        apt)  sudo apt-get update && sudo apt-get install -y pipx ;;
                    esac
                    pipx ensurepath
                    export PATH="$HOME/.local/bin:$PATH"
                fi
                
                info "Installing litellm with pipx..."
                pipx install 'litellm[proxy]' || {
                    warn "pipx install failed, trying pip fallback..."
                    pip3 install --user litellm fastapi uvicorn orjson apscheduler cryptography
                }
                
                # Install prisma for auth handling
                info "Installing prisma..."
                "$HOME/.local/pipx/venvs/litellm/bin/python3" -m pip install prisma 2>/dev/null || true
                ;;
            pip)
                info "Installing litellm with pip (container mode)..."
                pip3 install --user --break-system-packages litellm fastapi uvicorn orjson \
                    apscheduler cryptography email-validator websockets prisma 2>/dev/null || \
                pip3 install --user litellm fastapi uvicorn orjson apscheduler cryptography prisma
                
                # Try uvloop if available as wheel
                pip3 install --user --only-binary :all: uvloop 2>/dev/null || true
                ;;
        esac
        
        export PATH="$HOME/.local/bin:$PATH"
    else
        success "litellm already installed"
    fi
    
    # Verify installation
    if command_exists litellm; then
        success "Dependencies installed (litellm $(litellm --version 2>/dev/null || echo 'version unknown'))"
    else
        fatal "Failed to install litellm. Please install manually."
    fi
}

# =============================================================================
# Step 2: Setup GitHub PAT
# =============================================================================

get_existing_token() {
    local token=""
    TOKEN_SOURCE=""
    
    # Try macOS Keychain
    if [[ "$OS" == "macos" ]] && command_exists security; then
        token=$(security find-generic-password -s "$KEYCHAIN_SERVICE" -a "$USER" -w 2>/dev/null) || true
        if [[ -n "$token" ]]; then
            TOKEN_SOURCE="macOS Keychain"
        fi
    fi
    
    # Try Linux secret-tool
    if [[ -z "$token" ]] && command_exists secret-tool; then
        token=$(secret-tool lookup service "$KEYCHAIN_SERVICE" username token 2>/dev/null) || true
        if [[ -n "$token" ]]; then
            TOKEN_SOURCE="GNOME Keyring"
        fi
    fi
    
    # Try environment variable
    if [[ -z "$token" ]] && [[ -n "${LITELLM_TOKEN:-}" ]]; then
        token="$LITELLM_TOKEN"
        TOKEN_SOURCE="environment variable (LITELLM_TOKEN)"
    fi
    
    echo "$token"
}

verify_token_storage() {
    local token="$1"
    local source="$2"
    
    info "Verifying token exists in $source..."
    
    case "$source" in
        "macOS Keychain")
            if security find-generic-password -s "$KEYCHAIN_SERVICE" -a "$USER" &>/dev/null; then
                success "Token verified in macOS Keychain"
                return 0
            else
                error "Token not found in macOS Keychain"
                return 1
            fi
            ;;
        "GNOME Keyring")
            if secret-tool lookup service "$KEYCHAIN_SERVICE" username token &>/dev/null; then
                success "Token verified in GNOME Keyring"
                return 0
            else
                error "Token not found in GNOME Keyring"
                return 1
            fi
            ;;
        "environment variable (LITELLM_TOKEN)")
            if [[ -n "${LITELLM_TOKEN:-}" ]]; then
                success "Token verified in environment variable"
                return 0
            else
                error "LITELLM_TOKEN environment variable not set"
                return 1
            fi
            ;;
        *)
            warn "Unknown token source: $source"
            return 1
            ;;
    esac
}

store_token() {
    local token="$1"
    
    if [[ "$OS" == "macos" ]] && command_exists security; then
        # Delete existing entry if present
        security delete-generic-password -s "$KEYCHAIN_SERVICE" -a "$USER" 2>/dev/null || true
        # Store new token (requires -a account and -s service)
        security add-generic-password -s "$KEYCHAIN_SERVICE" -a "$USER" -w "$token"
        success "Token stored in macOS Keychain"
    elif command_exists secret-tool && ! $IS_CONTAINER; then
        # Linux with GNOME Keyring
        echo "$token" | secret-tool store --label="LiteLLM Copilot Token" service "$KEYCHAIN_SERVICE" username token
        success "Token stored in GNOME Keyring"
    else
        # Fall back to environment variable in shell config
        add_to_shell_config "export LITELLM_TOKEN=\"$token\""
        success "Token stored in $SHELL_CONFIG"
    fi
    
    # Create LiteLLM api-key.json for GitHub Copilot auth
    create_litellm_api_key_file "$token"
}

create_litellm_api_key_file() {
    local token="$1"
    local litellm_config_dir="$HOME/.config/litellm/github_copilot"
    
    mkdir -p "$litellm_config_dir"
    
    # Create api-key.json with token and Copilot API endpoint
    cat > "$litellm_config_dir/api-key.json" << EOF
{
  "token": "$token",
  "expires_at": 4102444800,
  "endpoints": {
    "api": "https://api.githubcopilot.com"
  }
}
EOF
    
    success "Created LiteLLM api-key.json"
}

validate_token() {
    local token="$1"
    
    if [[ ! "$token" =~ ^(ghp_|github_pat_) ]]; then
        warn "Token doesn't start with 'ghp_' or 'github_pat_'. This may not be a valid GitHub PAT."
        return 1
    fi
    
    # Test the token
    info "Validating token with GitHub API..."
    local response
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $token" \
        -H "Editor-Version: vscode/1.95.0" \
        -H "Copilot-Integration-Id: vscode-chat" \
        "https://api.githubcopilot.com/models" 2>/dev/null) || true
    
    local http_code
    http_code=$(echo "$response" | tail -n1)
    
    if [[ "$http_code" == "200" ]]; then
        success "Token validated successfully"
        return 0
    else
        error "Token validation failed (HTTP $http_code)"
        return 1
    fi
}

setup_pat() {
    echo -e "\n${BOLD}[2/6] Setting up GitHub PAT...${NC}"
    
    # Check for existing token
    local existing_token
    existing_token=$(get_existing_token)
    
    if [[ -n "$existing_token" ]]; then
        info "Found existing token in $TOKEN_SOURCE"
        
        # Verify the token actually exists in storage
        if verify_token_storage "$existing_token" "$TOKEN_SOURCE"; then
            # Validate token works with API
            if validate_token "$existing_token"; then
                if prompt_yes_no "Use existing token from $TOKEN_SOURCE?"; then
                    success "Using existing token from $TOKEN_SOURCE"
                    return 0
                else
                    existing_token=""
                fi
            else
                warn "Existing token is invalid (API check failed)"
                existing_token=""
            fi
        else
            warn "Token storage verification failed"
            existing_token=""
        fi
    fi
    
    if [[ -z "$existing_token" ]]; then
        # Show instructions for creating PAT
        local pat_url="https://github.com/settings/tokens/new?scopes=copilot&description=LiteLLM%20Copilot%20Proxy"
        
        echo ""
        echo "  Create a GitHub PAT with 'copilot' scope:"
        echo ""
        echo "  $pat_url"
        echo ""
        echo "  1. Set expiration (90 days recommended)"
        echo "  2. Ensure 'copilot' scope is checked"
        echo "  3. Click 'Generate token'"
        echo "  4. Copy the token (starts with ghp_...)"
        echo ""
        
        local new_token=""
        while [[ -z "$new_token" ]]; do
            read -r -s -p "Paste your token: " new_token
            echo ""
            
            if [[ -z "$new_token" ]]; then
                error "Token cannot be empty"
                continue
            fi
            
            if ! validate_token "$new_token"; then
                if ! prompt_yes_no "Token validation failed. Store anyway?"; then
                    new_token=""
                fi
            fi
        done
        
        store_token "$new_token"
    fi
}

# =============================================================================
# Step 3: Directory and File Setup
# =============================================================================

setup_directory() {
    echo -e "\n${BOLD}[3/6] Setting up proxy configuration...${NC}"
    
    # Create directory
    mkdir -p "$PROXY_DIR"
    success "Created $PROXY_DIR"
    
    # Copy files from script directory (or create from templates)
    local files=("config.yaml" "start-proxy.sh" "update-models")
    
    for file in "${files[@]}"; do
        local src="$SCRIPT_DIR/$file"
        local example_src="$SCRIPT_DIR/${file}.example"
        local dest="$PROXY_DIR/$file"
        
        # Skip if destination is same as source (but handle config.yaml special case)
        if [[ "$(realpath "$PROXY_DIR" 2>/dev/null)" == "$(realpath "$SCRIPT_DIR" 2>/dev/null)" ]]; then
            # Even in same directory, ensure config.yaml exists from example
            if [[ "$file" == "config.yaml" ]] && [[ ! -f "$dest" ]] && [[ -f "$example_src" ]]; then
                cp "$example_src" "$dest"
                success "Created $file from example"
            fi
            continue
        fi
        
        if [[ -f "$src" ]]; then
            # Backup existing file
            [[ -f "$dest" ]] && cp "$dest" "${dest}.backup.$(date +%s)"
            cp "$src" "$dest"
            success "Copied $file"
        elif [[ -f "$example_src" ]]; then
            [[ -f "$dest" ]] && cp "$dest" "${dest}.backup.$(date +%s)"
            cp "$example_src" "$dest"
            success "Copied $file from example"
        fi
    done
    
    # Make scripts executable
    chmod +x "$PROXY_DIR/start-proxy.sh" 2>/dev/null || true
    chmod +x "$PROXY_DIR/update-models" 2>/dev/null || true
    
    # Update start-proxy.sh for portability
    if [[ -f "$PROXY_DIR/start-proxy.sh" ]]; then
        update_start_proxy_script
    fi
    
    success "Configuration files installed"
}

update_start_proxy_script() {
    local script="$PROXY_DIR/start-proxy.sh"
    local tmp_script
    tmp_script=$(mktemp)
    
    cat > "$tmp_script" << 'SCRIPT_EOF'
#!/bin/bash
# Claude Code -> GitHub Copilot Proxy Startup Script
# Cross-platform (macOS, Linux, Containers)

set -euo pipefail

# Add common paths
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

# Get GitHub token
get_token() {
    local token=""

    # Try macOS Keychain (with account first, then legacy without account)
    if command -v security &>/dev/null; then
        token=$(security find-generic-password -s "litellm-copilot-token" -a "$USER" -w 2>/dev/null) || true
        # Fallback: try without account for legacy tokens
        if [[ -z "$token" ]]; then
            token=$(security find-generic-password -s "litellm-copilot-token" -w 2>/dev/null) || true
        fi
    fi

    # Try Linux secret-tool
    if [[ -z "$token" ]] && command -v secret-tool &>/dev/null; then
        token=$(secret-tool lookup service "litellm-copilot-token" username token 2>/dev/null) || true
    fi

    # Try environment variable
    if [[ -z "$token" ]]; then
        token="${LITELLM_TOKEN:-}"
    fi

    echo "$token"
}

GITHUB_TOKEN=$(get_token)
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Error: GitHub PAT not found"
    echo "Options:"
    echo "  macOS:   security add-generic-password -s \"litellm-copilot-token\" -w \"ghp_YOUR_TOKEN\""
    echo "  Linux:   secret-tool store --label=\"LiteLLM Copilot Token\" service litellm-copilot-token username token"
    echo "  Any:     export LITELLM_TOKEN=\"ghp_YOUR_TOKEN\""
    exit 1
fi
# Export token for LiteLLM GitHub Copilot provider (it checks multiple env vars)
export GITHUB_TOKEN
export COPILOT_GITHUB_TOKEN="$GITHUB_TOKEN"
export GITHUB_API_KEY="$GITHUB_TOKEN"

# Config and port
PROXY_DIR="${HOME}/.claude-copilot-proxy"
CONFIG_FILE="${PROXY_DIR}/config.yaml"
PORT="${LITELLM_PORT:-4000}"

# Disable uvloop (not compatible with Python 3.14)
export UVICORN_LOOP="asyncio"

# Find litellm binary
LITELLM_BIN=""
for path in "$HOME/.local/bin/litellm" "/opt/homebrew/bin/litellm" "/usr/local/bin/litellm" "$(which litellm 2>/dev/null)"; do
    if [[ -x "$path" ]]; then
        LITELLM_BIN="$path"
        break
    fi
done

if [[ -z "$LITELLM_BIN" ]]; then
    echo "Error: litellm not found in PATH"
    exit 1
fi

echo "Starting LiteLLM proxy on port $PORT..."
echo "Config: $CONFIG_FILE"

exec "$LITELLM_BIN" \
    --config "$CONFIG_FILE" \
    --port "$PORT" \
    --host 0.0.0.0
SCRIPT_EOF
    
    mv "$tmp_script" "$script"
    chmod +x "$script"
}

# =============================================================================
# Step 4: Shell Configuration
# =============================================================================

add_to_shell_config() {
    local line="$1"
    
    # Skip if already present
    if grep -qF "$line" "$SHELL_CONFIG" 2>/dev/null; then
        return 0
    fi
    
    # Add marker comment and line
    echo "" >> "$SHELL_CONFIG"
    echo "# Claude Code -> GitHub Copilot Proxy" >> "$SHELL_CONFIG"
    echo "$line" >> "$SHELL_CONFIG"
}

configure_shell() {
    echo -e "\n${BOLD}[4/6] Configuring shell environment...${NC}"
    
    local changes_made=false
    
    # Add ANTHROPIC_BASE_URL
    if ! grep -q "ANTHROPIC_BASE_URL" "$SHELL_CONFIG" 2>/dev/null; then
        add_to_shell_config "export ANTHROPIC_BASE_URL=\"http://localhost:$PROXY_PORT\""
        changes_made=true
    fi
    
    # Add ANTHROPIC_AUTH_TOKEN
    if ! grep -q "ANTHROPIC_AUTH_TOKEN" "$SHELL_CONFIG" 2>/dev/null; then
        add_to_shell_config "export ANTHROPIC_AUTH_TOKEN=\"fake-key\""
        changes_made=true
    fi
    
    if $changes_made; then
        success "Added environment variables to $SHELL_CONFIG"
    else
        success "Environment variables already configured"
    fi
    
    # Source the config in current shell
    export ANTHROPIC_BASE_URL="http://localhost:$PROXY_PORT"
    export ANTHROPIC_AUTH_TOKEN="fake-key"
}

# =============================================================================
# Step 5: Auto-Start Service
# =============================================================================

setup_launchd() {
    local plist_dir="$HOME/Library/LaunchAgents"
    local plist_file="$plist_dir/$LAUNCHD_LABEL.plist"
    local username
    username=$(whoami)
    
    mkdir -p "$plist_dir"
    
    cat > "$plist_file" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LAUNCHD_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$PROXY_DIR/start-proxy.sh</string>
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
    
    # Unload if already loaded
    launchctl unload "$plist_file" 2>/dev/null || true
    
    # Load and start
    launchctl load "$plist_file"
    launchctl start "$LAUNCHD_LABEL"
    
    success "launchd service installed and started"
}

setup_systemd() {
    local service_dir="$HOME/.config/systemd/user"
    local service_file="$service_dir/$SYSTEMD_SERVICE.service"
    
    mkdir -p "$service_dir"
    
    cat > "$service_file" << EOF
[Unit]
Description=Claude Code -> GitHub Copilot Proxy
After=network.target

[Service]
Type=simple
Environment="LITELLM_TOKEN=${LITELLM_TOKEN:-}"
ExecStart=$PROXY_DIR/start-proxy.sh
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
EOF
    
    systemctl --user daemon-reload
    systemctl --user enable "$SYSTEMD_SERVICE"
    systemctl --user start "$SYSTEMD_SERVICE"
    
    success "systemd service installed and started"
}

setup_manual_start() {
    local bashrc_line="pgrep -f \"litellm\" > /dev/null || $PROXY_DIR/start-proxy.sh &"
    
    if ! grep -qF "start-proxy.sh" "$SHELL_CONFIG" 2>/dev/null; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Auto-start Claude Copilot Proxy" >> "$SHELL_CONFIG"
        echo "$bashrc_line" >> "$SHELL_CONFIG"
        success "Added auto-start to $SHELL_CONFIG"
    else
        success "Auto-start already configured"
    fi
}

setup_autostart() {
    echo -e "\n${BOLD}[5/6] Setting up auto-start service...${NC}"
    
    if ! prompt_yes_no "Enable auto-start on login?"; then
        info "Skipping auto-start setup"
        return
    fi
    
    case "$INIT_SYSTEM" in
        launchd)
            setup_launchd
            ;;
        systemd)
            setup_systemd
            ;;
        none)
            setup_manual_start
            ;;
    esac
}

# =============================================================================
# Step 6: Verification
# =============================================================================

verify_setup() {
    echo -e "\n${BOLD}[6/6] Verifying setup...${NC}"
    
    # Start proxy if not running
    if ! lsof -i ":$PROXY_PORT" &>/dev/null; then
        info "Starting proxy..."
        nohup "$PROXY_DIR/start-proxy.sh" > /tmp/claude-copilot-proxy.log 2>&1 &
        
        # Wait for startup
        local attempts=0
        while ! lsof -i ":$PROXY_PORT" &>/dev/null && [[ $attempts -lt 10 ]]; do
            sleep 1
            ((attempts++))
        done
    fi
    
    # Check if running
    if lsof -i ":$PROXY_PORT" &>/dev/null; then
        success "Proxy running on port $PROXY_PORT"
    else
        error "Proxy failed to start"
        echo "Check logs: tail -f /tmp/claude-copilot-proxy.log"
        return 1
    fi
    
    # Health check
    if curl -s "http://localhost:$PROXY_PORT/health" &>/dev/null; then
        success "Health check passed"
    else
        warn "Health check returned error (proxy may still be starting)"
    fi
    
    # Model test
    info "Testing API with claude-sonnet-4..."
    local test_response
    test_response=$(curl -s -X POST "http://localhost:$PROXY_PORT/chat/completions" \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer fake-key' \
        -d '{"model": "claude-sonnet-4", "messages": [{"role": "user", "content": "Say hello in one word"}], "max_tokens": 10}' \
        --max-time 30 2>/dev/null) || true
    
    if echo "$test_response" | grep -q "choices"; then
        success "Model test passed"
    else
        warn "Model test inconclusive (proxy may need more time)"
    fi
}

# =============================================================================
# Uninstall
# =============================================================================

uninstall() {
    echo -e "\n${BOLD}Uninstalling Claude Code → GitHub Copilot Proxy...${NC}"
    
    # Stop services
    case "$INIT_SYSTEM" in
        launchd)
            launchctl stop "$LAUNCHD_LABEL" 2>/dev/null || true
            launchctl unload "$HOME/Library/LaunchAgents/$LAUNCHD_LABEL.plist" 2>/dev/null || true
            rm -f "$HOME/Library/LaunchAgents/$LAUNCHD_LABEL.plist"
            success "Removed launchd service"
            ;;
        systemd)
            systemctl --user stop "$SYSTEMD_SERVICE" 2>/dev/null || true
            systemctl --user disable "$SYSTEMD_SERVICE" 2>/dev/null || true
            rm -f "$HOME/.config/systemd/user/$SYSTEMD_SERVICE.service"
            systemctl --user daemon-reload
            success "Removed systemd service"
            ;;
    esac
    
    # Kill running proxy
    local pid
    pid=$(lsof -t -i ":$PROXY_PORT" 2>/dev/null) || true
    if [[ -n "$pid" ]]; then
        kill "$pid" 2>/dev/null || true
        success "Stopped proxy process"
    fi
    
    # Remove Keychain entry (macOS)
    if [[ "$OS" == "macos" ]] && command_exists security; then
        security delete-generic-password -s "$KEYCHAIN_SERVICE" -a "$USER" 2>/dev/null || true
        success "Removed Keychain entry"
    fi
    
    # Ask about removing directory
    if [[ -d "$PROXY_DIR" ]]; then
        if prompt_yes_no "Remove $PROXY_DIR?"; then
            rm -rf "$PROXY_DIR"
            success "Removed proxy directory"
        fi
    fi
    
    # Note about shell config
    echo ""
    warn "Manual cleanup needed in $SHELL_CONFIG:"
    echo "  Remove lines containing:"
    echo "    - ANTHROPIC_BASE_URL"
    echo "    - ANTHROPIC_AUTH_TOKEN"
    echo "    - LITELLM_TOKEN"
    echo "    - start-proxy.sh"
    
    echo ""
    success "Uninstall complete"
}

# =============================================================================
# Main
# =============================================================================

show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Automated setup for Claude Code → GitHub Copilot Proxy"
    echo ""
    echo "Options:"
    echo "  --help        Show this help message"
    echo "  --uninstall   Remove all proxy components"
    echo "  --quiet       Non-interactive mode (use defaults)"
    echo ""
    echo "For more information, see README.md"
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --uninstall)
                UNINSTALL=true
                ;;
            --quiet|-q)
                QUIET=true
                ;;
            *)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
    
    # Header
    echo ""
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  Claude Code → GitHub Copilot Proxy Setup                 ║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    
    detect_environment
    
    if $UNINSTALL; then
        uninstall
        exit 0
    fi
    
    install_dependencies
    setup_pat
    setup_directory
    configure_shell
    setup_autostart
    verify_setup
    
    # Success message
    echo ""
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  Setup complete!                                          ║${NC}"
    echo -e "${BOLD}║  Open a new terminal and run: ${GREEN}claude${NC}${BOLD}                       ║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Useful commands:"
    echo "  Logs:    tail -f /tmp/claude-copilot-proxy.log"
    echo "  Update:  ~/.claude-copilot-proxy/update-models"
    echo ""
}

main "$@"
