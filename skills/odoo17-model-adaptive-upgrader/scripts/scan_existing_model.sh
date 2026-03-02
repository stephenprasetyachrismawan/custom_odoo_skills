#!/usr/bin/env bash
set -euo pipefail

MODEL="${1:-}"
ROOT="${2:-.}"

if [ -z "$MODEL" ]; then
  echo "Usage: scan_existing_model.sh <model.name> [root]"
  exit 1
fi

echo "[scan] Model: $MODEL"
echo

echo "== _name definitions =="
grep -RIn --include="*.py" -E "_name\s*=\s*['\"]${MODEL}['\"]" "$ROOT" || true
echo

echo "== _inherit extensions =="
grep -RIn --include="*.py" -E "_inherit\s*=\s*\[.*['\"]${MODEL}['\"].*\]|_inherit\s*=\s*['\"]${MODEL}['\"]" "$ROOT" || true
echo

echo "== Views referencing model (best-effort) =="
grep -RIn --include="*.xml" -E "model=['\"]${MODEL}['\"]" "$ROOT" || true

echo
echo "[scan] Done."
