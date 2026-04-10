# Custom Functions

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function gpp() {
  if [ -z "$1" ]; then echo "usage: gpp file.cpp"; return 1; fi
  local src="$1"
  local out="${src%.*}"
  local CXX=""
  for c in g++-15 g++-13 g++-12 g++; do
    if command -v "$c" >/dev/null 2>&1; then CXX="$c"; break; fi
  done
  if [ -z "$CXX" ]; then echo "No g++ found (brew install gcc)"; return 1; fi
  "$CXX" -std=gnu++17 -O2 -Wall -Wextra "$src" -o "$out"
}

function grun() { gpp "$1" && "./${1%.*}"; }

function gsw() {
  local branch
  branch=$(
    git branch -a --format='%(refname:short)' \
      | sed 's|^origin/||' \
      | sort -u \
      | fzf --tmux center,60%,50% --border --reverse \
          --header "Switch branch" \
          --preview 'git log --oneline --graph --color=always {} | head -20'
  )
  [[ -n "$branch" ]] && git switch "$branch"
}

function secret-set() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: secret-set <KEY_NAME> <value>"
    return 1
  fi
  security add-generic-password -U -a "$USER" -s "$1" -w "$2"
  echo "Stored $1"
}

function secret-get() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: secret-get <KEY_NAME>"
    return 1
  fi
  security find-generic-password -a "$USER" -s "$1" -w 2>/dev/null
}

function ghf() {
  local cmd
  cmd=$(
    printf '%s\n' \
      "pagerduty oncall --all" \
      "port find team" \
      "port find owner" \
      "port auth status" \
      "extension upgrade --all" \
      "hubber-skills install" \
      "cs create" \
      "dash" \
      "enhance" \
      "slack" \
      "aw" \
      | fzf --tmux center,50%,40% --border --reverse --header "gh command"
  )
  [[ -n "$cmd" ]] && print -z "gh $cmd "
}

function help-me() {
  local entry cmd
  entry=$(
    printf '%s\n' \
      "gfp :: git fetch && git pull" \
      "gsm :: git switch main && git fetch && git pull" \
      "gpe :: git push-empty" \
      "gsw :: fuzzy switch git branches" \
      "secret-set <KEY> <VALUE> :: store macOS keychain secret" \
      "secret-get <KEY> :: read macOS keychain secret" \
      "ghf :: fuzzy picker for common gh subcommands" \
      "cpenv :: copy env var value to clipboard (fzf)" \
      "sourcezsh :: reload zsh" \
      | fzf --tmux center,75%,55% --border --reverse \
          --header "Shell aliases, functions, and integrations"
  ) || return 0

  [[ -z "$entry" ]] && return 0
  cmd="${entry%% :: *}"
  print -z "$cmd"
}

# If you use envman, add the following to your shell configuration:
# [ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
