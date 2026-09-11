# DroidLinux Troubleshooting Guide

## Black Screen / Display Not Showing
- Ensure Termux:X11 app is open in background on Android.
- Verify DISPLAY environment variable is set (`export DISPLAY=:0`).
- Run `bash scripts/droidlinux repair` to restore configuration.

## Audio Issues
- Ensure PulseAudio server is running (`pulseaudio --start`).
- Check sound output settings in XFCE audio volume applet.
