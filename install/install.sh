#!/usr/bin/env bash
# ==============================================================================
# DroidLinux Master Installation Orchestrator
# ==============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_FILE="${ROOT_DIR}/install.log"

echo "=== Starting DroidLinux Installation: $(date) ===" > "${LOG_FILE}"

banner() {
    echo "=========================================================="
    echo "            🚀 Welcome to DroidLinux PC                  "
    echo "   Fast, Lightweight PC-like Linux Environment for Android"
    echo "=========================================================="
}

banner

echo "[1/8] Running System Health Check..."
bash "${SCRIPT_DIR}/system-check.sh" | tee -a "${LOG_FILE}"

echo "[2/8] Installing Termux Dependencies..."
if command -v pkg >/dev/null 2>&1; then
    pkg update -y || true
    pkg install -y termux-x11-nightly proot-distro pulseaudio x11-repo || pkg install -y termux-x11 proot-distro pulseaudio || true
else
    echo "pkg tool not available in non-Termux host environment. Skipping pkg step." | tee -a "${LOG_FILE}"
fi

echo "[3/8] Setting up Ubuntu Userspace..."
bash "${SCRIPT_DIR}/ubuntu.sh" | tee -a "${LOG_FILE}"

echo "[4/8] Installing Desktop Environment & Termux:X11 Config..."
bash "${SCRIPT_DIR}/desktop.sh" | tee -a "${LOG_FILE}"

echo "[5/8] Applying Performance Configurations..."
mkdir -p "${ROOT_DIR}/config/environment"
cat << 'ENVCONF' > "${ROOT_DIR}/config/environment/droidlinux.env"
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.0
ENVCONF

echo "[6/8] Installing Desktop Applications..."
bash "${SCRIPT_DIR}/apps.sh" | tee -a "${LOG_FILE}"

echo "[7/8] Running Waydroid Compatibility Assessment..."
bash "${SCRIPT_DIR}/waydroid.sh" | tee -a "${LOG_FILE}"

echo "[8/8] Installing Management CLI..."
mkdir -p "${PREFIX:-/data/data/com.termux/files/usr}/bin" 2>/dev/null || true
if [ -w "${PREFIX:-/usr}/bin" ]; then
    ln -sf "${ROOT_DIR}/scripts/droidlinux" "${PREFIX:-/usr}/bin/droidlinux" || true
fi

echo "=========================================================="
echo "      ✅ DroidLinux Installation Completed Successfully!  "
echo "  Run 'bash scripts/droidlinux start' to launch desktop   "
echo "=========================================================="
