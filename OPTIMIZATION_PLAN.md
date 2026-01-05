# Dotfiles Installation Optimization Plan
## Phase 2: Full Parallel Framework Implementation

## Overview
Transform the current sequential installation (~8-10 minutes) into a parallel, optimized system (~2 minutes to working shell) by adopting the dj-dotfiles parallel framework patterns.

## Goals
1. **Reduce install time by 75%**: From 8-10 minutes to 2 minutes for essential tools
2. **Improve UX**: Background installations with visibility and monitoring
3. **Add comprehensive logging**: Timing data and performance insights
4. **Enable parallel execution**: Independent operations run concurrently

## Architecture Changes

### New File Structure
```
dotfiles/
├── install/
│   ├── utils.sh              # [MODIFY] Add timing, parallel helpers
│   ├── bootstrap.sh          # [MODIFY] Add timing
│   ├── homebrew.sh           # [MODIFY] Add timing, split install
│   ├── packages.sh           # [MODIFY] Parallel package installation
│   ├── languages.sh          # [MODIFY] Background Rust, parallel Copilot
│   ├── scripts.sh            # [MODIFY] Add timing
│   ├── symlinks.sh           # [MODIFY] Add timing
│   └── parallel-install.sh   # [NEW] Core parallel framework
│
├── scripts/
│   ├── check-rust-install.sh    # [NEW] Rust installation status
│   ├── check-brew-install.sh    # [NEW] Homebrew status
│   ├── check-copilot-install.sh # [NEW] Copilot status
│   └── tmux-background-indicator.sh # [NEW] Tmux status indicator
│
├── Brewfile.essential        # [NEW] Critical packages only
├── Brewfile.optional         # [NEW] Non-essential packages
├── Brewfile                  # [MODIFY] Keep for reference/compatibility
└── install.sh                # [MODIFY] Add parallel orchestration
```

## Implementation Steps

### Step 1: Create Parallel Installation Framework
**File**: `install/parallel-install.sh` (new)

**Functionality**:
- `run_parallel(operation_name, command)` - Execute command in background with logging
- `wait_for_parallel(operations[])` - Wait for parallel ops, aggregate logs
- `log_with_timing(operation, start_time)` - Log with duration tracking
- `start_operation(operation)` - Begin timing operation
- `generate_timing_summary()` - Create performance report

**Key Features**:
- Individual log files per parallel operation (`/tmp/parallel_*.log`)
- Associative arrays for PID tracking (`PARALLEL_PIDS`)
- Associative arrays for timing data (`TIMING_DATA`)
- Exit code tracking for failed operations
- Auto-cleanup of temp logs

**Based on**: `~/github/dj-dotfiles/scripts/parallel-install.sh`

### Step 2: Enhance Utility Functions
**File**: `install/utils.sh` (modify)

**Add**:
```bash
# Global variables for parallel execution
declare -A TIMING_DATA
declare -A PARALLEL_PIDS
declare -A PARALLEL_LOGS
INSTALL_START_TIME=$(date +%s)
LOG_FILE="${HOME}/dotfiles_install.log"

# Initialize log file with header
init_log_file() {
  echo "=== Dotfiles Parallel Installation Log ===" > "$LOG_FILE"
  echo "Started: $(date)" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
}

# Enhanced logging with file output
log() {
  local message="$*"
  echo -e "${CYAN}[ $(date '+%Y-%m-%d %H:%M:%S') ] $message${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}
```

### Step 3: Split Brewfile into Essential/Optional
**File**: `Brewfile.essential` (new)

**Content**:
```ruby
# Critical packages needed immediately
brew "stow"          # Required for symlinks
brew "node"          # Required for Copilot CLI
brew "nvm"           # Node version management
brew "fzf"           # Shell integration needed early
brew "neovim"        # Editor needed early
brew "tmux"          # Terminal multiplexer
```

**File**: `Brewfile.optional` (new)

