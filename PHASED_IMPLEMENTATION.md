# Phased Implementation Plan with Docker Testing

## Overview

This document breaks down the optimization into **4 phases**, each independently testable with Docker containers. Each phase builds on the previous one and can be validated before proceeding.

---

## Docker Testing Strategy

### Test Environment Setup

**File**: `docker/Dockerfile.test` (create this)

```dockerfile
# Use Ubuntu as base (similar to GitHub Codespaces)
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create a test user (like vscode in Codespaces)
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy dotfiles into container
COPY --chown=testuser:testuser . /home/testuser/dotfiles

# Default command: run installation
CMD ["/home/testuser/dotfiles/install.sh"]
```

**File**: `docker/docker-compose.test.yml` (create this)

```yaml
version: '3.8'

services:
  dotfiles-test:
    build:
      context: ..
      dockerfile: docker/Dockerfile.test
    container_name: dotfiles-test
    volumes:
      - ..:/home/testuser/dotfiles:ro  # Read-only to prevent accidental changes
    environment:
      - HOMEBREW_NO_INSTALL_CLEANUP=1
      - HOMEBREW_NO_ANALYTICS=1
      - DEBIAN_FRONTEND=noninteractive
```

### Testing Commands

```bash
# Build test container
docker-compose -f docker/docker-compose.test.yml build

# Run installation test
docker-compose -f docker/docker-compose.test.yml up

# Interactive testing (for debugging)
docker-compose -f docker/docker-compose.test.yml run --rm dotfiles-test /bin/bash

# Clean up
docker-compose -f docker/docker-compose.test.yml down
docker system prune -f
```

---

## Phase 1: Logging & Timing Infrastructure

### Goal
Add comprehensive logging and timing without changing installation flow.

### Changes Required

#### 1.1 Create Log Directory
```bash
mkdir -p logs
touch logs/.gitkeep
```

Add to `.gitignore`:
```
logs/*.log
*_install.log
*_install.pid
```

#### 1.2 Update `install/utils.sh`

**Add after existing code**:
```bash
# === NEW: Timing and Logging Infrastructure ===

# Global variables for timing
declare -A TIMING_DATA
INSTALL_START_TIME=$(date +%s)
LOG_FILE="${HOME}/dotfiles_install.log"

# Initialize log file with header
init_log_file() {
  echo "=== Dotfiles Installation Log ===" > "$LOG_FILE"
  echo "Started: $(date)" >> "$LOG_FILE"
  echo "OS: $OS" >> "$LOG_FILE"
  echo "Dotfiles Dir: $DOTFILES_DIR" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
}

# Enhanced logging - writes to both console and file
log() {
  local message="$*"
  # Console output (with color)
  echo -e "${CYAN}[ $(date '+%Y-%m-%d %H:%M:%S') ] $message${NC}"
  # File output (no color codes)
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

# Start timing an operation
start_operation() {
  local operation="$1"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔄 Starting: $operation" >> "$LOG_FILE"
  date +%s  # Return current timestamp
}

# Log operation completion with timing
log_with_timing() {
  local operation="$1"
  local start_time="$2"
  local end_time
  end_time=$(date +%s)
  local duration=$((end_time - start_time))

  TIMING_DATA["$operation"]=$duration
  local message="✅ $operation (${duration}s)"
  echo -e "${CYAN}[ $(date '+%Y-%m-%d %H:%M:%S') ] $message${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

# Generate timing summary at end
generate_timing_summary() {
  local total_time
  total_time=$(($(date +%s) - INSTALL_START_TIME))

  {
    echo ""
    echo "=== TIMING SUMMARY ==="
    echo "Total installation time: ${total_time}s ($((total_time / 60))m $((total_time % 60))s)"
    echo ""
    echo "Operations by duration (longest first):"
  } >> "$LOG_FILE"

  # Sort timing data by duration (longest first)
  for operation in "${!TIMING_DATA[@]}"; do
    echo "${TIMING_DATA[$operation]} $operation"
  done | sort -nr | while read -r duration op; do
    if [ "$duration" -ge 60 ]; then
      echo "  $op: ${duration}s ($((duration / 60))m $((duration % 60))s)" >> "$LOG_FILE"
    else
      echo "  $op: ${duration}s" >> "$LOG_FILE"
    fi
  done

  echo "" >> "$LOG_FILE"
  echo "Completed: $(date)" >> "$LOG_FILE"

  # Also print summary to console
  echo ""
  echo -e "${CYAN}=== Installation Complete ===${NC}"
  echo -e "${CYAN}Total time: ${total_time}s ($((total_time / 60))m $((total_time % 60))s)${NC}"
  echo -e "${CYAN}Full log: $LOG_FILE${NC}"
  echo ""
}
```

