#!/bin/bash
# Net speed monitor for macOS tmux status bar
# Uses netstat to calculate network throughput

CACHE_DIR="/tmp/tmux_net_speed"
DOWNLOAD_FILE="$CACHE_DIR/download"
UPLOAD_FILE="$CACHE_DIR/upload"
TIMESTAMP_FILE="$CACHE_DIR/timestamp"

mkdir -p "$CACHE_DIR"

# Get current bytes from netstat (works on macOS)
get_bytes() {
    # netstat -ib shows interface bytes
    # Sum all non-loopback interfaces
    netstat -ib 2>/dev/null | awk '
        NR > 1 && $1 !~ /^lo/ && $7 ~ /^[0-9]+$/ && $10 ~ /^[0-9]+$/ {
            rx += $7
            tx += $10
        }
        END { print rx, tx }
    '
}

format_speed() {
    local bytes=$1
    if (( bytes >= 1048576 )); then
        printf "%.1fM" "$(echo "scale=1; $bytes / 1048576" | bc)"
    elif (( bytes >= 1024 )); then
        printf "%.0fK" "$(echo "scale=0; $bytes / 1024" | bc)"
    else
        printf "%dB" "$bytes"
    fi
}

main() {
    local current_bytes
    current_bytes=$(get_bytes)
    local current_rx=${current_bytes%% *}
    local current_tx=${current_bytes##* }
    local current_time
    current_time=$(date +%s)

    # Read previous values
    local prev_rx=0 prev_tx=0 prev_time=0
    [[ -f "$DOWNLOAD_FILE" ]] && prev_rx=$(< "$DOWNLOAD_FILE")
    [[ -f "$UPLOAD_FILE" ]] && prev_tx=$(< "$UPLOAD_FILE")
    [[ -f "$TIMESTAMP_FILE" ]] && prev_time=$(< "$TIMESTAMP_FILE")

    # Save current values
    echo "$current_rx" > "$DOWNLOAD_FILE"
    echo "$current_tx" > "$UPLOAD_FILE"
    echo "$current_time" > "$TIMESTAMP_FILE"

    # Calculate speeds
    local elapsed=$((current_time - prev_time))
    if (( elapsed <= 0 || prev_time == 0 )); then
        echo "↓ --.- ↑ --.-"
        return
    fi

    local rx_speed=$(( (current_rx - prev_rx) / elapsed ))
    local tx_speed=$(( (current_tx - prev_tx) / elapsed ))

    # Handle negative values (interface reset, etc)
    (( rx_speed < 0 )) && rx_speed=0
    (( tx_speed < 0 )) && tx_speed=0

    local rx_fmt tx_fmt
    rx_fmt=$(format_speed "$rx_speed")
    tx_fmt=$(format_speed "$tx_speed")

    printf "↓%s ↑%s" "$rx_fmt" "$tx_fmt"
}

main
