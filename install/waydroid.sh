#!/usr/bin/env bash
# ==============================================================================
# DroidLinux Waydroid Compatibility Check & Optional Installer
# ==============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/../install.log"

log() {
    echo "[WAYDROID] $1" | tee -a "${LOG_FILE}"
}

check_waydroid_compatibility() {
    log "Running Waydroid compatibility check..."
    local arch
    arch=$(uname -m)

    log "Detected Architecture: ${arch}"

    if [ -e /dev/binder ] || [ -e /dev/binderfs ]; then
        log "Binder IPC nodes detected."
    else
        log "NOTICE: Binder IPC kernel modules not detected. Waydroid requires kernel binder support."
    fi

    if [ -e /dev/ashmem ]; then
        log "Ashmem driver detected."
    else
        log "NOTICE: Ashmem driver not detected."
    fi

    log "Waydroid status: OPTIONAL / NOT VERIFIED for this kernel configuration."
    log "To preserve base desktop stability, Waydroid installation is skipped by default."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    check_waydroid_compatibility
fi
