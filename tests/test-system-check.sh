#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Running Test: System Check Script..."
bash "${ROOT_DIR}/install/system-check.sh" > /dev/null
echo "PASS: install/system-check.sh executed without error."
