#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PID_FILE="${ROOT_DIR}/droidlinux.pid"

echo "[DroidLinux] Stopping desktop session..."

if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}" 2>/dev/null || echo "")
    if [ -n "$PID" ]; then
        kill -9 "$PID" 2>/dev/null || true
    fi
    rm -f "${PID_FILE}"
fi

if command -v pkill >/dev/null 2>&1; then
    pkill -f termux-x11 2>/dev/null || true
    pkill -f xfce4-session 2>/dev/null || true
fi

echo "[DroidLinux] Session stopped cleanly."
