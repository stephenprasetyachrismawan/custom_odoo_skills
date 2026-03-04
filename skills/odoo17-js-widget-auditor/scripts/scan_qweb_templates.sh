#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
echo "== [QWEB] templates and t-name/t-inherit =="
grep -RIn --include="*.xml" -E "<template\b|t-name\s*=\s*['\"][^'\"]+['\"]|t-inherit\s*=\s*['\"][^'\"]+['\"]" "$ROOT" 2>/dev/null || true
