#!/usr/bin/env bash
set -euo pipefail

echo "Ensuring keyboard layouts..."

ensure_keyboard_layout() {
  local name="$1"
  local id="$2"

  if defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -Fq "\"KeyboardLayout Name\" = \"${name}\";"; then
    return
  fi

  defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add "{ InputSourceKind = \"Keyboard Layout\"; \"KeyboardLayout ID\" = ${id}; \"KeyboardLayout Name\" = \"${name}\"; }"
}

ensure_keyboard_layout "U.S." 0
ensure_keyboard_layout "German" 3
