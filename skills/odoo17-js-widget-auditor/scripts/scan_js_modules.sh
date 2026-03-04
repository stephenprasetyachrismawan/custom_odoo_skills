#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
echo "== [JS] Odoo modules in workspace ($ROOT) =="
grep -RIn --include="*.js" --include="*.ts" -E "/\*\*\s*@odoo-module\s*\*\*/" "$ROOT" 2>/dev/null || true
