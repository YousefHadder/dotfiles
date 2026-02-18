#!/usr/bin/env bash
# Shared utility functions for dotfiles installation

# ==============================================================================
# COLOR CODES
# ==============================================================================
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ==============================================================================
# TIMING AND LOGGING INFRASTRUCTURE
# ==============================================================================

# Global variables for timing
TIMING_KEYS=()
TIMING_VALUES=()
INSTALL_START_TIME=$(date +%s)
LOG_FILE="${HOME}/dotfiles_install.log"

# Internal helper: append a single line to the log file with file locking.
# This prevents multiple background jobs from corrupting the log.
_log_append() {
  local line="$1"
  {
    flock -w 10 200 || return
    printf '%s\n' "$line" >> "$LOG_FILE"
  } 200>"${LOG_FILE}.lock"
}

# Initialize log file with header
init_log_file() {
  # Truncate existing log file (if any) once at the start
  : > "$LOG_FILE"
  _log_append "=== Dotfiles Installation Log ==="
  _log_append "Started: $(date)"
  _log_append "OS: $(uname)"
  _log_append "User: $(whoami)"
  _log_append ""
}

# Enhanced logging - writes to both console and file
log() {
  local message="$*"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  # Console output (with color)
  echo -e "${CYAN}[ ${timestamp} ] $message${NC}"
  # File output (no color codes, with locking)
  _log_append "[${timestamp}] $message"
}

# Success logging with green color
log_success() {
  local message="$*"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${GREEN}[ ${timestamp} ] ✅ $message${NC}"
  _log_append "[${timestamp}] ✅ $message"
}

# Warning logging with yellow color
log_warning() {
  local message="$*"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${YELLOW}[ ${timestamp} ] ⚠️ $message${NC}"
  _log_append "[${timestamp}] ⚠️ $message"
}

# Error logging with red color
log_error() {
  local message="$*"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${RED}[ ${timestamp} ] ❌ $message${NC}"
  _log_append "[${timestamp}] ❌ $message"
}

# Info logging with blue color
log_info() {
  local message="$*"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${BLUE}[ ${timestamp} ] ℹ️ $message${NC}"
  _log_append "[${timestamp}] ℹ️ $message"
}

# Section header with bold
log_section() {
  local message="$*"
  echo ""
  echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${MAGENTA}  $message${NC}"
  echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  _log_append ""
  _log_append "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  _log_append "  $message"
  _log_append "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  _log_append ""
}

# Progress indicator
log_progress() {
  local current="$1"
  local total="$2"
  local message="$3"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  local percent=$((current * 100 / total))
  echo -e "${CYAN}[ ${timestamp} ] [${current}/${total}] (${percent}%) $message${NC}"
  _log_append "[${timestamp}] [${current}/${total}] (${percent}%) $message"
}

# Start timing an operation
start_operation() {
  local operation="$1"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  _log_append "[${timestamp}] 🔄 Starting: $operation"
  date +%s  # Return current timestamp
}

# Log operation completion with timing
log_with_timing() {
  local operation="$1"
  local start_time="$2"
  local end_time
  end_time=$(date +%s)
  local duration=$((end_time - start_time))
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

  TIMING_KEYS+=("$operation")
  TIMING_VALUES+=("$duration")

  # Use green color for success
  echo -e "${GREEN}[ ${timestamp} ] ✅ $operation (${duration}s)${NC}"
  _log_append "[${timestamp}] ✅ $operation (${duration}s)"
}