**Content**:
```ruby
# Specify taps
tap "FelixKratz/formulae"
tap "timescam/homebrew-tap"

# Development tools (can install in background)
brew "bat"
brew "eza"
brew "ripgrep"
brew "fd"
brew "zoxide"
brew "pay-respects"
brew "yazi"
brew "yq"
brew "lazygit"
brew "starship"
brew "tree-sitter"
brew "tree"
brew "lua"
brew "luajit"
brew "luarocks"
brew "prettier"
brew "make"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
```

**File**: `Brewfile` (modify)

**Add comment at top**:
```ruby
# DEPRECATED: This file is kept for reference/backwards compatibility
# The installation now uses Brewfile.essential and Brewfile.optional
# for parallel installation optimization.
#
# Essential packages (installed first): See Brewfile.essential
# Optional packages (backgrounded): See Brewfile.optional
```

### Step 4: Update Homebrew Installation
**File**: `install/homebrew.sh` (modify)

**Changes**:
```bash
install_homebrew() {
  log "--- Starting Homebrew Installation ---"
  local start_time
  start_time=$(start_operation "Homebrew installation")

  if ! command -v brew &>/dev/null; then
    log "Homebrew not found. Installing Homebrew non-interactively..."
    NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ "$OS" = "Linux" ]; then
      log "Adding Linuxbrew to PATH for this session..."
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ "$OS" = "Darwin" ]; then
      log "Adding Homebrew to PATH for this session..."
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    log "Homebrew is already installed."
  fi

  log "Updating Homebrew and checking status..."
  brew update

  log_with_timing "Homebrew installation" "$start_time"
  log "--- Homebrew Installation Complete ---"
}
```

### Step 5: Parallel Package Installation
**File**: `install/packages.sh` (modify)

**Complete rewrite**:
```bash
#!/usr/bin/env bash
# Package installation from Brewfile with parallel optimization

install_packages() {
  log "--- Starting Package Installation ---"
  local start_time
  start_time=$(start_operation "Package installation phase")

  # ===================================================================
  # PHASE 1: Install essential packages (FOREGROUND)
  # ===================================================================
  if [ -f "${DOTFILES_DIR}/Brewfile.essential" ]; then
    local essential_start
    essential_start=$(start_operation "Essential packages (stow, node, fzf, neovim, tmux)")

    log "Installing essential packages from Brewfile.essential..."
    brew bundle --file="${DOTFILES_DIR}/Brewfile.essential"

    log_with_timing "Essential packages (stow, node, fzf, neovim, tmux)" "$essential_start"
  else
    log "WARNING: No Brewfile.essential found. Using legacy Brewfile."
    if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
      brew bundle --file="${DOTFILES_DIR}/Brewfile"
    fi
  fi

  # ===================================================================
  # PHASE 2: Start optional packages in BACKGROUND
  # ===================================================================
  if [ -f "${DOTFILES_DIR}/Brewfile.optional" ]; then
    start_brew_background_installation
  fi

  log_with_timing "Package installation phase" "$start_time"
  log "--- Package Installation Complete ---"
}

# Background installation of optional Homebrew packages
start_brew_background_installation() {
  local brew_log="${HOME}/.dotfiles_brew_install.log"
  local brew_pid_file="${HOME}/.dotfiles_brew_install.pid"

  log "📦 Starting optional package installation in background..."

  {
    echo "📦 Starting optional Homebrew packages installation at $(date)" > "$brew_log"
    echo "PID: $$" >> "$brew_log"
    echo "" >> "$brew_log"

    brew bundle --file="${DOTFILES_DIR}/Brewfile.optional" >> "$brew_log" 2>&1
    brew_exit_code=$?

    if [ $brew_exit_code -eq 0 ]; then
      echo "✅ Optional packages installation completed successfully" >> "$brew_log"
      echo "🎉 All packages installed at $(date)" >> "$brew_log"
    else
      echo "❌ Optional packages installation failed with exit code $brew_exit_code" >> "$brew_log"
    fi

    rm -f "$brew_pid_file"
  } &

  echo $! > "$brew_pid_file"
  log "📦 Optional packages installing in background (PID: $(cat "$brew_pid_file"))"
  log "📄 Check progress: tail -f $brew_log"
  log "🔍 Check status: scripts/check-brew-install.sh"
}
```