#### 1.3 Update Each Install Module

**`install/bootstrap.sh`**:
```bash
bootstrap_system() {
  log "--- Starting Bootstrap Phase ---"
  local start_time
  start_time=$(start_operation "Bootstrap phase")

  # ... existing code ...

  log_with_timing "Bootstrap phase" "$start_time"
  log "--- Bootstrap Phase Complete ---"
}
```

**`install/homebrew.sh`**:
```bash
install_homebrew() {
  log "--- Starting Homebrew Installation ---"
  local start_time
  start_time=$(start_operation "Homebrew installation")

  # ... existing code ...

  log_with_timing "Homebrew installation" "$start_time"
  log "--- Homebrew Installation Complete ---"
}
```

**`install/packages.sh`**:
```bash
install_packages() {
  log "--- Starting Package Installation ---"
  local start_time
  start_time=$(start_operation "Package installation")

  # ... existing code ...

  log_with_timing "Package installation" "$start_time"
  log "--- Package Installation Complete ---"
}
```

**`install/languages.sh`**:
```bash
install_languages() {
  log "--- Starting Language Tools Installation ---"
  local start_time
  start_time=$(start_operation "Language tools installation")

  # ... existing code ...

  log_with_timing "Language tools installation" "$start_time"
  log "--- Language Tools Installation Complete ---"
}
```

**`install/scripts.sh`**:
```bash
copy_scripts() {
  log "--- Starting Scripts Copy ---"
  local start_time
  start_time=$(start_operation "Scripts copy")

  # ... existing code ...

  log_with_timing "Scripts copy" "$start_time"
  log "--- Scripts Copy Complete ---"
}
```

**`install/symlinks.sh`**:
```bash
create_symlinks() {
  log "--- Starting Symlink Creation ---"
  local start_time
  start_time=$(start_operation "Symlink creation")

  stow_packages

  log_with_timing "Symlink creation" "$start_time"
  log "--- Symlink Creation Complete ---"
}
```

#### 1.4 Update `install.sh`

**Add after sourcing utils.sh**:
```bash
# Source utility functions
source "${INSTALL_DIR}/utils.sh"

# Initialize environment
detect_os
setup_dotfiles_dir

# NEW: Initialize logging
init_log_file
log "🚀 Starting dotfiles installation..."
```

**Add before `exec zsh -l`**:
```bash
# NEW: Generate timing summary
generate_timing_summary

log ""
log "################################################################"
# ... existing completion message ...
```

### Phase 1 Testing

**Test Script**: `test-phase1.sh`

```bash
#!/usr/bin/env bash
# Test Phase 1: Logging and Timing

echo "=== Phase 1 Test: Logging & Timing ==="
echo ""

# Build and run
docker-compose -f docker/docker-compose.test.yml build
docker-compose -f docker/docker-compose.test.yml up

# Copy log file from container
container_id=$(docker ps -a -q -f name=dotfiles-test | head -1)
docker cp "$container_id:/home/testuser/dotfiles_install.log" ./logs/phase1-test.log

echo ""
echo "=== Test Results ==="
echo "Log file: ./logs/phase1-test.log"
echo ""

# Validate log file
if [ -f "./logs/phase1-test.log" ]; then
    echo "✅ Log file created"

    # Check for timing data
    if grep -q "TIMING SUMMARY" "./logs/phase1-test.log"; then
        echo "✅ Timing summary present"
    else
        echo "❌ Timing summary missing"
    fi

    # Check for all phases
    phases=("Bootstrap phase" "Homebrew installation" "Package installation" "Language tools" "Scripts copy" "Symlink creation")
    for phase in "${phases[@]}"; do
        if grep -q "$phase" "./logs/phase1-test.log"; then
            echo "✅ Phase logged: $phase"
        else
            echo "❌ Phase missing: $phase"
        fi
    done

    echo ""
    echo "=== Timing Summary ==="
    grep -A 20 "TIMING SUMMARY" "./logs/phase1-test.log"
else
    echo "❌ Log file not created"
fi

# Cleanup
docker-compose -f docker/docker-compose.test.yml down
```

