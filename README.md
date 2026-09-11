# DroidLinux-Android-PC

> A fast, lightweight, PC-like Linux desktop environment for Android using Termux, Ubuntu userspace, and Termux:X11.

---

## 🚀 One-Command Installation

Fresh Termux पर इस command को चलाएँ। Installer आवश्यक dependencies को automatically setup करेगा।

```
curl -fsSL https://raw.githubusercontent.com/RamX571/DroidLinux-Android-PC/main/install.sh | bash
```

---

## 🖥️ First Launch

Installation complete होने के बाद:

### ▶️ Start DroidLinux
```
droidlinux start
```

### ⏹️ Stop DroidLinux
```
droidlinux stop
```

### 📊 Check Status
```
droidlinux status
```

---

## ⚡ Quick Commands

```
droidlinux start
droidlinux stop
droidlinux restart
droidlinux status
droidlinux update
droidlinux repair
droidlinux diagnostics
droidlinux benchmark
droidlinux version
droidlinux help
```

---

## 🗑️ Uninstall

```
droidlinux uninstall
```

⚠️ Uninstall करने से पहले सुनिश्चित करें कि आप DroidLinux का installed environment हटाना चाहते हैं।

---

## 📋 System Requirements
- **OS:** Android 7.0+
- **Environment:** Termux (F-Droid release recommended) + Termux:X11 Companion Android App
- **Architecture:** ARM64 (`aarch64`) / ARM32 / x86_64
- **RAM:** Minimum 2 GB (4 GB+ recommended)
- **Free Storage:** Minimum 3 GB free

---

## 🛠️ Manual / Developer Installation

```
git clone https://github.com/RamX571/DroidLinux-Android-PC.git
cd DroidLinux-Android-PC
bash install.sh
```

---

## 📄 Documentation
- [Installation Guide](docs/installation.md)
- [CLI Command Reference](docs/commands.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Performance Tuning](docs/performance.md)

---

## ⚖️ License
MIT License - see [LICENSE](LICENSE) file.
