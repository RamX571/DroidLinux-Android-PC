# DroidLinux-Android-PC

> **Status:** Experimental / Development Preview

A fast, lightweight, PC-like Linux desktop environment for Android using Termux, Ubuntu userspace, and Termux:X11.

## One-Command Installation

On a fresh Termux installation, run:

curl -fsSL https://raw.githubusercontent.com/RamX571/DroidLinux-Android-PC/main/install.sh | bash

The installer automatically bootstraps all missing dependencies (git, curl, proot-distro, x11-repo, termux-x11-nightly), sets up Ubuntu userspace, installs the lightweight XFCE4 desktop, and configures the management CLI.

## Management CLI

After installation, use droidlinux from anywhere in Termux:

droidlinux start        # Start Termux:X11 display server & XFCE desktop
droidlinux stop         # Safely stop desktop session
droidlinux restart      # Restart desktop session
droidlinux status       # View system, RAM, and session status
droidlinux repair       # Auto-repair environment and missing configs
droidlinux diagnostics  # Run full system diagnostics
droidlinux benchmark    # Run storage and CPU performance benchmarks
droidlinux version      # Display version

## Requirements
- OS: Android 7.0+
- Environment: Termux (F-Droid release recommended) + Termux:X11 Companion Android App
- Architecture: ARM64 (aarch64) / ARM32 / x86_64
- RAM: Minimum 2 GB (4 GB+ recommended)
- Free Storage: Minimum 3 GB free

## Documentation
- Installation Guide: docs/installation.md
- CLI Command Reference: docs/commands.md
- Troubleshooting: docs/troubleshooting.md
- Performance Tuning: docs/performance.md

## License
MIT License - see LICENSE file.