### Step 6: Parallel Language Installation
**File**: `install/languages.sh` (modify)

**Complete rewrite**:
```bash
#!/usr/bin/env bash
# Language and development tools installation with parallel optimization

install_languages() {
  log "--- Starting Language Tools Installation ---"
  local start_time
  start_time=$(start_operation "Language tools installation phase")

  # ===================================================================
  # PHASE 1: Install Rust in BACKGROUND (independent of Homebrew)
  # ===================================================================
  if ! command -v cargo >/dev/null 2>&1; then
    start_rust_background_installation
  else
    log "Rust & Cargo already installed: $(cargo --version)"
  fi

  # ===================================================================
  # PHASE 2: Install Copilot CLI (FOREGROUND, needs node from essential)
  # ===================================================================
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

# Background installation of Rust
start_rust_background_installation() {
  local rust_log="${HOME}/.dotfiles_rust_install.log"
  local rust_pid_file="${HOME}/.dotfiles_rust_install.pid"

  log "🦀 Starting Rust installation in background..."

  {
    echo "🦀 Starting Rust installation at $(date)" > "$rust_log"
    echo "PID: $$" >> "$rust_log"
    echo "" >> "$rust_log"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >> "$rust_log" 2>&1
    rust_exit_code=$?

    if [ $rust_exit_code -eq 0 ]; then
      echo "✅ Rust installation completed successfully" >> "$rust_log"
      echo "🎉 Rust ready at $(date)" >> "$rust_log"

      # Load cargo into PATH for subsequent shells
      echo "Loading cargo environment..." >> "$rust_log"
      source "$HOME/.cargo/env" >> "$rust_log" 2>&1
    else
      echo "❌ Rust installation failed with exit code $rust_exit_code" >> "$rust_log"
    fi

    rm -f "$rust_pid_file"
  } &

  echo $! > "$rust_pid_file"
  log "🦀 Rust installing in background (PID: $(cat "$rust_pid_file"))"
  log "📄 Check progress: tail -f $rust_log"
  log "🔍 Check status: scripts/check-rust-install.sh"
}
```

### Step 7: Update Scripts and Symlinks with Timing
**File**: `install/scripts.sh` (modify)

**Add timing**:
```bash
copy_scripts() {
  log "--- Starting Scripts Copy ---"
  local start_time
  start_time=$(start_operation "Scripts copy")

  if [ -d "${DOTFILES_DIR}/scripts" ]; then
    log "Copying scripts directory to ${HOME}..."
    cp -R "${DOTFILES_DIR}/scripts" "${HOME}/scripts"
    chmod +x "${HOME}/scripts"/*.sh 2>/dev/null || true
  else
    log "No scripts directory found. Skipping copy."
  fi

  log_with_timing "Scripts copy" "$start_time"
  log "--- Scripts Copy Complete ---"
}
```

**File**: `install/symlinks.sh` (modify)

**Add timing to stow_packages()**:
```bash
stow_packages() {
  local packages=("$@")
  local start_time
  start_time=$(start_operation "Symlink creation")

  # ... existing stow logic ...

  log_with_timing "Symlink creation" "$start_time"
  log "Stow operation complete."
}
```

### Step 8: Update Main Install Script
**File**: `install.sh` (modify)

**Add at top after sourcing utils.sh**:
```bash
# Source utility functions
source "${INSTALL_DIR}/utils.sh"

# Initialize logging and parallel framework
init_log_file
source "${INSTALL_DIR}/parallel-install.sh"

# Initialize environment
detect_os
setup_dotfiles_dir
```

