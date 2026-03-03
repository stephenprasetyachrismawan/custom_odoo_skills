#!/usr/bin/env bash
set -euo pipefail

XMLID="${1:-}"
ROOT="${2:-.}"

if [ -z "$XMLID" ]; then
  echo "Usage: check_xmlid_collisions.sh <xmlid_or_record_id_regex> [root]"
  exit 1
fi

echo "== [check] Searching XML ID collisions: $XMLID =="
grep -RIn --include="*.xml" -E "record id=\"${XMLID}\"|id=\"${XMLID}\"" "$ROOT" 2>/dev/null || true
