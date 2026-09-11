# DroidLinux-Android-PC

> **Status:** Experimental / Development Preview

A fast, lightweight, PC-like Linux desktop environment for Android using Termux, Ubuntu userspace, and Termux:X11.

## Key Features
- **Fast & Lightweight:** Built on XFCE4 desktop with non-essential visual effects turned off for low RAM/CPU footprint.
- **Windows-11-Inspired UI:** Light, modern taskbar and layout.
- **Modular Architecture:** Clean separation between system check, userspace setup, desktop configuration, application installer, and management tools.
- **Management CLI:** Easy controls via `droidlinux start`, `stop`, `status`, `repair`, `diagnostics`, and more.
- **Waydroid Assessment:** Optional assessment of kernel binder compatibility.

## Installation

```bash
git clone https://github.com/RamX571/DroidLinux-Android-PC.git
cd DroidLinux-Android-PC
bash install/install.sh
```

## Management CLI Commands

```bash
bash scripts/droidlinux start        # Launch desktop
bash scripts/droidlinux stop         # Stop desktop
bash scripts/droidlinux status       # Check status
bash scripts/droidlinux repair       # Auto-repair environment
bash scripts/droidlinux diagnostics  # Run diagnostics
bash scripts/droidlinux benchmark    # Run performance benchmark
```

## License
MIT License - see [LICENSE](LICENSE) file.
