#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "========================================="
echo "      DroidLinux System Diagnostics      "
echo "========================================="

echo -n "Kernel           : "
uname -sr

echo -n "Architecture     : "
uname -m

echo -n "CPU Cores        : "
nproc 2>/dev/null || echo "Unknown"

if [ -f /proc/meminfo ]; then
    echo -n "Total RAM        : "
    awk '/MemTotal/ {print int($2/1024) " MB"}' /proc/meminfo
fi

echo -n "Free Storage     : "
df -h . 2>/dev/null | awk 'NR==2 {print $4}' || echo "Unknown"

echo -n "Termux Environment: "
if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
    echo "Yes (${TERMUX_VERSION:-Detected})"
else
    echo "No / Standard Linux"
fi

echo -n "proot-distro     : "
if command -v proot-distro >/dev/null 2>&1; then
    echo "Installed"
else
    echo "Not Found"
fi

echo -n "Ubuntu Image     : "
if command -v proot-distro >/dev/null 2>&1 && proot-distro list 2>/dev/null | grep -q "ubuntu.*installed"; then
    echo "Installed"
else
    echo "Not Installed"
fi

echo -n "Termux:X11       : "
if command -v termux-x11 >/dev/null 2>&1; then
    echo "Installed"
else
    echo "Not Installed"
fi

echo "========================================="