### Phase 1 Success Criteria

✅ Log file created at `~/dotfiles_install.log`
✅ All phases logged with timestamps
✅ Timing data captured for each operation
✅ Timing summary generated at end
✅ Installation still completes successfully
✅ No change to installation behavior (same packages, same order)

---

## Phase 2: Split Brewfile & Essential Packages

### Goal
Split Brewfile into essential vs optional packages (still sequential, no parallelization yet).

### Changes Required

#### 2.1 Create Split Brewfiles

**File**: `Brewfile.essential`

```ruby
# Critical packages needed immediately for dotfiles setup
# These install first to minimize time to working environment

# Required for symlink management
brew "stow"

# Required for Copilot CLI and other npm packages
brew "node"
brew "nvm"

# Essential shell tools (needed for immediate productivity)
brew "fzf"          # Fuzzy finder - shell integration
brew "neovim"       # Editor
brew "tmux"         # Terminal multiplexer
```

**File**: `Brewfile.optional`

```ruby
# Optional packages - can install after essential setup
# These are backgrounded in Phase 3

# Specify taps
tap "FelixKratz/formulae"
tap "timescam/homebrew-tap"

# Modern CLI replacements
brew "bat"           # Better cat
brew "eza"           # Better ls
brew "ripgrep"       # Better grep
brew "fd"            # Better find
brew "zoxide"        # Smart cd
brew "pay-respects"  # Command correction

# File management
brew "yazi"          # File manager
brew "tree"          # Directory visualization

# Development tools
brew "yq"            # YAML processor
brew "lazygit"       # Git TUI
brew "starship"      # Prompt
brew "tree-sitter"   # Syntax parser
brew "prettier"      # Code formatter
brew "make"          # Build tool

# Language tools
brew "lua"
brew "luajit"
brew "luarocks"

# Zsh enhancements
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
```

**File**: `Brewfile` (update)

**Add at top**:
```ruby
# ============================================================================
# DEPRECATED: This file is kept for backwards compatibility only
# ============================================================================
#
# The installation now uses split Brewfiles for optimization:
#   - Brewfile.essential: Critical packages (stow, node, fzf, neovim, tmux)
#   - Brewfile.optional:  Everything else (installed in background in Phase 3)
#
# To use the old monolithic installation:
#   brew bundle --file=Brewfile
#
# ============================================================================

# ... keep all existing package declarations ...
```

#### 2.2 Update `install/packages.sh`

**Complete rewrite**:
```bash
#!/usr/bin/env bash
# Package installation with essential/optional split

install_packages() {
  log "--- Starting Package Installation ---"
  local start_time
  start_time=$(start_operation "Package installation phase")

  # Check which Brewfile strategy to use
  if [ -f "${DOTFILES_DIR}/Brewfile.essential" ] && [ -f "${DOTFILES_DIR}/Brewfile.optional" ]; then
    log "Using split Brewfile strategy (essential + optional)"
    install_packages_split
  else
    log "Using legacy monolithic Brewfile"
    install_packages_legacy
  fi

  log_with_timing "Package installation phase" "$start_time"
  log "--- Package Installation Complete ---"
}

# Split installation strategy (Phase 2+)
install_packages_split() {
  # Install essential packages first
  local essential_start
  essential_start=$(start_operation "Essential packages (stow, node, fzf, neovim, tmux)")

  log "Installing essential packages from Brewfile.essential..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile.essential"

  log_with_timing "Essential packages (stow, node, fzf, neovim, tmux)" "$essential_start"

  # Install optional packages (still foreground in Phase 2)
  local optional_start
  optional_start=$(start_operation "Optional packages (bat, eza, ripgrep, etc.)")

  log "Installing optional packages from Brewfile.optional..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile.optional"

  log_with_timing "Optional packages (bat, eza, ripgrep, etc.)" "$optional_start"
}

# Legacy installation (backwards compatibility)
install_packages_legacy() {
  if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
    log "Installing packages from legacy Brewfile..."
    brew bundle --file="${DOTFILES_DIR}/Brewfile"
  else
    log "ERROR: No Brewfile found at ${DOTFILES_DIR}/Brewfile"
    exit 1
  fi
}
```

### Phase 2 Testing

**Test Script**: `test-phase2.sh`

