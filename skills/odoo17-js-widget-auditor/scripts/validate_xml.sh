#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-.}"

if command -v xmllint >/dev/null 2>&1; then
  echo "== [XML] validating well-formedness =="
  find "$ROOT" -name "*.xml" -type f -print0 2>/dev/null | xargs -0 -I{} xmllint --noout {} 2>&1 || true
  echo "[ok] XML validation attempted."
else
  echo "[skip] xmllint not found."
fi
