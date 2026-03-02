#!/usr/bin/env bash
set -euo pipefail

QUERY="${1:-}"
ODOO_ROOT="${2:-./odoo17}"
ROOT="${3:-.}"

if [ -z "$QUERY" ]; then
  echo "Usage: scan_sources.sh <query_regex> [odoo_root=./odoo17] [workspace_root=.]"
  exit 1
fi

echo "== [scan] Workspace matches =="
grep -RIn --include="*.xml" --include="*.js" --include="*.ts" -E "$QUERY" "$ROOT" | head -n 200 || true
echo

if [ -d "$ODOO_ROOT" ]; then
  echo "== [scan] Odoo core matches ($ODOO_ROOT) =="
  grep -RIn --include="*.xml" --include="*.js" --include="*.ts" -E "$QUERY" "$ODOO_ROOT" | head -n 200 || true
else
  echo "== [scan] Odoo root not found: $ODOO_ROOT =="
fi
