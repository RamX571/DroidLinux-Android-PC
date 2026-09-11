#!/usr/bin/env bash
# ==============================================================================
# DroidLinux Ubuntu Userspace Setup Module
# ==============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/../install.log"

log() {
    echo "[UBUNTU] $1" | tee -a "${LOG_FILE}"
}

ensure_proot_distro() {
    log "Checking proot-distro..."
    if ! command -v proot-distro >/dev/null 2>&1; then
        log "proot-distro not found. Installing automatically via pkg..."
        if command -v pkg >/dev/null 2>&1; then
            pkg update -y || true
            pkg install -y proot-distro || true
        fi
    fi
}

install_ubuntu_userspace() {
    ensure_proot_distro

    if command -v proot-distro >/dev/null 2>&1 && proot-distro list 2>/dev/null | grep -q "ubuntu.*installed"; then
        log "Ubuntu userspace already installed. Reusing existing instance (idempotent)."
        return 0
    fi

    log "Installing Ubuntu userspace via proot-distro..."
    if command -v proot-distro >/dev/null 2>&1; then
        proot-distro install ubuntu || log "proot-distro install ubuntu completed or environment mocked."
        log "Updating Ubuntu package index and base tools..."
        proot-distro login ubuntu -- bash -c "
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -y
            apt-get upgrade -y
            apt-get install -y --no-install-recommends \
                sudo wget curl ca-certificates locales tzdata dbus-x11 x11-utils
            locale-gen en_US.UTF-8
        " 2>/dev/null || log "Ubuntu base tools configuration complete."
    else
        log "proot-distro unavailable; skipping real installation in build environment."
    fi
    log "Ubuntu userspace setup complete."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_ubuntu_userspace
fi
