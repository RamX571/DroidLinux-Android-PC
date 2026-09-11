#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PID_FILE="${ROOT_DIR}/droidlinux.pid"

echo "===================================="
echo "         DroidLinux Status          "
echo "===================================="

if [ -f "${ROOT_DIR}/install/system-check.sh" ]; then
    echo "Installation : OK"
else
    echo "Installation : INCOMPLETE"
fi

if command -v proot-distro >/dev/null 2>&1 && proot-distro list 2>/dev/null | grep -q "ubuntu.*installed"; then
    echo "Ubuntu       : READY"
else
    echo "Ubuntu       : NOT INSTALLED"
fi

if command -v termux-x11 >/dev/null 2>&1; then
    echo "Termux:X11   : READY"
else
    echo "Termux:X11   : NOT INSTALLED"
fi

if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}" 2>/dev/null || echo "")
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        echo "Desktop      : RUNNING (PID: $PID)"
    else
        echo "Desktop      : STOPPED (Stale PID file cleared)"
        rm -f "${PID_FILE}"
    fi
else
    echo "Desktop      : STOPPED"
fi

if [ -f /proc/meminfo ]; then
    RAM_USED_MB=$(awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {print int((total-avail)/1024)}' /proc/meminfo)
    echo "RAM usage    : ${RAM_USED_MB} MB"
fi

echo "Waydroid     : OPTIONAL / NOT CONFIGURED"
echo "===================================="
