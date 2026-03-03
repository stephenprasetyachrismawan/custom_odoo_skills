#!/usr/bin/env bash
set -euo pipefail

PATTERN="${1:-}"
ROOT="${2:-.}"

if [ -z "$PATTERN" ]; then
  echo "Usage: scan_js_patches.sh <pattern_regex> [root]"
  exit 1
fi

echo "== [scan] JS patch hits: $PATTERN =="
grep -RIn --include="*.js" --include="*.ts" -E "$PATTERN" "$ROOT" 2>/dev/null || true