**Update execution order**:
```bash
# ==============================================================================
# RUN INSTALLATION MODULES
# ==============================================================================

# Execute installation steps in optimized order
log "🚀 Starting dotfiles installation with parallel optimization..."

# PHASE 1: Bootstrap (sequential, required)
bootstrap_system

# PHASE 2: Homebrew (sequential, required for packages)
install_homebrew

# PHASE 3: Essential packages + Background jobs (parallel start)
install_packages      # Installs essential, backgrounds optional
install_languages     # Installs Copilot, backgrounds Rust

# PHASE 4: Configuration (can run immediately after essential packages)
copy_scripts
create_symlinks       # Needs stow from essential packages

# PHASE 5: Completion notification
log ""
log "################################################################"
log "#                                                              #"
log "#  ✅ Essential setup complete!                                #"
log "#                                                              #"
log "#  🔄 Background installations in progress:                    #"
log "#     - Optional Homebrew packages                            #"
log "#     - Rust toolchain                                        #"
log "#                                                              #"
log "#  📊 Monitor progress:                                        #"
log "#     tail -f ~/.dotfiles_brew_install.log                    #"
log "#     tail -f ~/.dotfiles_rust_install.log                    #"
log "#                                                              #"
log "#  🔍 Check status:                                            #"
log "#     ~/scripts/check-brew-install.sh                         #"
log "#     ~/scripts/check-rust-install.sh                         #"
log "#                                                              #"
log "################################################################"
log ""

# Generate timing summary before shell switch
generate_timing_summary

log "Reloading shell to apply all changes..."

# Replace the current shell with a new zsh login shell
exec zsh -l
```

### Step 9: Create Status Check Scripts

**File**: `scripts/check-brew-install.sh` (new)

```bash
#!/usr/bin/env bash
# Helper script to check Homebrew installation status

PID_FILE="${HOME}/.dotfiles_brew_install.pid"
LOG_FILE="${HOME}/.dotfiles_brew_install.log"

if [ ! -f "$PID_FILE" ]; then
    echo "❌ No Homebrew installation PID file found"
    echo "Either installation is complete or was never started"

    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "📄 Last few lines of installation log:"
        tail -n 5 "$LOG_FILE"
    fi

    exit 1
fi

BREW_PID=$(cat "$PID_FILE")

if ps -p "$BREW_PID" > /dev/null 2>&1; then
    echo "📦 Homebrew optional packages still installing (PID: $BREW_PID)"
    echo ""
    echo "📄 Recent progress:"
    if [ -f "$LOG_FILE" ]; then
        tail -n 10 "$LOG_FILE"
    fi
    echo ""
    echo "Commands:"
    echo "  Watch progress:  tail -f $LOG_FILE"
    echo "  Wait for finish: wait $BREW_PID"
    echo "  Check again:     $0"
else
    echo "✅ Homebrew installation has completed (PID $BREW_PID no longer running)"

    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "📄 Final status:"
        tail -n 5 "$LOG_FILE"

        if grep -q "🎉 All packages installed" "$LOG_FILE"; then
            echo ""
            echo "🎉 Installation completed successfully!"
        else
            echo ""
            echo "❌ Installation may have failed - check log for details"
        fi
    fi

    rm -f "$PID_FILE"
fi
```

**File**: `scripts/check-rust-install.sh` (new)

