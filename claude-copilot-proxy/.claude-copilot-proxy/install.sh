#!/bin/bash
# Claude Code → GitHub Copilot Proxy Installation Script
# This script automates the setup process described in README.md

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

prompt() {
    echo -e "${YELLOW}?${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    else
        error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect shell
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_TYPE="zsh"
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_TYPE="bash"
        SHELL_RC="$HOME/.bashrc"
    elif [ -n "$FISH_VERSION" ]; then
        SHELL_TYPE="fish"
        SHELL_RC="$HOME/.config/fish/config.fish"
    else
        # Try to detect from SHELL variable
        case "$SHELL" in
            */zsh)
                SHELL_TYPE="zsh"
                SHELL_RC="$HOME/.zshrc"
                ;;
            */bash)
                SHELL_TYPE="bash"
                SHELL_RC="$HOME/.bashrc"
                ;;
            */fish)
                SHELL_TYPE="fish"
                SHELL_RC="$HOME/.config/fish/config.fish"
                ;;
            *)
                SHELL_TYPE="bash"
                SHELL_RC="$HOME/.bashrc"
                warning "Could not detect shell, defaulting to bash"
                ;;
        esac
    fi
}

# Print banner
print_banner() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║   Claude Code → GitHub Copilot Proxy Installer              ║"
    echo "║   Use Claude Code with your GitHub Copilot subscription     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    info "Checking prerequisites..."

    local missing_deps=()

    # Check for package manager
    if [[ "$OS" == "macos" ]]; then
        if ! command_exists brew; then
            error "Homebrew is not installed. Please install it from https://brew.sh"
            exit 1
        fi
        success "Homebrew found"
    elif [[ "$OS" == "linux" ]]; then
        if ! command_exists apt && ! command_exists yum && ! command_exists dnf; then
            error "No supported package manager found (apt/yum/dnf)"
            exit 1
        fi
        success "Package manager found"
    fi
}

# Install dependencies
install_dependencies() {
    info "Installing required dependencies..."

    # Install pipx
    if ! command_exists pipx; then
        info "Installing pipx..."
        if [[ "$OS" == "macos" ]]; then
            brew install pipx
        else
            sudo apt install -y pipx || sudo yum install -y pipx || sudo dnf install -y pipx
        fi
        pipx ensurepath
        success "pipx installed"
    else
        success "pipx already installed"
    fi

    # Install GitHub CLI
    if ! command_exists gh; then
        info "Installing GitHub CLI..."
        if [[ "$OS" == "macos" ]]; then
            brew install gh
        else
            # For Ubuntu/Debian
            if command_exists apt; then
                type -p curl >/dev/null || sudo apt install curl -y
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                sudo apt install gh -y
            else
                sudo yum install gh -y || sudo dnf install gh -y
            fi
        fi
        success "GitHub CLI installed"
    else
        success "GitHub CLI already installed"
    fi

    # Install jq
    if ! command_exists jq; then
        info "Installing jq..."
        if [[ "$OS" == "macos" ]]; then
            brew install jq
        else
            sudo apt install -y jq || sudo yum install -y jq || sudo dnf install -y jq
        fi
        success "jq installed"
    else
        success "jq already installed"
    fi

    # Install LiteLLM
    if ! command_exists litellm; then
        info "Installing LiteLLM..."
        pipx install litellm
        success "LiteLLM installed"
    else
        success "LiteLLM already installed"
    fi
}

# Authenticate with GitHub
authenticate_github() {
    info "Checking GitHub authentication..."

    if gh auth status >/dev/null 2>&1; then
        success "Already authenticated with GitHub"

        # Check if Copilot token exists
        if [ -f "$HOME/.config/github-copilot/apps.json" ]; then
            local token=$(jq -r '.[].oauth_token // empty' "$HOME/.config/github-copilot/apps.json" 2>/dev/null | head -1)
            if [ -n "$token" ]; then
                success "GitHub Copilot token found"
                return 0
            fi
        fi

        warning "GitHub Copilot token not found in ~/.config/github-copilot/apps.json"
        prompt "Would you like to re-authenticate to get the Copilot token? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            gh auth login
        else
            warning "Continuing without re-authentication. You may need to authenticate via VSCode with GitHub Copilot extension."
        fi
    else
        info "Please authenticate with GitHub..."
        gh auth login
    fi

    # Verify Copilot access
    if gh api /user/copilot >/dev/null 2>&1; then
        success "GitHub Copilot access verified"
    else
        warning "Could not verify GitHub Copilot access. Make sure you have an active subscription."
    fi
}

# Create directory structure
create_directories() {
    info "Creating directory structure..."

    mkdir -p "$HOME/.claude-copilot-proxy"
    mkdir -p "$HOME/.config/litellm/github_copilot"

    success "Directories created"
}

# Create startup script
create_startup_script() {
    info "Creating startup script..."

    cat > "$HOME/.claude-copilot-proxy/start-proxy.sh" << 'EOF'
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

    chmod +x "$HOME/.claude-copilot-proxy/start-proxy.sh"
    success "Startup script created"
}

# Create config file
create_config_file() {
    info "Creating configuration file..."

    cat > "$HOME/.claude-copilot-proxy/config.yaml" << 'EOF'
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

    success "Configuration file created"
}

