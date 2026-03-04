#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
echo "== [MANIFEST] assets bundles in __manifest__.py =="
grep -RIn --include="__manifest__.py" -E "'assets'\s*:\s*\{|\"assets\"\s*:\s*\{" "$ROOT" 2>/dev/null || true
echo
echo "== [MANIFEST] referenced static/src paths (best-effort) =="
grep -RIn --include="__manifest__.py" -E "static/src/.*\.(js|ts|xml|scss|css)" "$ROOT" 2>/dev/null || true
