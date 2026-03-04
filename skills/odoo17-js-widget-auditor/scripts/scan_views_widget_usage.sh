#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
echo "== [XML] widget usage in views =="
grep -RIn --include="*.xml" -E "widget\s*=\s*['\"][^'\"]+['\"]" "$ROOT" 2>/dev/null || true
echo
echo "== [XML] js_class usage in views/templates =="
grep -RIn --include="*.xml" -E "js_class\s*=\s*['\"][^'\"]+['\"]" "$ROOT" 2>/dev/null || true
