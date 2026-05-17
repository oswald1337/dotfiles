#!/usr/bin/env bash
set -euo pipefail

echo "Enabling tap-to-click..."

# Built-in MacBook trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Magic Trackpad / Bluetooth trackpads
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Global tap behavior
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Login screen tap-to-click, optional
sudo defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Restart preferences daemon
killall cfprefsd || true

echo "Done. You may need to log out and back in."

