---
name: odoo17-js-feature-safe-builder
description: Build a new Odoo 17 JS feature using OWL and modular patterns without breaking core JS. Avoids conflicts via unique naming (classes/variables/patch keys), minimal patch surface, correct registry usage, and safe asset wiring. Produces Odoo 17-compatible code with concise English comments and meaningful logs. No tests and no docs.
---

# Odoo 17 Safe JS Feature Builder (OWL + Modular + Low-Conflict)

## Scope & source of truth
- Work ONLY with the current repository/workspace and available local Odoo 17 sources (if present).
- Never edit Odoo core files directly.
- Implement everything inside the custom module under `static/src/...`.

## Objective
Create a JS-based feature for Odoo 17 that:
1) Uses OWL patterns consistent with Odoo 17 (`@odoo-module`, OWL components/hooks/services).
2) Does not break or disturb existing Odoo core JS behavior.
3) Minimizes conflict risk with other modules:
   - unique class/variable naming convention
   - unique registry keys
   - unique patch keys
   - minimal patching surface area
4) Is modular: small files, clear responsibilities, explicit dependencies.
5) Is dependency-aware: imports only what's needed; avoid circular imports; register cleanly.
6) Includes concise English comments and meaningful runtime logging where appropriate.

## Inputs (derive from chat/repo; ask only if impossible)
- Feature goal (what the JS should do)
- Target surface:
  - field/widget enhancement
  - view/controller enhancement
  - systray/menu item
  - service/background behavior
  - client action
- Where it should load:
  - backend only (default)
  - website/portal (only if specified)
- Any existing core component to extend/patch (if needed)

If missing: infer minimal safe defaults and list assumptions.

---

## Non-negotiable safety rules
1) No core edits. Only add files in your custom module.
2) Prefer extension/registration over patching:
   - Use registry categories (fields/views/services/actions) when available.
   - Use `patch()` only if extension is impossible.
3) Patch rules:
   - Patch only the minimum method(s).
   - Preserve original behavior (call original/super) unless explicitly changing flow.
   - Use a unique patch key: `<module>.<feature_slug>`
4) Unique naming rules (mandatory):
   - Global prefix: `{{MODULE_PREFIX}}` derived from module name (e.g., `MyMod`)
   - Feature slug: `{{FEATURE_SLUG}}` (e.g., `AutoSaveCost`)
   - Class names: `{{MODULE_PREFIX}}{{FEATURE_SLUG}}<Thing>`
   - Variables/constants: `{{MODULE_PREFIX}}_{{FEATURE_SLUG}}_<NAME>` (UPPER_SNAKE for constants)
   - Registry keys: `<module>.<feature_slug>.<purpose>`
   - File paths: `<module>/static/src/<feature_slug>/...`
5) Keep JS modular:
   - One responsibility per file when possible:
     - `components/`, `services/`, `patches/`, `utils/`
6) Dependency discipline:
   - Explicit imports; avoid importing large bundles.
   - Avoid circular imports (components should not import their own patchers).
   - Register in a single entrypoint file if needed.

---

## Mandatory compatibility checks (best-effort but required attempt)
- Search the workspace for:
  - existing registry keys that might collide
  - existing patch keys that might collide
  - existing components with same name
- Ensure assets wiring is correct:
  - module __manifest__.py includes JS in `web.assets_backend` (unless otherwise specified)
- Run JS syntax check (node --check) if node exists.

---

## Implementation patterns (choose the safest)
### Option A — New OWL Component (preferred)
- Build new component under `static/src/<feature_slug>/components/...`
- Register it via appropriate registry category or attach via view inheritance (QWeb/XML) depending on target.

### Option B — Service
- Create a service under `static/src/<feature_slug>/services/...`
- Register using the services registry.

### Option C — Minimal Patch (only if necessary)
- Use `patch()` on a specific prototype/class.
- Keep patch tiny, unique patch key, preserve original behavior.

---

## Comments & logging
- Add a provenance header comment (source/reason/date/feature id).
- Add concise English comments explaining "why", not obvious "what".
- Use `console.debug` sparingly only for development-focused signals; avoid noisy logs.
- For business-impactful actions, prefer triggering server-side logs via RPC rather than spamming browser logs.

---

## Deliverables (strict output)
1) RINGKASAN
   - feature goal & target surface
   - chosen pattern (component/service/patch) and why
   - conflict-avoidance strategy (naming/keys)
   - validation results (search + syntax + assets)
2) PERUBAHAN KODE
   - `FILE: path` + full final content
3) CATATAN
   - how to load/where it appears
   - assumptions

---

## Scripts (when available)
Run from skill directory or pass `ROOT` as second argument where applicable.
- `scripts/scan_existing_js_conflicts.sh <feature_slug> [root]` — detect naming collisions for feature slug
- `scripts/check_patch_key_collisions.sh <patch_key_regex> [root]` — search existing patch keys
- `scripts/scan_assets_manifest.sh [root]` — list assets bundles and static/src references
- `scripts/validate_js.sh <file.js>` — node --check syntax validation

## Templates (reference)
- `templates/provenance_header.txt.j2` — provenance header block
- `templates/owl_component.js.j2` — OWL component template
- `templates/service.js.j2` — service template
- `templates/patch_extension.js.j2` — minimal patch template
- `templates/manifest_assets_snippet.txt.j2` — __manifest__.py assets snippet
