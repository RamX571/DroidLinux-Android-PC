#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "[DroidLinux] Running automated repair diagnostic..."

mkdir -p "${ROOT_DIR}/config/environment" "${ROOT_DIR}/config/x11" "${ROOT_DIR}/config/performance"

if [ ! -f "${ROOT_DIR}/config/environment/droidlinux.env" ]; then
    echo "[DroidLinux] Restoring missing environment config..."
    cat << 'ENVCONF' > "${ROOT_DIR}/config/environment/droidlinux.env"
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.0
ENVCONF
fi

if command -v proot-distro >/dev/null 2>&1; then
    echo "[DroidLinux] Repairing Ubuntu package metadata..."
    proot-distro login ubuntu -- bash -c "apt-get update -y --fix-missing" 2>/dev/null || true
fi

echo "[DroidLinux] Repair procedure complete."
