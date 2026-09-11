# Changelog

All notable changes to DroidLinux-Android-PC will be documented in this file.

## [1.0.0-alpha] - 2026-09-11
### Added
- Modular 8-step orchestrator installer (`install/install.sh`).
- System health detection script (`install/system-check.sh`).
- Ubuntu userspace setup script with proot-distro reuse (`install/ubuntu.sh`).
- Lightweight XFCE desktop configuration with Windows 11 light UI inspiration (`install/desktop.sh`).
- Application setup module for Firefox, Chromium, VS Code alternative (`install/apps.sh`).
- Optional Waydroid compatibility assessment module (`install/waydroid.sh`).
- Management CLI dispatcher (`scripts/droidlinux`) supporting start, stop, restart, status, update, repair, diagnostics, benchmark, uninstall.
- Diagnostic collector and lightweight performance benchmark tools.
- Comprehensive test suite in `tests/`.
