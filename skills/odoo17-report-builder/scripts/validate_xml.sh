#!/usr/bin/env bash
set -euo pipefail

if command -v xmllint >/dev/null 2>&1; then
  find . -name "*.xml" -print0 | xargs -0 -I{} xmllint --noout {}
  echo "[ok] XML well-formed."
else
  echo "[skip] xmllint not found."
fi
