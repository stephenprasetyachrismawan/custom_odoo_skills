#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"
if [ -z "$FILE" ]; then
  echo "Usage: validate_js.sh <file.js>"
  exit 1
fi

if command -v node >/dev/null 2>&1; then
  node --check "$FILE"
  echo "[ok] JS syntax OK: $FILE"
else
  echo "[skip] node not found; cannot run JS syntax check."
fi
