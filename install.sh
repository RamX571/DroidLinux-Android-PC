#!/usr/bin/env bash
set -Eeuo pipefail

CYAN="\033[0;36m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"
BOLD="\033[1m"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║                                              ║"
echo "║       🖥️  DROIDLINUX ANDROID PC             ║"
echo "║                                              ║"
echo "║       Linux Desktop for Android              ║"
echo "║                                              ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}[*] Detecting device parameters...${NC}"
"${SCRIPT_DIR}/install/system-check.sh"

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}📊 INSTALLATION PROGRESS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

progress_bar() {
    local step=$1
    local total=12
    local percent=$(( step * 100 / total ))
    local completed=$(( percent / 4 ))
    local remaining=$(( 25 - completed ))
    local bar=""
    for ((i=0; i<completed; i++)); do bar="${bar}█"; done
    for ((i=0; i<remaining; i++)); do bar="${bar}░"; done
    echo -e "${CYAN}[${bar}] ${percent}%${NC}"
}

echo "[1/12] Preparing Termux base tools..."
progress_bar 1
if command -v pkg >/dev/null 2>&1; then
    pkg update -y || true
    pkg install -y curl wget tar git || true
fi

echo "[2/12] Installing x11-repo..."
progress_bar 2
if command -v pkg >/dev/null 2>&1; then
    pkg install -y x11-repo || true
fi

echo "[3/12] Installing Termux:X11 packages..."
progress_bar 3
if command -v pkg >/dev/null 2>&1; then
    pkg install -y termux-x11-nightly pulseaudio || pkg install -y termux-x11 pulseaudio || true
fi

echo "[4/12] Installing proot-distro..."
progress_bar 4
if command -v pkg >/dev/null 2>&1; then
    pkg install -y proot-distro || true
fi

echo "[5/12] Setting up Ubuntu userspace..."
progress_bar 5
"${SCRIPT_DIR}/install/ubuntu.sh"

echo "[6/12] Installing XFCE desktop environment..."
progress_bar 6
"${SCRIPT_DIR}/install/desktop.sh"

echo "[7/12] Configuring display & X11 environment..."
progress_bar 7
mkdir -p "${SCRIPT_DIR}/config/environment"
cat << "ENVCONF" > "${SCRIPT_DIR}/config/environment/droidlinux.env"
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.0
export XDG_CURRENT_DESKTOP=XFCE
ENVCONF

echo "[8/12] Applying performance profile..."
progress_bar 8
mkdir -p "${SCRIPT_DIR}/config/performance"
cat << "PERFCONF" > "${SCRIPT_DIR}/config/performance/performance.conf"
DISABLE_COMPOSITOR_EFFECTS=true
ANIMATION_SPEED=0
MEMORY_PROFILE=balanced
PERFORMANCE_MODE=high
PERFCONF

echo "[9/12] Installing applications..."
progress_bar 9
"${SCRIPT_DIR}/install/apps.sh"

echo "[10/12] Assessing Waydroid compatibility..."
progress_bar 10
"${SCRIPT_DIR}/install/waydroid.sh"

echo "[11/12] Configuring management tools & CLI..."
progress_bar 11
mkdir -p "${PREFIX:-/data/data/com.termux/files/usr}/bin" 2>/dev/null || true
if [ -w "${PREFIX:-/usr}/bin" ]; then
    ln -sf "${SCRIPT_DIR}/scripts/droidlinux" "${PREFIX:-/usr}/bin/droidlinux" || true
fi

echo "[12/12] Final verification & state check..."
progress_bar 12
"${SCRIPT_DIR}/scripts/status.sh"

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
echo "🚀 Launch desktop:"
echo -e "   ${CYAN}droidlinux start${NC}"
echo ""
echo "📊 View status:"
echo -e "   ${CYAN}droidlinux status${NC}"
echo ""
