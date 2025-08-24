# FZF Configuration

eval "$(fzf --zsh)"

# Explicit key bindings for Warp compatibility
bindkey '^R' fzf-history-widget
bindkey '^T' fzf-file-widget
bindkey '^[c' fzf-cd-widget

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}' --height 50% --layout=default --border --color=hl:#2dd4bf --layout=default --border --color=hl:#2dd4bf"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#ebebf4,fg+:#ebebf4,bg:#19191f,bg+:#557799
  --color=hl:#89A7B1,hl+:#9eb2d9,info:#ffcc99,marker:#337700
  --color=prompt:#cc4455,spinner:#89A7B1,pointer:#89A7B1,header:#515166
  --color=border:#89A7B1,separator:#515166,label:#ebebf4,query:#ebebf4
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "

source ~/scripts/fzf-git.sh