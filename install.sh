#!/usr/bin/env bash
# ==============================================================================
# DROIDLINUX ANDROID PC — ONE-COMMAND BOOTSTRAP INSTALLER
# ==============================================================================

set -Eeuo pipefail

CYAN="[0;36m"
GREEN="[0;32m"
YELLOW="[1;33m"
RED="[0;31m"
NC="[0m"
BOLD="[1m"

INSTALL_DIR="${HOME}/.droidlinux"

mkdir -p "${INSTALL_DIR}"

banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║       🖥️  DROIDLINUX ANDROID PC             ║"
    echo "║                                              ║"
    echo "║       Linux Desktop for Android              ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

banner

echo -e "${CYAN}[*] Step 1/12: Checking and preparing Termux package manager...${NC}"
if command -v pkg >/dev/null 2>&1; then
    echo "[+] Updating Termux package list..."
    pkg update -y || true
else
    echo -e "${YELLOW}[!] Non-Termux environment or 'pkg' unavailable. Proceeding with standard environment.${NC}"
fi

echo -e "${CYAN}[*] Step 2/12: Bootstrapping core tools (curl, wget, git, tar)...${NC}"
if command -v pkg >/dev/null 2>&1; then
    pkg install -y curl wget tar git || true
fi

echo -e "${CYAN}[*] Step 3/12: Configuring X11 repositories & Termux:X11 packages...${NC}"
if command -v pkg >/dev/null 2>&1; then
    pkg install -y x11-repo || true
    pkg install -y termux-x11-nightly pulseaudio || pkg install -y termux-x11 pulseaudio || true
fi

echo -e "${CYAN}[*] Step 4/12: Bootstrapping proot-distro...${NC}"
if command -v pkg >/dev/null 2>&1; then
    pkg install -y proot-distro || true
fi

echo -e "${CYAN}[*] Step 5/12: Cloning or updating DroidLinux codebase...${NC}"
if [ -d "${INSTALL_DIR}/.git" ] && command -v git >/dev/null 2>&1; then
    echo "[+] Updating existing repository in ${INSTALL_DIR}..."
    cd "${INSTALL_DIR}"
    echo "Updating workspace..."
elif [ -f "$(pwd)/install/system-check.sh" ]; then
    echo "[+] Running from local workspace..."
    INSTALL_DIR="$(pwd)"
else
    echo "[+] Fetching DroidLinux source code into ${INSTALL_DIR}..."
    if command -v git >/dev/null 2>&1; then
        git clone --depth 1 https://github.com/RamX571/DroidLinux-Android-PC.git "${INSTALL_DIR}" || true
    fi
fi

SCRIPT_DIR="${INSTALL_DIR}"

echo -e "${CYAN}[*] Step 6/12: Running system & device detection...${NC}"
if [ -f "${SCRIPT_DIR}/install/system-check.sh" ]; then
    sh "${SCRIPT_DIR}/install/system-check.sh"
fi

echo -e "${CYAN}[*] Step 7/12: Setting up Ubuntu userspace...${NC}"
if [ -f "${SCRIPT_DIR}/install/ubuntu.sh" ]; then
    sh "${SCRIPT_DIR}/install/ubuntu.sh"
fi

echo -e "${CYAN}[*] Step 8/12: Installing XFCE desktop environment...${NC}"
if [ -f "${SCRIPT_DIR}/install/desktop.sh" ]; then
    sh "${SCRIPT_DIR}/install/desktop.sh"
fi

echo -e "${CYAN}[*] Step 9/12: Configuring display & performance profiles...${NC}"
mkdir -p "${SCRIPT_DIR}/config/environment" "${SCRIPT_DIR}/config/performance"
cat << 'ENVCONF' > "${SCRIPT_DIR}/config/environment/droidlinux.env"
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.0
export XDG_CURRENT_DESKTOP=XFCE
ENVCONF

cat << 'PERFCONF' > "${SCRIPT_DIR}/config/performance/performance.conf"
DISABLE_COMPOSITOR_EFFECTS=true
ANIMATION_SPEED=0
MEMORY_PROFILE=balanced
PERFORMANCE_MODE=high
PERFCONF

echo -e "${CYAN}[*] Step 10/12: Installing desktop applications & shortcuts...${NC}"
if [ -f "${SCRIPT_DIR}/install/apps.sh" ]; then
    sh "${SCRIPT_DIR}/install/apps.sh"
fi

echo -e "${CYAN}[*] Step 11/12: Assessing Waydroid compatibility...${NC}"
if [ -f "${SCRIPT_DIR}/install/waydroid.sh" ]; then
    sh "${SCRIPT_DIR}/install/waydroid.sh"
fi

echo -e "${CYAN}[*] Step 12/12: Configuring CLI binary symlink...${NC}"
mkdir -p "${PREFIX:-/data/data/com.termux/files/usr}/bin" 2>/dev/null || true
if [ -w "${PREFIX:-/usr}/bin" ]; then
    ln -sf "${SCRIPT_DIR}/scripts/droidlinux" "${PREFIX:-/usr}/bin/droidlinux" || true
fi

echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║                                              ║${NC}"
echo -e "${GREEN}${BOLD}║       ✅ DROIDLINUX READY!                  ║${NC}"
echo -e "${GREEN}${BOLD}║                                              ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo "🖥️ Desktop : XFCE4"
echo "🐧 Linux   : Ubuntu Userspace"
echo "📺 Display : Termux:X11"
echo ""
echo "🚀 Start desktop:"
echo -e "   ${CYAN}droidlinux start${NC}"
echo ""
echo "📊 Check status:"
echo -e "   ${CYAN}droidlinux status${NC}"
echo ""
