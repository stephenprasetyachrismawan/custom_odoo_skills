#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-./odoo17}"
QUERY="${2:-}"

if [ ! -d "$ROOT" ]; then
  echo "[scan] Folder not found: $ROOT"
  exit 2
fi

echo "[scan] Scanning Odoo sources under: $ROOT"
echo "[scan] Query: ${QUERY:-<none>}"
echo

# Find model declarations
echo "== Model declarations (_name / _inherit) =="
grep -RIn --include="*.py" -E "(_name\s*=\s*'|_inherit\s*=\s*')" "$ROOT" | head -n 200 || true
echo

if [ -n "$QUERY" ]; then
  echo "== Keyword hits for: $QUERY =="
  grep -RIn --include="*.py" --include="*.xml" -E "$QUERY" "$ROOT" | head -n 200 || true
  echo
fi

echo "[scan] Done."
