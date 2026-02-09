#!/bin/bash
set -e

echo "=== OpenClaw Entrypoint ==="

# Chạy doctor --fix để apply các changes cần thiết
echo "Running doctor --fix..."
node /app/dist/index.js doctor --fix || true

# Chạy command được truyền vào (default: gateway)
echo "Starting OpenClaw..."
exec node /app/dist/index.js "$@"