```bash
#!/usr/bin/env bash
# Test Phase 2: Split Brewfile

echo "=== Phase 2 Test: Split Brewfile ==="
echo ""

# Build and run
docker-compose -f docker/docker-compose.test.yml build
docker-compose -f docker/docker-compose.test.yml up

# Copy log file from container
container_id=$(docker ps -a -q -f name=dotfiles-test | head -1)
docker cp "$container_id:/home/testuser/dotfiles_install.log" ./logs/phase2-test.log

echo ""
echo "=== Test Results ==="

# Check for split installation
if grep -q "Using split Brewfile strategy" "./logs/phase2-test.log"; then
    echo "✅ Split Brewfile strategy detected"
else
    echo "❌ Split Brewfile strategy not used"
fi

# Check for essential packages timing
if grep -q "Essential packages (stow, node, fzf, neovim, tmux)" "./logs/phase2-test.log"; then
    echo "✅ Essential packages phase logged"

    # Extract timing
    essential_time=$(grep "Essential packages" "./logs/phase2-test.log" | grep -oE '\([0-9]+s\)' | grep -oE '[0-9]+')
    echo "   Time: ${essential_time}s"
else
    echo "❌ Essential packages phase missing"
fi

# Check for optional packages timing
if grep -q "Optional packages (bat, eza, ripgrep, etc.)" "./logs/phase2-test.log"; then
    echo "✅ Optional packages phase logged"

    # Extract timing
    optional_time=$(grep "Optional packages" "./logs/phase2-test.log" | grep -oE '\([0-9]+s\)' | grep -oE '[0-9]+')
    echo "   Time: ${optional_time}s"
else
    echo "❌ Optional packages phase missing"
fi

# Verify packages installed
echo ""
echo "=== Package Verification ==="

essential_packages=("stow" "node" "fzf" "neovim" "tmux")
for pkg in "${essential_packages[@]}"; do
    if docker exec dotfiles-test brew list "$pkg" &>/dev/null; then
        echo "✅ Essential package installed: $pkg"
    else
        echo "❌ Essential package missing: $pkg"
    fi
done

echo ""
echo "=== Timing Comparison ==="
grep -A 20 "TIMING SUMMARY" "./logs/phase2-test.log"

# Cleanup
docker-compose -f docker/docker-compose.test.yml down
```

### Phase 2 Success Criteria

✅ Split Brewfile strategy detected in logs
✅ Essential packages install first (separate timing)
✅ Optional packages install second (separate timing)
✅ All packages still install successfully
✅ Timing breakdown shows two distinct phases
✅ Essential packages < 60s (faster than full Brewfile)

---

## Phase 3: Background Installation Framework

### Goal
Install optional packages in background while user can start working.

### Changes Required

#### 3.1 Create Parallel Framework

**File**: `install/parallel-install.sh` (new)

```bash
#!/usr/bin/env bash
# Parallel installation framework for background jobs

# Global variables
declare -A BACKGROUND_PIDS
declare -A BACKGROUND_LOGS

# Start a background installation job
start_background_job() {
  local job_name="$1"
  local log_file="$2"
  local command="$3"

  log "🔄 Starting background job: $job_name"

  {
    echo "=== $job_name started at $(date) ===" > "$log_file"
    echo "PID: $$" >> "$log_file"
    echo "" >> "$log_file"

    # Execute the command
    eval "$command" >> "$log_file" 2>&1
    exit_code=$?

    echo "" >> "$log_file"
    echo "=== $job_name completed at $(date) ===" >> "$log_file"
    echo "Exit code: $exit_code" >> "$log_file"

    exit $exit_code
  } &

  local pid=$!
  BACKGROUND_PIDS["$job_name"]=$pid
  BACKGROUND_LOGS["$job_name"]=$log_file

  # Write PID to file for monitoring
  echo "$pid" > "${log_file%.log}.pid"

  log "   PID: $pid | Log: $log_file"
}

# Check if a background job is still running
is_job_running() {
  local job_name="$1"
  local pid="${BACKGROUND_PIDS[$job_name]}"

  if [ -z "$pid" ]; then
    return 1
  fi

  if ps -p "$pid" > /dev/null 2>&1; then
    return 0  # Running
  else
    return 1  # Not running
  fi
}

# Wait for a specific background job
wait_for_job() {
  local job_name="$1"
  local pid="${BACKGROUND_PIDS[$job_name]}"

  if [ -n "$pid" ]; then
    log "⏳ Waiting for $job_name to complete..."
    wait "$pid"
    local exit_code=$?

    # Clean up PID file
    local log_file="${BACKGROUND_LOGS[$job_name]}"
    rm -f "${log_file%.log}.pid"

    if [ $exit_code -eq 0 ]; then
      log "✅ $job_name completed successfully"
    else
      log "❌ $job_name failed with exit code $exit_code"
    fi

    return $exit_code
  fi
}

# Wait for all background jobs
wait_for_all_jobs() {
  log "⏳ Waiting for all background jobs to complete..."

  local failed_jobs=()

  for job_name in "${!BACKGROUND_PIDS[@]}"; do
    if ! wait_for_job "$job_name"; then
      failed_jobs+=("$job_name")
    fi
  done

  if [ ${#failed_jobs[@]} -eq 0 ]; then
    log "✅ All background jobs completed successfully"
    return 0
  else
    log "❌ Some background jobs failed: ${failed_jobs[*]}"
    return 1
  fi
}

# List active background jobs
list_background_jobs() {
  if [ ${#BACKGROUND_PIDS[@]} -eq 0 ]; then
    echo "No background jobs running"
    return
  fi

  echo "Active background jobs:"
  for job_name in "${!BACKGROUND_PIDS[@]}"; do
    local pid="${BACKGROUND_PIDS[$job_name]}"
    local log_file="${BACKGROUND_LOGS[$job_name]}"

    if is_job_running "$job_name"; then
      echo "  🔄 $job_name (PID: $pid)"
      echo "     Log: tail -f $log_file"
    else
      echo "  ✅ $job_name (completed)"
    fi
  done
}
```

