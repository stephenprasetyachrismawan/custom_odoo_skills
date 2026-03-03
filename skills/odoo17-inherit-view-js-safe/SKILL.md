---
name: odoo17-inherit-view-js-safe
description: Safely customize Odoo 17 core views (XML/QWeb) and core JS behavior using inheritance/patching only. Never edits core files. Avoids collisions by using unique xml_ids, robust xpath, unique patch keys/module names, and validating assets. Designed to minimize conflicts with other modules.
---

# Odoo 17 Safe Inherit View + JS Patch (No Core Edits, Low-Conflict)

## Scope & source of truth
- Work ONLY with local repository/workspace and local Odoo 17 sources (if present).
- Never modify Odoo core files in-place.
- All changes must be implemented in a custom module using:
  - XML view inheritance (inherit_id + xpath)
  - QWeb template inheritance (t-inherit / xpath)
  - JS patching (patch utilities / registry extension) in your module assets

## Objective
Achieve the desired UI/behavior changes by inheriting/patching core Odoo 17 views or JS, while:
1) Not violating Odoo ownership (no core file edits).
2) Avoiding unnecessary conflicts with other customizations:
   - robust xpath strategies
   - unique identifiers
   - conservative patching and scoping
3) Ensuring compatibility with Odoo 17 patterns and asset loading.

## Inputs (derive from chat/repo; only ask if impossible)
- Target type: `view_xml`, `qweb`, or `js`
- Target core item reference:
  - For XML: base view xml_id (e.g. `sale.view_order_form`)
  - For QWeb: template name/id to inherit
  - For JS: module path or component/class name to patch
- Desired change(s): fields/buttons/layout/modifiers for views, behavior change for JS
- Target module where we add the customization (custom module name + file paths)
- Conflict constraints (if any): must coexist with other known modules

If missing: infer safe defaults and list assumptions in summary.

---

## Non-negotiable rules (legal/ownership + stability)
1) DO NOT edit any file under Odoo core directly (e.g. inside `./odoo17`).
2) Only create custom module files (XML/JS/Python) that inherit/patch.
3) Every created record id / xml_id must be unique to the custom module:
   - `<module>_inh_<slug>_<purpose>`
4) JS patch must be uniquely identifiable and scoped:
   - Use your module namespace in patch keys and registry entries
5) Prefer additive/override-in-place patterns that minimize breakage:
   - view inheritance via xpath with stable anchors
   - JS patch that wraps/extends functions rather than re-implementing whole components

---

## Mandatory conflict-avoidance strategy
### A) View inheritance (XML)
- Use `<record model="ir.ui.view">` with:
  - `<field name="inherit_id" ref="<base_view_xmlid>"/>`
  - XPath targets that are stable and minimally invasive:
    - prefer anchors like `//field[@name='x']`, `//group[hasclass('...')]`, `//page[@name='...']`
    - avoid brittle absolute paths when possible
- Do not delete large blocks unless explicitly required.
- If multiple xpaths touch same node:
  - consolidate into one inherit view when possible.

### B) QWeb inheritance
- Use `t-inherit="..."` and `xpath` inside template.
- Avoid duplicating `t-name` of core templates.

### C) JS patching (Odoo 17)
- Prefer `patch()` on an imported prototype/class or use registry extension patterns.
- Keep patch minimal:
  - override only the method(s) needed
  - call `super`/original behavior where appropriate
- Ensure no name collision:
  - unique patch key like: `"<module>.<slug>"`

### D) Scan existing customizations to avoid collisions
You MUST search the workspace for:
- Other inherit views targeting the same `inherit_id`
- Other xpaths touching the same nodes (best-effort)
- JS patches touching the same module/component
If conflicts likely:
- choose safer insertion points
- reduce patch surface area
- document compatibility notes in summary

---

## Validation requirements (best-effort, but mandatory attempt)
- XML well-formed check for new/modified XML files.
- JS syntax check for new JS files (node --check if available).
- Collision checks:
  - xml_id collisions inside the module/repo
  - duplicated JS module names / patch keys (best-effort grep)

---

## Deliverables (strict output)
1) RINGKASAN
   - what was targeted (base view/template/js)
   - what was changed (minimal)
   - how conflicts were avoided (xpath strategy / patch key strategy)
   - validation results
2) PERUBAHAN KODE
   - `FILE: path` then full final content
3) CATATAN
   - assumptions
   - how to enable/load (manifest assets / data xml loading)
   - compatibility notes (if any)

---

## Execution steps (default)
1) Locate the target base view/template/js reference in local sources/workspace (best-effort).
2) Scan workspace for existing inherit/patch targeting the same area (conflict check).
3) Implement change by inheritance/patch only (no core edits).
4) Ensure unique ids and robust xpath/patch keys.
5) Validate XML/JS and collision checks.
6) Output final code per file.

---

## Scripts (when available)
- `scripts/scan_targets.sh` — search base view/template/js in workspace + ./odoo17
- `scripts/check_xmlid_collisions.sh` — verify no xml_id collisions
- `scripts/validate_xml.sh` — xmllint well-formed check
- `scripts/validate_js.sh` — node --check syntax
- `scripts/scan_js_patches.sh` — search existing patches on same module/pattern

## Templates (reference)
- `templates/view_inherit.xml.j2` — standard inherit view
- `templates/qweb_inherit.xml.j2` — t-inherit QWeb
- `templates/js_patch.js.j2` — minimal patch pattern
- `templates/manifest_assets_snippet.txt.j2` — assets bundle snippet
- `templates/provenance_marker.txt.j2` — provenance marker
