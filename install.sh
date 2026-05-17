#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${HOME}/.dotfiles-backup"
DRY_RUN=0

STOW_PACKAGES=(
  aerospace
  gh
  ghostty
  karabiner
  kitty
  nvim
  yazi
  zsh
)

LINK_TARGETS=(
  ".aerospace.toml"
  ".config/gh/config.yml"
  ".config/ghostty"
  ".config/karabiner/karabiner.json"
  ".config/kitty/kitty.conf"
  ".config/nvim"
  ".config/yazi"
  ".zshrc"
)

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run] [--skip-brew] [--skip-macos]

Options:
  --dry-run      Show what would be linked without changing files.
  --skip-brew    Skip Homebrew bootstrap and brew bundle.
  --skip-macos   Skip macOS defaults and Dock scripts.
EOF
}

SKIP_BREW=0
SKIP_MACOS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --skip-brew)
      SKIP_BREW=1
      ;;
    --skip-macos)
      SKIP_MACOS=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

run_brew_bundle() {
  ensure_homebrew

  echo "Installing packages from Brewfile..."
  brew bundle --file "${DOTFILES_DIR}/Brewfile"
}

backup_existing_targets() {
  local timestamp backup_dir target rel
  timestamp="$(date +%Y%m%d-%H%M%S)"
  backup_dir="${BACKUP_ROOT}/${timestamp}"

  for rel in "${LINK_TARGETS[@]}"; do
    target="${HOME}/${rel}"

    if [[ -L "$target" || ! -e "$target" ]]; then
      continue
    fi

    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "Would back up ${target} -> ${backup_dir}/${rel}"
      continue
    fi

    mkdir -p "${backup_dir}/$(dirname "$rel")"
    echo "Backing up ${target} -> ${backup_dir}/${rel}"
    mv "$target" "${backup_dir}/${rel}"
  done
}

ensure_stow() {
  if command -v stow >/dev/null 2>&1; then
    return
  fi

  echo "stow is not installed. Run ./install.sh without --skip-brew, or install it with: brew install stow" >&2
  exit 1
}

link_dotfiles() {
  cd "$DOTFILES_DIR"
  ensure_stow
  backup_existing_targets

  if [[ "$DRY_RUN" -eq 1 ]]; then
    stow --simulate --verbose --adopt --target "$HOME" "${STOW_PACKAGES[@]}"
    return
  fi

  stow --target "$HOME" "${STOW_PACKAGES[@]}"
}

run_macos_setup() {
  "${DOTFILES_DIR}/macos/defaults.sh"
  "${DOTFILES_DIR}/macos/dock.sh"
}

if [[ "$SKIP_BREW" -eq 0 ]]; then
  run_brew_bundle
fi

link_dotfiles

if [[ "$SKIP_MACOS" -eq 0 ]]; then
  run_macos_setup
fi

echo "Dotfiles installed."