#### 3.2 Update `install/packages.sh`

**Modify `install_packages_split()`**:
```bash
# Split installation strategy with background jobs
install_packages_split() {
  # Install essential packages first (FOREGROUND)
  local essential_start
  essential_start=$(start_operation "Essential packages (stow, node, fzf, neovim, tmux)")

  log "Installing essential packages from Brewfile.essential..."
  brew bundle --file="${DOTFILES_DIR}/Brewfile.essential"

  log_with_timing "Essential packages (stow, node, fzf, neovim, tmux)" "$essential_start"

  # Start optional packages in BACKGROUND
  local optional_log="${HOME}/.dotfiles_brew_optional.log"
  start_background_job \
    "optional_brew_packages" \
    "$optional_log" \
    "brew bundle --file='${DOTFILES_DIR}/Brewfile.optional'"

  log "📦 Optional packages installing in background"
  log "   Monitor: tail -f $optional_log"
  log "   Check status: ~/scripts/check-brew-install.sh"
}
```

#### 3.3 Update `install/languages.sh`

**Add background Rust installation**:
```bash
install_languages() {
  log "--- Starting Language Tools Installation ---"
  local start_time
  start_time=$(start_operation "Language tools installation phase")

  # Install Rust in BACKGROUND (independent of Homebrew)
  if ! command -v cargo >/dev/null 2>&1; then
    local rust_log="${HOME}/.dotfiles_rust_install.log"
    start_background_job \
      "rust_toolchain" \
      "$rust_log" \
      "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source \$HOME/.cargo/env"

    log "🦀 Rust installing in background"
    log "   Monitor: tail -f $rust_log"
    log "   Check status: ~/scripts/check-rust-install.sh"
  else
    log "Rust & Cargo already installed: $(cargo --version)"
  fi

  # Install Copilot CLI in FOREGROUND (needs node from essential packages)
  if ! command -v copilot >/dev/null 2>&1; then
    local copilot_start
    copilot_start=$(start_operation "GitHub Copilot CLI installation")

    log "Installing GitHub Copilot CLI via npm..."
    npm install -g @github/copilot

    log_with_timing "GitHub Copilot CLI installation" "$copilot_start"
  else
    log "GitHub Copilot CLI already installed"
  fi

  log_with_timing "Language tools installation phase" "$start_time"
  log "--- Language Tools Installation Complete ---"
}
```

#### 3.4 Update `install.sh`

**Add after sourcing utils.sh**:
```bash
# Source utility functions
source "${INSTALL_DIR}/utils.sh"

# Initialize environment
detect_os
setup_dotfiles_dir
init_log_file

# NEW: Source parallel installation framework
source "${INSTALL_DIR}/parallel-install.sh"

log "🚀 Starting dotfiles installation with background job support..."
```

