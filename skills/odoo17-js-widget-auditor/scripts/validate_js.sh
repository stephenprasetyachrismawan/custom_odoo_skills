#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-.}"

if command -v node >/dev/null 2>&1; then
  echo "== [JS] syntax check (node --check) for custom JS =="
  find "$ROOT" -name "*.js" -type f -print0 2>/dev/null | xargs -0 -I{} node --check {} 2>&1 || true
  echo "[ok] JS syntax check attempted."
else
  echo "[skip] node not found."
fi