# Generate timing summary at end
generate_timing_summary() {
  local total_time
  total_time=$(($(date +%s) - INSTALL_START_TIME))

  _log_append ""
  _log_append "=== TIMING SUMMARY ==="
  _log_append "Total installation time: ${total_time}s ($((total_time / 60))m $((total_time % 60))s)"
  _log_append ""
  _log_append "Operations by duration (longest first):"

  # Sort timing data by duration (longest first)
  for i in "${!TIMING_KEYS[@]}"; do
    echo "${TIMING_VALUES[$i]} ${TIMING_KEYS[$i]}"
  done | sort -nr | while read -r duration op; do
    if [ "$duration" -ge 60 ]; then
      _log_append "  $op: ${duration}s ($((duration / 60))m $((duration % 60))s)"
    else
      _log_append "  $op: ${duration}s"
    fi
  done

  _log_append ""
  _log_append "=== PERFORMANCE INSIGHTS ==="

  # Categorize slow operations
  local slow_ops=()
  local medium_ops=()
  for i in "${!TIMING_KEYS[@]}"; do
    local operation="${TIMING_KEYS[$i]}"
    local duration="${TIMING_VALUES[$i]}"
    if [ "$duration" -ge 60 ]; then
      slow_ops+=("$operation (${duration}s)")
    elif [ "$duration" -ge 10 ]; then
      medium_ops+=("$operation (${duration}s)")
    fi
  done

  if [ ${#slow_ops[@]} -gt 0 ]; then
    _log_append "🐌 Operations taking >60s:"
    for op in "${slow_ops[@]}"; do
      _log_append "  $op"
    done
    _log_append ""
  fi

  if [ ${#medium_ops[@]} -gt 0 ]; then
    _log_append "⚠️ Operations taking 10-60s:"
    for op in "${medium_ops[@]}"; do
      _log_append "  $op"
    done
    _log_append ""
  fi

  _log_append "Completed: $(date)"

  # Also print summary to console
  echo ""
  echo -e "${CYAN}=== Installation Complete ===${NC}"
  echo -e "${CYAN}Total time: ${total_time}s ($((total_time / 60))m $((total_time % 60))s)${NC}"
  echo -e "${CYAN}Full log: $LOG_FILE${NC}"
  echo ""
}

# ==============================================================================
# BACKGROUND JOB MANAGEMENT
# ==============================================================================

# Global array to track background job PIDs
BACKGROUND_JOBS=()
BACKGROUND_JOB_NAME_LIST=()

# Track a background job
track_background_job() {
  local pid="$1"
  local name="$2"
  BACKGROUND_JOBS+=("$pid")
  BACKGROUND_JOB_NAME_LIST+=("$name")
  log_info "Tracking background job: $name (PID: $pid)"
}

# Wait for all background jobs to complete
wait_for_background_jobs() {
  if [ ${#BACKGROUND_JOBS[@]} -eq 0 ]; then
    log_info "No background jobs to wait for"
    return 0
  fi

  log_section "Waiting for Background Jobs"
  log_info "Waiting for ${#BACKGROUND_JOBS[@]} background job(s) to complete..."
  local failed_jobs=()
  local completed=0
  local total=${#BACKGROUND_JOBS[@]}

  for i in "${!BACKGROUND_JOBS[@]}"; do
    local pid="${BACKGROUND_JOBS[$i]}"
    local job_name="${BACKGROUND_JOB_NAME_LIST[$i]}"
    log_progress "$((completed + 1))" "$total" "Waiting for: $job_name"

    if wait "$pid"; then
      completed=$((completed + 1))
      log_success "$job_name completed successfully"
    else
      # Any non-zero exit from wait indicates that the job did not complete cleanly.
      # Treat this as a warning while allowing the overall installation to continue.
      local exit_code=$?
      completed=$((completed + 1))
      log_warning "$job_name completed with warnings (exit code: $exit_code; some operations may have failed)"
      failed_jobs+=("$job_name")
    fi
  done

  if [ ${#failed_jobs[@]} -gt 0 ]; then
    log_warning "${#failed_jobs[@]} background job(s) completed with warnings:"
    printf '  - %s\n' "${failed_jobs[@]}" | while IFS= read -r line; do
      log_warning "$line"
    done
    log_info "Installation will continue - check log file for details"
    # Return 0 to not fail the entire installation
    return 0
  else
    log_success "All background jobs completed successfully"
    return 0
  fi
}

# ==============================================================================
# ENVIRONMENT DETECTION
# ==============================================================================

# --- OS Detection ---
detect_os() {
  export OS=$(uname)
  log "Detected OS: $OS"
}

# --- Directory Setup ---
setup_dotfiles_dir() {
  # Detect if running in a GitHub Codespace and set dotfiles directory accordingly
  if [ "${CODESPACES:-false}" = "true" ]; then
    export DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"
    log "Codespace environment detected."
  else
    export DOTFILES_DIR="${HOME}/dotfiles"
    log "Standard environment detected."
  fi
  log "Dotfiles directory set to: ${DOTFILES_DIR}"
}