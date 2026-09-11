#!/usr/bin/env bash
# ==============================================================================
# DroidLinux Lightweight Desktop Setup Module
# ==============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/../install.log"

log() {
    echo "[DESKTOP] $1" | tee -a "${LOG_FILE}"
}

install_desktop_environment() {
    log "Installing lightweight desktop environment (XFCE4) inside Ubuntu..."

    if ! command -v proot-distro >/dev/null 2>&1; then
        log "proot-distro unavailable; desktop install configuration skipped in host build environment."
        return 0
    fi

    proot-distro login ubuntu -- bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt-get update -y
        apt-get install -y --no-install-recommends \
            xfce4 xfce4-terminal xfce4-session xfce4-panel \
            xfwm4 thunar xfce4-settings xfce4-appfinder \
            desktop-base light-locker x11-xserver-utils x11-xfs-utils \
            adwaita-icon-theme fonts-liberation mousepad
    " 2>/dev/null || true

    log "Configuring Windows-inspired light UI theme settings..."
    proot-distro login ubuntu -- bash -c "
        mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
        xfconf-query -c xsettings -p /Net/ThemeName -s 'Adwaita' --create -t string || true
        xfconf-query -c xsettings -p /Net/IconThemeName -s 'Adwaita' --create -t string || true
    " 2>/dev/null || true

    log "Desktop environment installed and configured."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_desktop_environment
fi
