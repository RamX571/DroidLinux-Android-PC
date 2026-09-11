# Contributing to DroidLinux

Thank you for your interest in contributing!

## Development & Safety Principles
- All scripts must maintain defensive POSIX/Bash coding practices (`set -Eu0 pipefail`).
- Never hardcode user home directories or device architectures.
- Run test suites before submitting PRs:
  ```bash
  bash tests/test-scripts.sh
  bash tests/test-system-check.sh
  ```
