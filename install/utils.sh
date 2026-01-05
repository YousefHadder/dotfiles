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
declare -A TIMING_DATA
INSTALL_START_TIME=$(date +%s)
LOG_FILE="${HOME}/dotfiles_install.log"

# Initialize log file with header
init_log_file() {
  echo "=== Dotfiles Installation Log ===" > "$LOG_FILE"
  echo "Started: $(date)" >> "$LOG_FILE"
  echo "OS: $(uname)" >> "$LOG_FILE"
  echo "User: $(whoami)" >> "$LOG_FILE"
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

# Success logging with green color
log_success() {
  local message="$*"
  echo -e "${GREEN}[ $(date '+%Y-%m-%d %H:%M:%S') ] ✅ $message${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ $message" >> "$LOG_FILE"
}

# Warning logging with yellow color
log_warning() {
  local message="$*"
  echo -e "${YELLOW}[ $(date '+%Y-%m-%d %H:%M:%S') ] ⚠️  $message${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️  $message" >> "$LOG_FILE"
}

# Error logging with red color
log_error() {
  local message="$*"
  echo -e "${RED}[ $(date '+%Y-%m-%d %H:%M:%S') ] ❌ $message${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ $message" >> "$LOG_FILE"
}

# Info logging with blue color
log_info() {
  local message="$*"
  echo -e "${BLUE}[ $(date '+%Y-%m-%d %H:%M:%S') ] ℹ️  $message${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ℹ️  $message" >> "$LOG_FILE"
}

# Section header with bold
log_section() {
  local message="$*"
  echo ""
  echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${MAGENTA}  $message${NC}"
  echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "" >> "$LOG_FILE"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$LOG_FILE"
  echo "  $message" >> "$LOG_FILE"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
}

# Progress indicator
log_progress() {
  local current="$1"
  local total="$2"
  local message="$3"
  local percent=$((current * 100 / total))
  echo -e "${CYAN}[ $(date '+%Y-%m-%d %H:%M:%S') ] [${current}/${total}] (${percent}%) $message${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${current}/${total}] (${percent}%) $message" >> "$LOG_FILE"
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

  # Use green color for success
  echo -e "${GREEN}[ $(date '+%Y-%m-%d %H:%M:%S') ] ✅ $operation (${duration}s)${NC}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ $operation (${duration}s)" >> "$LOG_FILE"
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

  {
    echo ""
    echo "=== PERFORMANCE INSIGHTS ==="
  } >> "$LOG_FILE"

  # Categorize slow operations
  local slow_ops=()
  local medium_ops=()
  for operation in "${!TIMING_DATA[@]}"; do
    local duration=${TIMING_DATA[$operation]}
    if [ "$duration" -ge 60 ]; then
      slow_ops+=("$operation (${duration}s)")
    elif [ "$duration" -ge 10 ]; then
      medium_ops+=("$operation (${duration}s)")
    fi
  done

  if [ ${#slow_ops[@]} -gt 0 ]; then
    {
      echo "🐌 Operations taking >60s:"
      printf '  %s\n' "${slow_ops[@]}"
      echo ""
    } >> "$LOG_FILE"
  fi

  if [ ${#medium_ops[@]} -gt 0 ]; then
    {
      echo "⚠️  Operations taking 10-60s:"
      printf '  %s\n' "${medium_ops[@]}"
      echo ""
    } >> "$LOG_FILE"
  fi

  echo "Completed: $(date)" >> "$LOG_FILE"

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
declare -a BACKGROUND_JOBS
declare -A BACKGROUND_JOB_NAMES

# Track a background job
track_background_job() {
  local pid="$1"
  local name="$2"
  BACKGROUND_JOBS+=("$pid")
  BACKGROUND_JOB_NAMES["$pid"]="$name"
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

  for pid in "${BACKGROUND_JOBS[@]}"; do
    local job_name="${BACKGROUND_JOB_NAMES[$pid]}"
    log_progress $((completed + 1)) "$total" "Waiting for: $job_name"

    if wait "$pid"; then
      completed=$((completed + 1))
      log_success "$job_name completed successfully"
    else
      local exit_code=$?
      completed=$((completed + 1))
      log_error "$job_name failed with exit code $exit_code"
      failed_jobs+=("$job_name")
    fi
  done

  if [ ${#failed_jobs[@]} -gt 0 ]; then
    log_warning "${#failed_jobs[@]} background job(s) failed:"
    printf '  - %s\n' "${failed_jobs[@]}" | while IFS= read -r line; do
      log_error "$line"
    done
    return 1
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