#!/usr/bin/env bash
# lib/config.sh - Directory setup and shell configuration

PROXY_DIR="${PROXY_DIR:-$HOME/.claude-copilot-proxy}"
PROXY_PORT="${PROXY_PORT:-4000}"

# Add a line to shell config if not already present
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

# Configure shell environment variables
configure_shell() {
    echo -e "\n${BOLD:-}Configuring shell environment...${NC:-}"

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

    # Export in current shell
    export ANTHROPIC_BASE_URL="http://localhost:$PROXY_PORT"
    export ANTHROPIC_AUTH_TOKEN="fake-key"
}

# Setup proxy directory and copy config files
setup_directory() {
    echo -e "\n${BOLD:-}Setting up proxy configuration...${NC:-}"

    # Directory already exists (we're running from it)
    success "Proxy directory: $PROXY_DIR"

    # Ensure config.yaml exists (copy from example if needed)
    if [[ ! -f "$PROXY_DIR/config.yaml" ]] && [[ -f "$PROXY_DIR/config.yaml.example" ]]; then
        cp "$PROXY_DIR/config.yaml.example" "$PROXY_DIR/config.yaml"
        success "Created config.yaml from example"
    elif [[ -f "$PROXY_DIR/config.yaml" ]]; then
        success "config.yaml exists"
    else
        fatal "No config.yaml or config.yaml.example found"
    fi

    # Ensure bin scripts are executable
    chmod +x "$PROXY_DIR/bin/"*.sh 2>/dev/null || true

    success "Configuration files ready"
}
