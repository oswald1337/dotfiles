#!/usr/bin/env bash
set -euo pipefail

echo "Disabling press-and-hold for keys..."

defaults write -g ApplePressAndHoldEnabled -bool false
