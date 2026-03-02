#!/usr/bin/env bash
set -euo pipefail

echo "[validate] Checking XML well-formedness..."
# Quick XML check if xmllint exists
if command -v xmllint >/dev/null 2>&1; then
  find . -name "*.xml" -print0 | xargs -0 -I{} xmllint --noout {}
  echo "[validate] XML OK"
else
  echo "[validate] xmllint not found; skipping XML parse check"
fi

echo "[validate] Done."