```bash
#!/usr/bin/env bash
# Helper script to check Rust installation status

PID_FILE="${HOME}/.dotfiles_rust_install.pid"
LOG_FILE="${HOME}/.dotfiles_rust_install.log"

if [ ! -f "$PID_FILE" ]; then
    echo "❌ No Rust installation PID file found"
    echo "Either installation is complete or was never started"

    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "📄 Last few lines of installation log:"
        tail -n 5 "$LOG_FILE"
    fi

    exit 1
fi

RUST_PID=$(cat "$PID_FILE")

if ps -p "$RUST_PID" > /dev/null 2>&1; then
    echo "🦀 Rust installation is still running (PID: $RUST_PID)"
    echo ""
    echo "📄 Recent progress:"
    if [ -f "$LOG_FILE" ]; then
        tail -n 10 "$LOG_FILE"
    fi
    echo ""
    echo "Commands:"
    echo "  Watch progress:  tail -f $LOG_FILE"
    echo "  Wait for finish: wait $RUST_PID"
    echo "  Check again:     $0"
else
    echo "✅ Rust installation has completed (PID $RUST_PID no longer running)"

    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "📄 Final status:"
        tail -n 5 "$LOG_FILE"

        if grep -q "🎉 Rust ready" "$LOG_FILE"; then
            echo ""
            echo "🎉 Installation completed successfully!"

            # Check if cargo is available
            echo ""
            echo "🔍 Checking Rust tools:"
            if command -v cargo &> /dev/null; then
                echo "  ✅ cargo: $(cargo --version)"
                echo "  ✅ rustc: $(rustc --version)"
            else
                echo "  ❌ cargo not found in PATH"
                echo "  💡 Run: source \$HOME/.cargo/env"
            fi
        else
            echo ""
            echo "❌ Installation may have failed - check log for details"
        fi
    fi

    rm -f "$PID_FILE"
fi
```

**File**: `scripts/check-copilot-install.sh` (new)

```bash
#!/usr/bin/env bash
# Helper script to check GitHub Copilot CLI installation status

if command -v copilot &> /dev/null; then
    echo "✅ GitHub Copilot CLI is installed"
    echo ""
    echo "Version information:"
    copilot --version 2>&1 || echo "  (version command not available)"
    echo ""
    echo "To use Copilot CLI:"
    echo "  copilot explain 'command'  - Explain a command"
    echo "  copilot suggest 'task'     - Suggest commands for a task"
else
    echo "❌ GitHub Copilot CLI is not installed"
    echo ""
    echo "To install manually:"
    echo "  npm install -g @github/copilot"
fi
```

### Step 10: Create Tmux Background Indicator
**File**: `scripts/tmux-background-indicator.sh` (new)

```bash
#!/usr/bin/env bash
# Background installation indicator for tmux status line

# Spinner animation frames
SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# PID files for background installations
RUST_PID_FILE="${HOME}/.dotfiles_rust_install.pid"
BREW_PID_FILE="${HOME}/.dotfiles_brew_install.pid"

# Check if any background installations are running
rust_running=false
brew_running=false

if [ -f "$RUST_PID_FILE" ]; then
    rust_pid=$(cat "$RUST_PID_FILE" 2>/dev/null)
    if [ -n "$rust_pid" ] && ps -p "$rust_pid" > /dev/null 2>&1; then
        rust_running=true
    fi
fi

if [ -f "$BREW_PID_FILE" ]; then
    brew_pid=$(cat "$BREW_PID_FILE" 2>/dev/null)
    if [ -n "$brew_pid" ] && ps -p "$brew_pid" > /dev/null 2>&1; then
        brew_running=true
    fi
fi

# If nothing is running, output nothing (indicator disappears)
if [ "$rust_running" = false ] && [ "$brew_running" = false ]; then
    exit 0
fi

# Get current spinner frame based on seconds
current_second=$(date +%s)
frame_index=$((current_second % ${#SPINNER_FRAMES[@]}))
spinner_frame=${SPINNER_FRAMES[$frame_index]}

# Build status message
status_parts=()
if [ "$rust_running" = true ]; then
    status_parts+=("🦀")
fi
if [ "$brew_running" = true ]; then
    status_parts+=("📦")
fi

# Join parts with space and add spinner
status_text=$(IFS=' '; echo "${status_parts[*]}")

# Output with color
echo "#[fg=cyan]${spinner_frame} ${status_text}#[default]"
```

### Step 11: Update Bootstrap with Timing
**File**: `install/bootstrap.sh` (modify)

**Add timing wrapper**:
```bash
bootstrap_system() {
  log "--- Starting Bootstrap Phase ---"
  local start_time
  start_time=$(start_operation "Bootstrap phase")

  # ... existing bootstrap logic ...

  log_with_timing "Bootstrap phase" "$start_time"
  log "--- Bootstrap Phase Complete ---"
}
```

## Critical Files to Modify

