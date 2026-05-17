function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt append_history       # Don't overwrite history
setopt share_history        # Share history between tabs
setopt hist_ignore_dups     # Don't record same command twice
setopt hist_ignore_space    # Don't record commands starting with space

# 2. Completion System
# autoload -Uz compinit && compinit
# zstyle ':completion:*' menu select              # Arrow key navigation in tabs
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case-insensitive completion
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 3. Quality of Life
setopt autocd               # Just type directory name to enter
bindkey -e                  # Use Emacs-style keys (Ctrl-A, Ctrl-E, etc.)

# 4. Prompt (Clean & Minimal)
# Green arrow, Blue directory. Turns red if previous command failed.
PROMPT='%F{blue}%~%f %(?.%F{green}.%F{red})❯%f '

# EZA
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

cpfile() {
  if [ -z "$1" ]; then
    echo "Usage: cpfile <path>"
    return 1
  fi

  if [ ! -e "$1" ]; then
    echo "File not found: $1"
    return 1
  fi

  osascript -e "set the clipboard to POSIX file \"$(realpath "$1")\""
}

export PATH="$HOME/.local/bin:$PATH"

