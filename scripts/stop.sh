#!/usr/bin/env bash
# ==============================================================================
# DroidLinux Session Teardown Script
# ==============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PID_FILE="${ROOT_DIR}/droidlinux.pid"

echo "[DroidLinux] Stopping active desktop session..."

if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}" 2>/dev/null || echo "")
    if [ -n "$PID" ]; then
        kill "$PID" 2>/dev/null || kill -9 "$PID" 2>/dev/null || true
    fi
    rm -f "${PID_FILE}"
fi

if command -v pkill >/dev/null 2>&1; then
    pkill -f "startxfce4" 2>/dev/null || true
fi

echo "[DroidLinux] Desktop session stopped cleanly."