**Update completion message**:
```bash
# Before exec zsh -l, show background job status
log ""
log "################################################################"
log "#                                                              #"
log "#  ✅ Essential setup complete!                                #"
log "#                                                              #"

# List active background jobs
if [ ${#BACKGROUND_PIDS[@]} -gt 0 ]; then
  log "#  🔄 Background installations in progress:                    #"
  for job_name in "${!BACKGROUND_PIDS[@]}"; do
    local log_file="${BACKGROUND_LOGS[$job_name]}"
    log "#     - $job_name"
    log "#       Monitor: tail -f $log_file"
  done
  log "#                                                              #"
  log "#  💡 Check status anytime with: ~/scripts/check-installs.sh  #"
fi

log "#                                                              #"
log "################################################################"
log ""

generate_timing_summary

log "Reloading shell to apply all changes..."
exec zsh -l
```

#### 3.5 Create Status Check Scripts

**File**: `scripts/check-brew-install.sh`

```bash
#!/usr/bin/env bash
# Check Homebrew optional packages installation status

PID_FILE="${HOME}/.dotfiles_brew_optional.pid"
LOG_FILE="${HOME}/.dotfiles_brew_optional.log"

if [ ! -f "$PID_FILE" ]; then
    echo "❌ No Homebrew installation PID file found"
    echo "Installation either complete or never started"

    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "📄 Last 5 lines of log:"
        tail -n 5 "$LOG_FILE"
    fi
    exit 1
fi

BREW_PID=$(cat "$PID_FILE")

if ps -p "$BREW_PID" > /dev/null 2>&1; then
    echo "📦 Homebrew optional packages still installing (PID: $BREW_PID)"
    echo ""
    echo "Recent activity:"
    tail -n 10 "$LOG_FILE"
    echo ""
    echo "Commands:"
    echo "  Monitor: tail -f $LOG_FILE"
    echo "  Wait: wait $BREW_PID"
else
    echo "✅ Homebrew installation complete"

    if grep -q "completed at" "$LOG_FILE"; then
        echo "🎉 All optional packages installed successfully"
    else
        echo "⚠️  Check log for potential issues: $LOG_FILE"
    fi

    rm -f "$PID_FILE"
fi
```

**File**: `scripts/check-rust-install.sh`

```bash
#!/usr/bin/env bash
# Check Rust installation status

PID_FILE="${HOME}/.dotfiles_rust_install.pid"
LOG_FILE="${HOME}/.dotfiles_rust_install.log"

if [ ! -f "$PID_FILE" ]; then
    echo "❌ No Rust installation PID file found"

    if command -v cargo &>/dev/null; then
        echo "✅ Rust is already installed:"
        cargo --version
        rustc --version
    else
        echo "ℹ️  Rust not installed"
    fi
    exit 0
fi

RUST_PID=$(cat "$PID_FILE")

if ps -p "$RUST_PID" > /dev/null 2>&1; then
    echo "🦀 Rust installation in progress (PID: $RUST_PID)"
    echo ""
    echo "Recent activity:"
    tail -n 10 "$LOG_FILE"
    echo ""
    echo "Commands:"
    echo "  Monitor: tail -f $LOG_FILE"
else
    echo "✅ Rust installation complete"

    if command -v cargo &>/dev/null; then
        echo "🎉 Rust ready:"
        cargo --version
        rustc --version
    else
        echo "⚠️  Rust installed but not in PATH"
        echo "Run: source ~/.cargo/env"
    fi

    rm -f "$PID_FILE"
fi
```

**File**: `scripts/check-installs.sh`

```bash
#!/usr/bin/env bash
# Check all background installation statuses

echo "=== Background Installation Status ==="
echo ""

# Check Homebrew optional packages
if [ -f "${HOME}/.dotfiles_brew_optional.pid" ]; then
    ~/scripts/check-brew-install.sh
    echo ""
fi

# Check Rust
if [ -f "${HOME}/.dotfiles_rust_install.pid" ]; then
    ~/scripts/check-rust-install.sh
    echo ""
fi

# If no background jobs
if [ ! -f "${HOME}/.dotfiles_brew_optional.pid" ] && [ ! -f "${HOME}/.dotfiles_rust_install.pid" ]; then
    echo "✅ No background installations running"
    echo ""
    echo "All installations complete!"
fi
```

### Phase 3 Testing

**Test Script**: `test-phase3.sh`

