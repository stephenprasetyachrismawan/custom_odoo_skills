#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

echo "== [JS] registry registrations (fields/views/services/actions) =="
grep -RIn --include="*.js" --include="*.ts" -E "\bregistry\.category\s*\(" "$ROOT" 2>/dev/null || true
echo

echo "== [JS] patch() usage (potential collisions) =="
grep -RIn --include="*.js" --include="*.ts" -E "\bpatch\s*\(" "$ROOT" 2>/dev/null || true