1. **install/utils.sh** - Add timing, parallel helpers, logging
2. **install/packages.sh** - Implement parallel package installation
3. **install/languages.sh** - Background Rust, foreground Copilot
4. **install/homebrew.sh** - Add timing
5. **install/bootstrap.sh** - Add timing
6. **install/scripts.sh** - Add timing
7. **install/symlinks.sh** - Add timing
8. **install.sh** - Orchestrate parallel execution

## New Files to Create

1. **install/parallel-install.sh** - Core parallel framework
2. **Brewfile.essential** - Critical packages
3. **Brewfile.optional** - Background packages
4. **scripts/check-brew-install.sh** - Brew status checker
5. **scripts/check-rust-install.sh** - Rust status checker
6. **scripts/check-copilot-install.sh** - Copilot status checker
7. **scripts/tmux-background-indicator.sh** - Tmux indicator

## Expected Performance Improvements

### Before (Sequential)
```
bootstrap_system:        ~20s
install_homebrew:        ~60s
install_packages:       ~240s (all 26 packages)
install_languages:      ~150s (rust + copilot)
copy_scripts:            ~2s
create_symlinks:         ~8s
-----------------------------------
TOTAL:                  ~480s (8 minutes)
```

### After (Parallel)
```
bootstrap_system:        ~20s
install_homebrew:        ~60s
install_packages:        ~40s (6 essential packages)
  └─ background:        ~200s (20 optional packages)
install_languages:       ~40s (copilot foreground)
  └─ background:        ~150s (rust in background)
copy_scripts:            ~2s
create_symlinks:         ~8s
-----------------------------------
FOREGROUND TOTAL:       ~170s (2.8 minutes)
BACKGROUND TOTAL:       ~350s (completes while user works)
USER WAIT TIME:         ~170s (2.8 minutes) ✅ 65% faster
```

## User Experience Flow

```
[0s]     🚀 Starting installation...
[20s]    ✅ Bootstrap complete
[80s]    ✅ Homebrew installed
[120s]   ✅ Essential packages installed (stow, node, fzf, neovim, tmux)
         📦 Optional packages installing in background...
[160s]   ✅ Copilot CLI installed
         🦀 Rust installing in background...
[170s]   ✅ Scripts copied
[178s]   ✅ Symlinks created

         ✅ SHELL READY! (2.9 minutes)

         [Background continues...]
         📦 Homebrew: bat, eza, ripgrep, fd, zoxide, yazi...
         🦀 Rust: cargo, rustc, toolchain...

[350s]   ✅ All background installations complete
```

## Testing Plan

1. **Fresh Installation Test**: Run on clean system, verify all packages install
2. **Resume Test**: Kill script mid-install, verify PID files clean up properly
3. **Timing Verification**: Check log file has accurate timing data
4. **Status Scripts Test**: Verify check-*.sh scripts work during and after install
5. **Background Job Test**: Verify background installations complete successfully
6. **Tmux Indicator Test**: Verify indicator appears and disappears correctly

## Rollback Plan

If issues occur, the original `Brewfile` is preserved and can be used:
```bash
# Revert to sequential installation
brew bundle --file="${DOTFILES_DIR}/Brewfile"
```

All background installations can be waited for manually:
```bash
# Wait for all background jobs
wait $(cat ~/.dotfiles_rust_install.pid)
wait $(cat ~/.dotfiles_brew_install.pid)
```

## Migration Notes

- **Backwards Compatible**: Original Brewfile kept for reference
- **No Breaking Changes**: All packages still install, just in different order
- **Opt-Out Available**: Can disable parallel mode if issues arise
- **Clean Logs**: All background jobs write to separate log files

## Success Criteria

✅ Installation completes in < 3 minutes to working shell
✅ Background installations complete successfully
✅ All timing data captured in log file
✅ Status check scripts work correctly
✅ No duplicate package installations (removed brew duplicates of cargo tools)
✅ User can start working immediately after essential tools installed
✅ Tmux indicator shows background progress
✅ Comprehensive error handling and logging
