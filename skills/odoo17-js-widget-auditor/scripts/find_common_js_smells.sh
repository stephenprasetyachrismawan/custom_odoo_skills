#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
echo "== [SMELLS] suspicious patterns in JS =="
# Missing @odoo-module but using @web imports
grep -RIn --include="*.js" --include="*.ts" -E "from\s+['\"]@web/" "$ROOT" 2>/dev/null | head -n 200 || true
echo

# Legacy patterns (best-effort)
grep -RIn --include="*.js" --include="*.ts" -E "odoo\.define\(|require\(|owl\.Component\b|web\.core" "$ROOT" 2>/dev/null | head -n 200 || true
echo

# Common runtime errors: undefined registry key usage
grep -RIn --include="*.js" --include="*.ts" -E "registry\.category\(['\"]fields['\"]\)\.get\(|registry\.category\(['\"]views['\"]\)\.get\(" "$ROOT" 2>/dev/null | head -n 200 || true
