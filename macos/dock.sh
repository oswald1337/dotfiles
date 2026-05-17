#!/usr/bin/env bash
set -euo pipefail

echo "Configuring Dock..."

# Hide Dock by default.
defaults write com.apple.dock autohide -bool true

# Remove the reveal delay and keep the animation quick.
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Keep the Dock compact and focused.
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock show-recents -bool false

# Apply changes.
killall Dock || true

echo "Done."
