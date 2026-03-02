#!/usr/bin/env bash
set -euo pipefail

PATTERN="${1:-}"
ROOT="${2:-.}"

if [ -z "$PATTERN" ]; then
  echo "Usage: grep_usages.sh <pattern> [root]"
  exit 1
fi

echo "[usage] Searching pattern: $PATTERN"
grep -RIn --include="*.py" --include="*.xml" -E "$PATTERN" "$ROOT" || true
echo "[usage] Done."
