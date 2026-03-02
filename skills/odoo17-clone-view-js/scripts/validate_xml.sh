#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"
if [ -z "$FILE" ]; then
  echo "Usage: validate_xml.sh <file.xml>"
  exit 1
fi

if command -v xmllint >/dev/null 2>&1; then
  xmllint --noout "$FILE"
  echo "[ok] XML well-formed: $FILE"
else
  echo "[skip] xmllint not found; cannot validate XML."
fi
