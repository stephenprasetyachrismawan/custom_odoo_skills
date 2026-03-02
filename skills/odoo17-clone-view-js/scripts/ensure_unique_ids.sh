#!/usr/bin/env bash
set -euo pipefail

PATTERN="${1:-}"
ROOT="${2:-.}"

if [ -z "$PATTERN" ]; then
  echo "Usage: ensure_unique_ids.sh <pattern> [root]"
  exit 1
fi

echo "== [check] Looking for possible collisions: $PATTERN =="
grep -RIn --include="*.xml" --include="*.js" --include="*.ts" -E "$PATTERN" "$ROOT" || true
echo "[check] Done."
