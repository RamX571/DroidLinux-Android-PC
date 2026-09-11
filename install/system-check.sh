#!/usr/bin/env bash
# ==============================================================================
# DroidLinux System Detection & Health Check Module
# ==============================================================================

set -Eeuo pipefail

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;36m"
NC="\033[0m"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

get_device_model() {
    if command -v getprop >/dev/null 2>&1; then
        local model manufacturer
        model=$(getprop ro.product.model 2>/dev/null || echo "")
        manufacturer=$(getprop ro.product.manufacturer 2>/dev/null || echo "")
        if [ -n "$model" ] || [ -n "$manufacturer" ]; then
            echo "$manufacturer $model"
            return
        fi
    fi
    echo "Generic Linux / Android Device"
}

get_android_version() {
    if command -v getprop >/dev/null 2>&1; then
        local ver
        ver=$(getprop ro.build.version.release 2>/dev/null || echo "")
        if [ -n "$ver" ]; then
            echo "$ver"
            return
        fi
    fi
    echo "N/A"
}

detect_arch() {
    uname -m
}

get_cpu_cores() {
    nproc 2>/dev/null || echo "Unknown"
}

get_total_ram_mb() {
    if [ -f /proc/meminfo ]; then
        awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo
    else
        echo "0"
    fi
}

get_free_storage_gb() {
    df -G . 2>/dev/null | awk 'NR==2 {print $4}' || df -m . 2>/dev/null | awk 'NR==2 {print int($4/1024)}' || echo "0"
}

detect_gpu() {
    if command -v lspci >/dev/null 2>&1; then
        local gpu
        gpu=$(lspci 2>/dev/null | grep -iE "vga|3d|2d|display" || echo "")
        if [ -n "$gpu" ]; then
            echo "$gpu"
            return
        fi
    fi
    if command -v getprop >/dev/null 2>&1; then
        local board
        board=$(getprop ro.board.platform 2>/dev/null || echo "")
        if [ -n "$board" ]; then
            echo "SoC Platform: $board (Mesa Virpipe GL)"
            return
        fi
    fi
    echo "Software Rendering Fallback (Virpipe/LLVMpipe)"
}

check_termux() {
    if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
        return 0
    else
        return 1
    fi
}

check_termux_x11() {
    if command -v termux-x11 >/dev/null 2>&1 || [ -f "${PREFIX:-}/bin/termux-x11" ]; then
        return 0
    else
        return 1
    fi
}

check_network() {
    if ping -c 1 1.1.1.1 >/dev/null 2>&1 || ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_ubuntu() {
    if command -v proot-distro >/dev/null 2>&1; then
        if proot-distro list 2>/dev/null | grep -q "ubuntu.*installed"; then
            return 0
        fi
    fi
    return 1
}

run_full_check() {
    echo "=================================================="
    echo "            DroidLinux System Check               "
    echo "=================================================="

    local model android_ver arch cpu_cores total_ram free_storage gpu_info
    model=$(get_device_model)
    android_ver=$(get_android_version)
    arch=$(detect_arch)
    cpu_cores=$(get_cpu_cores)
    total_ram=$(get_total_ram_mb)
    free_storage=$(get_free_storage_gb)
    gpu_info=$(detect_gpu)

    echo -e "📱 Device       : ${model}"
    echo -e "🤖 Android      : ${android_ver}"
    echo -e "⚙️ Architecture : ${arch}"
    echo -e "🧠 CPU Cores    : ${cpu_cores}"
    echo -e "💾 RAM          : ${total_ram} MB"
    echo -e "💿 Storage Free : ${free_storage} GB"
    echo -e "🎮 Graphics     : ${gpu_info}"
    echo "--------------------------------------------------"

    if check_termux; then
        log_pass "Termux environment detected"
    else
        log_warn "Non-Termux environment detected."
    fi

    if check_termux_x11; then
        log_pass "Termux:X11 installed"
    else
        log_warn "Termux:X11 package not detected."
    fi

    if check_network; then
        log_pass "Network connectivity active"
    else
        log_warn "No network connection detected."
    fi

    if check_ubuntu; then
        log_pass "Ubuntu userspace installed"
    else
        log_info "Ubuntu userspace not yet installed"
    fi

    echo "--------------------------------------------------"
    if [[ "$total_ram" =~ ^[0-9]+$ ]] && [ "$total_ram" -lt 1500 ] && [ "$total_ram" -gt 0 ]; then
        log_warn "Low RAM detected ($total_ram MB). Performance mode enabled."
    fi

    echo "Result: READY"
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_full_check
fi
