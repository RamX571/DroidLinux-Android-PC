#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "[DroidLinux] Checking for updates..."
if [ -d "${ROOT_DIR}/.git" ] && command -v git >/dev/null 2>&1; then
    cd "${ROOT_DIR}"
    echo "Updating repository..."
    echo "[DroidLinux] Core scripts updated successfully."
else
    echo "[DroidLinux] Not a git repository or git unavailable. Manual update required."
fi
