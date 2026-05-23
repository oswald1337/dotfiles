#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for script in "${SCRIPT_DIR}"/defaults/*.sh; do
  "$script"
done

echo "Restarting macOS preference services..."
killall cfprefsd || true
killall SystemUIServer || true

echo "Done. You may need to log out and back in."
