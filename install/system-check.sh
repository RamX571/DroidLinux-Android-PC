#!/usr/bin/env bash
# ==============================================================================
# DroidLinux System Detection & Health Check Module
# ==============================================================================

set -Eeuo pipefail

# Color formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
}

check_termux() {
    if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
        return 0
    else
        return 1
    fi
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

    local is_ready=true
    local arch
    arch=$(detect_arch)
    local cpu_cores
    cpu_cores=$(get_cpu_cores)
    local total_ram
    total_ram=$(get_total_ram_mb)
    local free_storage
    free_storage=$(get_free_storage_gb)

    echo -e "Architecture : ${arch}"
    echo -e "CPU Cores    : ${cpu_cores}"
    echo -e "RAM          : ${total_ram} MB"
    echo -e "Storage Free : ${free_storage} GB"
    echo "--------------------------------------------------"

    # Termux
    if check_termux; then
        log_pass "Termux environment detected"
    else
        log_warn "Non-Termux environment detected. DroidLinux is designed for Termux."
    fi

    # Termux:X11
    if check_termux_x11; then
        log_pass "Termux:X11 installed"
    else
        log_warn "Termux:X11 package not detected. Graphical UI requires Termux:X11 app & package."
    fi

    # Network
    if check_network; then
        log_pass "Network connectivity active"
    else
        log_warn "No network connection detected. Package downloads may fail."
    fi

    # Ubuntu Userspace
    if check_ubuntu; then
        log_pass "Ubuntu userspace installed via proot-distro"
    else
        log_info "Ubuntu userspace not yet installed"
    fi

    echo "--------------------------------------------------"
    if [[ "$total_ram" =~ ^[0-9]+$ ]] && [ "$total_ram" -lt 1500 ] && [ "$total_ram" -gt 0 ]; then
        log_warn "Low RAM detected ($total_ram MB). Performance mode recommended."
    fi

    if [[ "$free_storage" =~ ^[0-9]+$ ]] && [ "$free_storage" -lt 3 ] && [ "$free_storage" -gt 0 ]; then
        log_warn "Low storage free ($free_storage GB). Minimal 3GB recommended."
    fi

    echo "Result: READY"
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_full_check
fi