```bash
#!/usr/bin/env bash
# Test Phase 3: Background Installation

echo "=== Phase 3 Test: Background Installation ==="
echo ""

# Build and run
docker-compose -f docker/docker-compose.test.yml build
container_id=$(docker-compose -f docker/docker-compose.test.yml up -d)

# Wait a bit for essential packages
echo "Waiting 60s for essential packages..."
sleep 60

# Check if background jobs started
echo ""
echo "=== Checking Background Jobs ==="

# Copy log files
docker cp dotfiles-test:/home/testuser/dotfiles_install.log ./logs/phase3-main.log
docker cp dotfiles-test:/home/testuser/.dotfiles_brew_optional.log ./logs/phase3-brew.log 2>/dev/null || echo "Brew background log not found yet"
docker cp dotfiles-test:/home/testuser/.dotfiles_rust_install.log ./logs/phase3-rust.log 2>/dev/null || echo "Rust background log not found yet"

# Check main log
if grep -q "Optional packages installing in background" "./logs/phase3-main.log"; then
    echo "✅ Background brew job started"
else
    echo "❌ Background brew job not started"
fi

if grep -q "Rust installing in background" "./logs/phase3-main.log"; then
    echo "✅ Background rust job started"
else
    echo "❌ Background rust job not started"
fi

# Check if essential packages completed quickly
essential_time=$(grep "Essential packages" "./logs/phase3-main.log" | grep -oE '\([0-9]+s\)' | grep -oE '[0-9]+')
if [ -n "$essential_time" ] && [ "$essential_time" -lt 120 ]; then
    echo "✅ Essential packages completed quickly: ${essential_time}s"
else
    echo "❌ Essential packages took too long: ${essential_time}s"
fi

# Wait for container to finish
echo ""
echo "Waiting for installation to complete..."
docker wait dotfiles-test

# Final checks
echo ""
echo "=== Final Verification ==="

# Check if background jobs completed
docker exec dotfiles-test ~/scripts/check-installs.sh

# Cleanup
docker-compose -f docker/docker-compose.test.yml down
```

### Phase 3 Success Criteria

✅ Essential packages complete in < 120s
✅ Optional brew packages run in background
✅ Rust installation runs in background
✅ PID files created for background jobs
✅ Log files created for background jobs
✅ Check scripts can monitor background jobs
✅ User shell is ready while background jobs continue
✅ All packages eventually install successfully

---

## Phase 4: Tmux Indicator & Polish

### Goal
Add visual feedback for background installations and final polish.

### Changes Required

#### 4.1 Create Tmux Background Indicator

**File**: `scripts/tmux-background-indicator.sh`

```bash
#!/usr/bin/env bash
# Background installation indicator for tmux status line

SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

RUST_PID="${HOME}/.dotfiles_rust_install.pid"
BREW_PID="${HOME}/.dotfiles_brew_optional.pid"

rust_running=false
brew_running=false

# Check Rust
if [ -f "$RUST_PID" ]; then
    pid=$(cat "$RUST_PID" 2>/dev/null)
    if [ -n "$pid" ] && ps -p "$pid" >/dev/null 2>&1; then
        rust_running=true
    fi
fi

# Check Homebrew
if [ -f "$BREW_PID" ]; then
    pid=$(cat "$BREW_PID" 2>/dev/null)
    if [ -n "$pid" ] && ps -p "$pid" >/dev/null 2>&1; then
        brew_running=true
    fi
fi

# Exit if nothing running
if [ "$rust_running" = false ] && [ "$brew_running" = false ]; then
    exit 0
fi

# Get spinner frame
current_second=$(date +%s)
frame_index=$((current_second % ${#SPINNER_FRAMES[@]}))
spinner="${SPINNER_FRAMES[$frame_index]}"

# Build status
status=""
[ "$rust_running" = true ] && status="${status}🦀 "
[ "$brew_running" = true ] && status="${status}📦 "

# Output for tmux
echo "#[fg=cyan]${spinner} ${status}#[default]"
```

Make executable:
```bash
chmod +x scripts/tmux-background-indicator.sh
```

#### 4.2 Update Tmux Config

**Add to `tmux/.tmux.conf`**:

```tmux
# Background installation indicator
set-option -g status-right "#{?#{!=:#{pane_current_command},zsh},#{pane_current_command} | ,}#(~/.dotfiles/scripts/tmux-background-indicator.sh)%Y-%m-%d %H:%M "
```

