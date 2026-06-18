#!/usr/bin/env bash
set -euo pipefail

echo "Configuring key repeat..."

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
