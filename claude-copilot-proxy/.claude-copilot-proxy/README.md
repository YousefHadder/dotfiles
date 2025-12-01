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

## Starting the Proxy

### Option 1: Using the alias (Easiest)
```bash
claude-proxy
```

### Option 2: Using the startup script directly
```bash
~/.claude-copilot-proxy/start-proxy.sh
```

### Option 3: Manual start
```bash
export GITHUB_TOKEN=$(gh auth token)
litellm --config ~/.claude-copilot-proxy/config.yaml --port 4000 --host 0.0.0.0
```

The proxy must be running before you start Claude Code.

## Using Claude Code with the Proxy

1. **Start the proxy** (see above)
2. **Open a new terminal** to pick up the environment variables
3. **Launch Claude Code** as normal

All Claude Code requests will now automatically route through GitHub Copilot!

## Testing the Proxy

Test the proxy is working:

```bash
curl -X POST http://localhost:4000/v1/messages \
  -H 'Content-Type: application/json' \
  -H "x-api-key: ${LITELLM_MASTER_KEY}" \
  -d '{"model": "claude-3-5-haiku-20241022", "max_tokens": 100, "messages": [{"role": "user", "content": "Say hello"}]}'
```

You should get a response from Claude Haiku 4.5.

## Environment Variables

These are configured in `~/dotfiles/zsh/conf.d/01-environment.zsh`:

```bash
# Claude Code → GitHub Copilot Proxy Configuration
export ANTHROPIC_BASE_URL="http://localhost:4000"
# Set a secure master key (generate with: openssl rand -hex 16)
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"
export ANTHROPIC_AUTH_TOKEN="${LITELLM_MASTER_KEY}"
# Note: Only set AUTH_TOKEN, not API_KEY, to avoid auth conflict
```

**Important:**
- The default key is `sk-claude-copilot-proxy-default` (suitable for local use)
- To set a custom key, add to your `~/.zshrc` or `~/.zshenv`: `export LITELLM_MASTER_KEY="your-secret-key"`
- Generate a secure key: `openssl rand -hex 16`

## Configuration Files

- **Config Template**: `~/.claude-copilot-proxy/config.yaml.example` (committed to git)
- **Active Config**: `~/.claude-copilot-proxy/config.yaml` (uses `${LITELLM_MASTER_KEY}` env var)
- **Startup Script**: `~/.claude-copilot-proxy/start-proxy.sh`
- **Token Refresh**: `~/.claude-copilot-proxy/refresh-token.sh`
- **Environment Variables**: `~/dotfiles/zsh/conf.d/01-environment.zsh`
- **Git Ignore**: `.gitignore` excludes `config.yaml` to protect sensitive keys

### First-Time Setup

If you don't have a `config.yaml` yet:
```bash
cp ~/.claude-copilot-proxy/config.yaml.example ~/.claude-copilot-proxy/config.yaml
```

The config uses the `LITELLM_MASTER_KEY` environment variable, which is already set in your zsh config.

## Troubleshooting

### Proxy won't start
- Check Python version: `python3 --version` (should be 3.13.x)
- Reinstall LiteLLM: `pipx reinstall litellm`
- Check port availability: `lsof -i :4000`

### Claude Code still uses Anthropic
- Ensure proxy is running: `curl http://localhost:4000/health`
- Restart terminal to load env vars: `source ~/.zshrc`
- Verify env vars: `echo $ANTHROPIC_BASE_URL`

### Authentication errors
- Refresh GitHub token: `gh auth login`
- Check Copilot access: `gh api /user/copilot`

### No response from proxy
- Check proxy logs in the terminal where it's running
- Verify GitHub token: `gh auth status`

## Stopping the Proxy

Press `Ctrl+C` in the terminal where the proxy is running.

## Updating Models

Edit `~/.claude-copilot-proxy/config.yaml` to change model mappings.

**Available GitHub Copilot models:**
- **Claude Models**: `claude-opus-4.5`, `claude-opus-41`, `claude-sonnet-4.5`, `claude-sonnet-4`, `claude-haiku-4.5`
- **OpenAI Models**: `gpt-4o`, `gpt-4o-mini`, `o1-preview`, `o1-mini`
- **Google Models**: `gemini-2.0-flash-exp`, `gemini-exp-1206`
- **Other**: Model availability depends on your GitHub Copilot subscription

**Note:** After editing the config, restart the proxy for changes to take effect.

## Cost Tracking

All requests are tracked by GitHub Copilot. Check usage at:
https://github.com/settings/copilot

## Notes

- The proxy runs locally on your machine
- No data is sent to Anthropic - everything goes through GitHub Copilot
- You're using your GitHub Copilot subscription quota
- The setup persists across reboots (just restart the proxy)

## Security Notes

- **Config file** (`config.yaml`) is git-ignored to prevent committing sensitive keys
- **Template file** (`config.yaml.example`) is safe to commit and share
- The `LITELLM_MASTER_KEY` environment variable keeps your key out of version control
- Default key is suitable for local development; use a custom key for shared/production use

## Recent Changes

- **Nov 30, 2025**: Migrated hardcoded API key to environment variable (`LITELLM_MASTER_KEY`)
- **Nov 30, 2025**: Added `.gitignore` to protect sensitive config files
- **Nov 30, 2025**: Created `config.yaml.example` template for safe version control
- **Nov 26, 2025**: Initial setup created
