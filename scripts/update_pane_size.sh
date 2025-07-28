#!/usr/bin/env bash
# ~/scripts/update_pane_size.sh
# Updates the pane size variable when pane changes or resizes

# Get the current pane dimensions
pane_width=$(tmux display-message -p '#{pane_width}')
pane_height=$(tmux display-message -p '#{pane_height}')

# Update the tmux variable
tmux set-option -g @pane_size "${pane_width}x${pane_height}"

# Force status bar refresh
tmux refresh-client -S
