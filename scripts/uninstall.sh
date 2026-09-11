#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=================================================="
echo "             WARNING: DroidLinux Uninstall        "
echo "=================================================="
echo "This will remove the DroidLinux desktop and configuration."
echo "Type: REMOVE DROIDLINUX to continue:"

read -r CONFIRMATION

if [ "$CONFIRMATION" != "REMOVE DROIDLINUX" ]; then
    echo "Uninstallation canceled."
    return 0 2>/dev/null || true
fi

echo "Stopping active sessions..."
bash "${SCRIPT_DIR}/stop.sh" || true

if command -v proot-distro >/dev/null 2>&1; then
    echo "Removing Ubuntu userspace..."
    proot-distro remove ubuntu 2>/dev/null || true
fi

echo "Removing local runtime state..."
rm -rf "${ROOT_DIR}/install.log" "${ROOT_DIR}/droidlinux.pid"

echo "DroidLinux uninstallation finished cleanly."
