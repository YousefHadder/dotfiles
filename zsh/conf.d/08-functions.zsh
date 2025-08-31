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

# If you use envman, add the following to your shell configuration:
# [ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
