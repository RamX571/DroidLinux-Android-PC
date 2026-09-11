#!/usr/bin/env bash
set -Eeuo pipefail

echo "========================================="
echo "       DroidLinux Benchmark Suite        "
echo "========================================="

echo "Testing storage write performance (64MB file)..."
START_TIME=$(date +%s%N 2>/dev/null || date +%s)
dd if=/dev/zero of=/tmp/droidlinux_bench_test bs=1M count=64 status=none
END_TIME=$(date +%s%N 2>/dev/null || date +%s)
rm -f /tmp/droidlinux_bench_test

echo "Storage I/O test completed successfully."

echo "Testing CPU single-core loop calculation..."
python3 -c "
import time
start = time.time()
x = sum(i*i for i in range(2000000))
end = time.time()
print(f'CPU Math Benchmark: {end - start:.4f} seconds')
" 2>/dev/null || echo "Python3 unavailable for CPU benchmark."

echo "========================================="
