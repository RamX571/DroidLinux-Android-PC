#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PID_FILE="${ROOT_DIR}/droidlinux.pid"

if [ -f "${PID_FILE}" ]; then
    PID=$(cat "${PID_FILE}" 2>/dev/null || echo "")
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        echo "[DroidLinux] Session is already running (PID: $PID)."
        return 0 2>/dev/null || true
    fi
fi

echo "[DroidLinux] Starting Termux:X11 display server..."
if command -v termux-x11 >/dev/null 2>&1; then
    termux-x11 :0 -ac >/dev/null 2>&1 &
fi

echo "[DroidLinux] Starting PulseAudio server..."
if command -v pulseaudio >/dev/null 2>&1; then
    pulseaudio --start --load="module-native-protocol-tcp auth-anonymous=1" --exit-idle-time=-1 >/dev/null 2>&1 || true
fi

echo "[DroidLinux] Launching Ubuntu XFCE Desktop session..."
if [ -f "${ROOT_DIR}/config/environment/droidlinux.env" ]; then
    source "${ROOT_DIR}/config/environment/droidlinux.env"
fi

if command -v proot-distro >/dev/null 2>&1; then
    proot-distro login ubuntu -- bash -c "
        export DISPLAY=:0
        export PULSE_SERVER=127.0.0.1
        exec startxfce4
    " >/dev/null 2>&1 &
    SESSION_PID=$!
    echo $SESSION_PID > "${PID_FILE}"
    echo "[DroidLinux] Desktop session launched (PID: ${SESSION_PID})."
else
    echo "[DroidLinux] proot-distro not found. Please run installation first."
fi
