#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Running Test: Shell Syntax Validation across repository..."
for script in $(find "${ROOT_DIR}" -name "*.sh" -o -name "droidlinux"); do
    bash -n "$script"
    echo "Syntax OK: $script"
done

echo "Running Test: DroidLinux CLI Help Command..."
bash "${ROOT_DIR}/scripts/droidlinux" help > /dev/null
echo "PASS: DroidLinux CLI help command functional."

echo "Running Test: Status Tool..."
bash "${ROOT_DIR}/scripts/status.sh" > /dev/null
echo "PASS: scripts/status.sh functional."

echo "Running Test: Diagnostics Tool..."
bash "${ROOT_DIR}/tools/diagnostics.sh" > /dev/null
echo "PASS: tools/diagnostics.sh functional."

echo "Running Test: Benchmark Tool..."
bash "${ROOT_DIR}/tools/benchmark.sh" > /dev/null
echo "PASS: tools/benchmark.sh functional."
