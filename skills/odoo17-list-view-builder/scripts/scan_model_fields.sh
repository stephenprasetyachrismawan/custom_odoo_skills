#!/usr/bin/env bash
set -euo pipefail

MODEL="${1:-}"
ROOT="${2:-.}"

if [ -z "$MODEL" ]; then
  echo "Usage: scan_model_fields.sh <model.name> [root]"
  exit 1
fi

echo "[scan] Searching for python declarations related to model: $MODEL"
echo

# Find direct _name definitions
grep -RIn --include="*.py" -E "_name\s*=\s*['\"]${MODEL}['\"]" "$ROOT" || true
echo

# Find _inherit occurrences that might affect the model
grep -RIn --include="*.py" -E "_inherit\s*=\s*\[.*['\"]${MODEL}['\"].*\]|_inherit\s*=\s*['\"]${MODEL}['\"]" "$ROOT" || true
echo

echo "[scan] Extracting field assignments (best-effort) near matched classes..."
# Very rough: locate lines after class definitions; reviewers should still confirm.
# This is intentionally lightweight and not a full parser.
grep -RIn --include="*.py" -E "fields\.(Char|Text|Boolean|Integer|Float|Monetary|Date|Datetime|Selection|Many2one|One2many|Many2many)\(" "$ROOT" | head -n 250 || true
echo

echo "[scan] Done."
