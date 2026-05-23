#!/usr/bin/env bash
set -euo pipefail

echo "Disabling default macOS screenshot shortcuts..."

disable_symbolic_hotkey() {
  local id="$1"

  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$id" "{ enabled = 0; }"
}

disable_standard_symbolic_hotkey() {
  local id="$1"
  local ascii="$2"
  local key_code="$3"
  local modifiers="$4"

  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$id" "{ enabled = 0; value = { parameters = ($ascii, $key_code, $modifiers); type = standard; }; }"
}

# 15-26: accessibility zoom/display shortcuts that are disabled manually in System Settings.
for id in 15 16 17 18 19 20 21 22 23 24 25 26; do
  disable_symbolic_hotkey "$id"
done

# Screenshots.
disable_standard_symbolic_hotkey 28 51 20 1179648 # cmd-shift-3: screenshot to file
disable_standard_symbolic_hotkey 29 51 20 1441792 # cmd-ctrl-shift-3: screenshot to clipboard
disable_standard_symbolic_hotkey 30 52 21 1179648 # cmd-shift-4: selected area to file
disable_standard_symbolic_hotkey 31 52 21 1441792 # cmd-ctrl-shift-4: selected area to clipboard
disable_standard_symbolic_hotkey 184 53 23 1179648 # cmd-shift-5: Screenshot.app / screen recording UI
