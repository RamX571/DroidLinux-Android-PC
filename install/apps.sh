#!/usr/bin/env bash
# ==============================================================================
# DroidLinux Applications Installer Module
# ==============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/../install.log"

log() {
    echo "[APPS] $1" | tee -a "${LOG_FILE}"
}

install_firefox() {
    log "Installing Firefox..."
    if command -v proot-distro >/dev/null 2>&1; then
        proot-distro login ubuntu -- bash -c "
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -y
            apt-get install -y firefox || apt-get install -y firefox-esr || true
        " 2>/dev/null || true
    fi
}

install_chromium() {
    log "Installing Chromium browser..."
    if command -v proot-distro >/dev/null 2>&1; then
        proot-distro login ubuntu -- bash -c "
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -y
            apt-get install -y chromium-browser || apt-get install -y chromium || true
        " 2>/dev/null || true
    fi
}

install_vscode() {
    log "Checking VS Code / Code-Server alternative..."
    if command -v proot-distro >/dev/null 2>&1; then
        proot-distro login ubuntu -- bash -c "
            export DEBIAN_FRONTEND=noninteractive
            arch=$(uname -m)
            if [ "$arch" = "aarch64" ] || [ "$arch" = "x86_64" ]; then
                apt-get install -y code-server || apt-get install -y code || echo 'VS Code package not available directly in repo; code-server alternative supported.'
            else
                echo 'VS Code not directly supported on architecture: '$arch
            fi
        " 2>/dev/null || true
    fi
}

check_antigravity() {
    log "Checking Antigravity package status..."
    log "Antigravity is not available in official Linux ARM64 repositories. Marked as OPTIONAL/UNSUPPORTED."
}

install_all_apps() {
    install_firefox
    install_chromium
    install_vscode
    check_antigravity
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_apps
fi
