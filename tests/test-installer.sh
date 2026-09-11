#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Running Test: Installer Syntax Validation..."
bash -n "${ROOT_DIR}/install/install.sh"
echo "PASS: install/install.sh syntax validated."