#### 4.3 Add Installation Summary

**File**: `scripts/installation-summary.sh`

```bash
#!/usr/bin/env bash
# Display installation summary

LOG_FILE="${HOME}/dotfiles_install.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ No installation log found"
    exit 1
fi

echo "=== Dotfiles Installation Summary ==="
echo ""

# Extract timing summary
if grep -q "TIMING SUMMARY" "$LOG_FILE"; then
    grep -A 30 "TIMING SUMMARY" "$LOG_FILE"
else
    echo "⚠️  No timing data available"
fi

echo ""
echo "=== Background Jobs ==="
~/scripts/check-installs.sh

echo ""
echo "Full log: $LOG_FILE"
```

Make executable:
```bash
chmod +x scripts/installation-summary.sh
```

### Phase 4 Testing

**Test Script**: `test-phase4.sh`

```bash
#!/usr/bin/env bash
# Test Phase 4: Tmux Indicator & Polish

echo "=== Phase 4 Test: Complete System ==="
echo ""

# Build and run
docker-compose -f docker/docker-compose.test.yml build
docker-compose -f docker/docker-compose.test.yml up -d

echo "Installation running..."
echo ""

# Monitor for 2 minutes
for i in {1..12}; do
    sleep 10

    # Check indicator script
    if docker exec dotfiles-test ~/scripts/tmux-background-indicator.sh 2>/dev/null; then
        indicator=$(docker exec dotfiles-test ~/scripts/tmux-background-indicator.sh)
        if [ -n "$indicator" ]; then
            echo "[${i}0s] Background jobs active: $indicator"
        else
            echo "[${i}0s] No background jobs"
        fi
    fi
done

# Wait for completion
echo ""
echo "Waiting for installation to complete..."
docker wait dotfiles-test

# Get summary
echo ""
docker exec dotfiles-test ~/scripts/installation-summary.sh

# Cleanup
docker-compose -f docker/docker-compose.test.yml down

echo ""
echo "=== Test Complete ==="
```

### Phase 4 Success Criteria

✅ Tmux indicator appears when background jobs running
✅ Tmux indicator disappears when jobs complete
✅ Spinner animation works
✅ Correct icons show for each job type
✅ Installation summary script works
✅ All previous phase criteria still met

---

## Complete Test Suite

**File**: `test-all-phases.sh`

```bash
#!/usr/bin/env bash
# Run all phase tests

set -e  # Exit on error

echo "=== Running All Phase Tests ==="
echo ""

# Create logs directory
mkdir -p logs

# Phase 1
echo "▶️  Phase 1: Logging & Timing"
./test-phase1.sh
echo ""

# Phase 2
echo "▶️  Phase 2: Split Brewfile"
./test-phase2.sh
echo ""

# Phase 3
echo "▶️  Phase 3: Background Installation"
./test-phase3.sh
echo ""

# Phase 4
echo "▶️  Phase 4: Tmux Indicator & Polish"
./test-phase4.sh
echo ""

echo "=== All Tests Complete ==="
echo "Check logs/ directory for detailed results"
```

---

## Summary

### Implementation Order

1. **Phase 1** (2-3 hours): Add logging and timing infrastructure
   - Low risk, high value
   - Enables measurement of improvements
   - No behavior changes

2. **Phase 2** (1-2 hours): Split Brewfile
   - Medium risk, medium value
   - Enables prioritization
   - Still sequential, easier to debug

3. **Phase 3** (3-4 hours): Background installation
   - Medium risk, high value
   - Major performance improvement
   - Introduces complexity

4. **Phase 4** (1-2 hours): Polish and monitoring
   - Low risk, medium value
   - Better user experience
   - Nice to have features

### Testing Strategy

- **Docker** provides clean, reproducible test environment
- Each phase has dedicated test script
- Tests validate both functionality and performance
- Logs preserved for analysis

### Rollback Strategy

Each phase is independent:
- Phase 1 fails → Remove timing code, keep original
- Phase 2 fails → Use `Brewfile` instead of split
- Phase 3 fails → Install optional packages in foreground
- Phase 4 fails → Skip tmux indicator

### Total Effort

- **Development**: ~10-12 hours across 4 phases
- **Testing**: ~2-3 hours (Docker + validation)
- **Total**: ~13-15 hours spread over 1-2 weeks

Would you like me to start with Phase 1?
