#!/bin/bash

# Claude Code → GitHub Copilot Proxy Startup Script

echo "Starting LiteLLM Proxy for Claude Code → GitHub Copilot..."
echo "========================================================="

# Set GitHub token
export GITHUB_TOKEN=$(gh auth token)

# Start the proxy server
cd ~/.claude-copilot-proxy
litellm --config config.yaml --port 4000 --host 0.0.0.0

# Note: This will run in the foreground. Press Ctrl+C to stop.
