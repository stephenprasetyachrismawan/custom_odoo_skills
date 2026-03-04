---
name: odoo17-js-widget-auditor
description: Audit Odoo 17 JS + XML views with a focus on custom JS widgets/components. Scans the whole workspace (and optional ./odoo17) to find issues, collisions, asset loading problems, broken imports, invalid widget usage, and OWL/QWeb mismatches. Reports each issue with source file:line and root-cause hints, plus safe remediation suggestions. No core edits, no tests, no docs generation.
---

# Odoo 17 JS + Widget Auditor (Root-Cause Focus)

## Scope & sources
- Primary target: current workspace/custom modules in the repo.
- Optional secondary target: local Odoo core folder `./odoo17` (scan read-only for reference).
- Never edit Odoo core files. Only suggest patches in custom modules.

## Objective
Find problems and their sources in:
- JS modules (`/** @odoo-module **/`)
- OWL components
- registry-based widgets (fields, views, services, actions)
- assets bundling and manifest wiring
- XML views that use widgets (field widget="...", js_class, templates)
- QWeb templates used by JS

and report:
1) Issue list with severity + evidence (file:line)
2) Likely root cause
3) Safe remediation steps (Odoo 17 compatible)
4) Collision/conflict risks (duplicate registry keys, duplicate xml_ids, double patches)

## Inputs (infer from repo; do not ask unless impossible)
- Custom modules root (default: `.`)
- Optional core root (default: `./odoo17` if exists)
- Focus widget name(s) if mentioned in chat; otherwise scan all custom widgets.

## Mandatory audit steps (must attempt)
### A) Inventory
1) Identify all JS modules in custom workspace:
   - files containing `/** @odoo-module **/`
2) Identify all custom widget registrations:
   - field registry keys (fields/field registry)
   - view registry keys
   - services/actions registries
   - patch() keys
3) Identify all XML usages:
   - widget="..."
   - js_class="..."
   - QWeb templates referenced

### B) Asset wiring integrity (high priority)
- Find all `__manifest__.py` asset bundles and ensure:
  - custom JS is included in correct bundle (`web.assets_backend` / others)
  - paths exist
  - no accidental duplicate includes
- Report missing includes / wrong bundle / dead files.

### C) Compatibility checks (Odoo 17 patterns)
- JS imports must match Odoo 17 module paths (`@web/...`, etc.)
- OWL usage must be consistent with Odoo 17 (hooks/imports)
- Avoid legacy patterns (e.g., old web client includes) unless repo uses them intentionally

### D) View/widget consistency checks
- Every widget referenced in XML must:
  - exist as a registered widget or valid widget name
  - be loaded in assets at runtime (manifest includes)
- Every JS component referencing a QWeb template must:
  - have template available and loaded
- Catch common mismatch patterns:
  - widget key differs (typo/casing)
  - JS file not in assets bundle
  - template id mismatch
  - XML arch referencing non-existent fields used by widget logic (best-effort)

### E) Conflict/collision checks (avoid "unnecessary conflicts")
- Duplicate registry keys
- Duplicate patch keys
- Multiple patches on same prototype that override same method without chaining
- Duplicate xml_id for templates/views
- Multiple inherit views targeting the same base view with fragile xpath

### F) Best-effort static validation
- XML well-formed check (`xmllint`) for all changed/flagged XML
- JS syntax check (`node --check`) for all custom JS files (if node exists)

## Output format (strict)
1) EXECUTIVE SUMMARY
   - number of issues by severity
   - top 3 root-cause clusters (e.g., "assets not loaded", "registry collisions", "template mismatch")
2) ISSUE LIST (each issue must contain)
   - ID (e.g., JSW-001)
   - Severity (Critical/High/Medium/Low)
   - Category (Assets/Registry/ViewUsage/Imports/OWL/QWeb/Conflicts)
   - Evidence: file:line + matching snippet (short)
   - Root cause hypothesis (one paragraph)
   - Suggested fix (safe, Odoo 17 compatible)
   - Conflict risk note (if applicable)
3) QUICK REMEDIATION PLAN
   - ordered steps to fix the highest-impact problems first

## Execution approach
1) Run scripts to gather evidence (inventory + scans).
2) Group findings into issues and deduplicate duplicates.
3) Produce the report with file:line references and concrete fixes.

## Constraints
- No tests and no documentation files generation.
- Do not modify core Odoo.
- Fix suggestions must be minimal and compatible with existing code patterns.