# Configure environment variables
configure_env_vars() {
    info "Configuring environment variables..."

    local env_config='
# Claude Code → GitHub Copilot Proxy Configuration
export ANTHROPIC_BASE_URL="http://localhost:4000"
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"
export ANTHROPIC_AUTH_TOKEN="${LITELLM_MASTER_KEY}"
# Note: Only set AUTH_TOKEN, not API_KEY, to avoid auth conflict'

    local fish_config='
# Claude Code → GitHub Copilot Proxy Configuration
set -gx ANTHROPIC_BASE_URL "http://localhost:4000"
set -gx LITELLM_MASTER_KEY "sk-claude-copilot-proxy-default"
set -gx ANTHROPIC_AUTH_TOKEN "$LITELLM_MASTER_KEY"'

    # Check if already configured
    if grep -q "ANTHROPIC_BASE_URL" "$SHELL_RC" 2>/dev/null; then
        warning "Environment variables already configured in $SHELL_RC"
        return 0
    fi

    if [[ "$SHELL_TYPE" == "fish" ]]; then
        echo "$fish_config" >> "$SHELL_RC"
    else
        echo "$env_config" >> "$SHELL_RC"
    fi

    success "Environment variables added to $SHELL_RC"
    warning "You'll need to restart your terminal or run: source $SHELL_RC"
}

# Setup auto-start service
setup_autostart() {
    info "Setting up auto-start service..."

    if [[ "$OS" == "macos" ]]; then
        setup_launchd
    else
        setup_systemd
    fi
}

# Setup launchd (macOS)
setup_launchd() {
    local plist_path="$HOME/Library/LaunchAgents/com.claude-copilot-proxy.plist"

    if [ -f "$plist_path" ]; then
        warning "LaunchAgent already exists. Unloading existing service..."
        launchctl unload "$plist_path" 2>/dev/null || true
    fi

    cat > "$plist_path" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude-copilot-proxy</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.claude-copilot-proxy/start-proxy.sh</string>
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

    launchctl load "$plist_path"
    launchctl start com.claude-copilot-proxy

    success "LaunchAgent installed and started"
}

# Setup systemd (Linux)
setup_systemd() {
    local service_path="$HOME/.config/systemd/user/claude-copilot-proxy.service"

    mkdir -p "$HOME/.config/systemd/user"

    if [ -f "$service_path" ]; then
        warning "Systemd service already exists. Stopping existing service..."
        systemctl --user stop claude-copilot-proxy 2>/dev/null || true
    fi

    cat > "$service_path" << EOF
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

    systemctl --user daemon-reload
    systemctl --user enable claude-copilot-proxy
    systemctl --user start claude-copilot-proxy

    success "Systemd service installed and started"
}

# Verify installation
verify_installation() {
    info "Verifying installation..."

    # Wait a moment for service to start
    sleep 2

    # Check if port 4000 is listening
    if lsof -i :4000 >/dev/null 2>&1 || netstat -tuln 2>/dev/null | grep -q ":4000 "; then
        success "Proxy is running on port 4000"
    else
        error "Proxy is not running on port 4000"
        warning "Check logs: tail -f /tmp/claude-copilot-proxy.log"
        return 1
    fi

    # Check if token was synced
    if [ -f "$HOME/.config/litellm/github_copilot/access-token" ]; then
        success "GitHub Copilot token synced"
    else
        warning "GitHub Copilot token not found. You may need to authenticate via VSCode with GitHub Copilot extension."
    fi

    # Test the proxy
    info "Testing proxy connection..."
    local test_response=$(curl -s -X POST http://localhost:4000/v1/messages \
        -H 'Content-Type: application/json' \
        -H "x-api-key: sk-claude-copilot-proxy-default" \
        -d '{"model": "claude-3-5-haiku-20241022", "max_tokens": 10, "messages": [{"role": "user", "content": "Hi"}]}' 2>&1)

    if echo "$test_response" | grep -q "content\|error"; then
        success "Proxy test successful"
    else
        warning "Proxy test had unexpected response. Check logs for details."
    fi
}

# Print next steps
print_next_steps() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Installation Complete!                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Claude Code → GitHub Copilot Proxy is now installed and running!"
    echo ""
    info "Next steps:"
    echo "  1. Restart your terminal or run: source $SHELL_RC"
    echo "  2. Launch Claude Code: claude"
    echo "  3. All requests will now route through GitHub Copilot!"
    echo ""
    info "Useful commands:"
    if [[ "$OS" == "macos" ]]; then
        echo "  • Check status:  launchctl list | grep claude"
        echo "  • View logs:     tail -f /tmp/claude-copilot-proxy.log"
        echo "  • Stop proxy:    launchctl stop com.claude-copilot-proxy"
        echo "  • Start proxy:   launchctl start com.claude-copilot-proxy"
    else
        echo "  • Check status:  systemctl --user status claude-copilot-proxy"
        echo "  • View logs:     journalctl --user -u claude-copilot-proxy -f"
        echo "  • Stop proxy:    systemctl --user stop claude-copilot-proxy"
        echo "  • Start proxy:   systemctl --user start claude-copilot-proxy"
    fi
    echo ""
    info "Documentation: ~/.claude-copilot-proxy/README.md"
    info "Track usage: https://github.com/settings/copilot"
    echo ""
}

# Main installation flow
main() {
    print_banner

    detect_os
    detect_shell

    info "Detected OS: $OS"
    info "Detected shell: $SHELL_TYPE ($SHELL_RC)"
    echo ""

    check_prerequisites
    install_dependencies
    authenticate_github
    create_directories
    create_startup_script
    create_config_file
    configure_env_vars
    setup_autostart
    verify_installation
    print_next_steps
}

# Run main function
main "$@"
