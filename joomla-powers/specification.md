# Joomla Power mapping contract

**Operating version:** use the [latest JCB version policy](../standards/version-policy.md), then verify current mappings for the selected Joomla target. Historical form options and source hashes below are evidence, not a frozen compiler or target list.

**Authority:** source-inspected behavior at the [recorded revisions](sources.md), with stricter authoring guidance identified below.

## Token and repository representations

| Representation | Meaning |
| --- | --- |
| `ba6326ef-cb79-4348-80f4-ab086082e3c5` | Existing canonical JText mapping GUID |
| `Joomla---ba6326ef_cb79_4348_80f4_ab086082e3c5---Power` | Display/index `jpk` form |
| `Joomla___ba6326ef_cb79_4348_80f4_ab086082e3c5___Power` | PHP source token: replace the two `---` delimiters with `___` |
| `index.json` | GUID-keyed locator object, not a PHP implementation |
| `src/<guid>/item.json` | Portable mapping record |
| `README.md`, `src/<guid>/README.md` | Generated explanation and index documentation |

For each index entry, `guid` matches its object key, `name` matches the item's `system_name`, `path` is `src/<guid>`, `settings` is `src/<guid>/item.json`, and `jpk` has the display spelling above. `local` is added by the JCB selection UI; do not export it as a source field. Joomla Powers do not use `super-powers.json`, `settings.json` or `code.power`.

## Portable fields

The inspected Table definition and Remote Config export these four fields; `access` is excluded by the shared config. Local database IDs, publishing/audit fields and assets are not part of this mapping format.

| Field | Contract and authoring rule |
| --- | --- |
| `guid` | Stable GUID identifying this mapping. Preserve it for the same mapping; allocate a collision-checked UUIDv4 for a distinct mapping. |
| `system_name` | Human name used as the index `name`. The form limits new input to 50 characters; SQL permits 255. A historical longer value is not permission to truncate it silently. |
| `description` | Text explaining the mapped capability and any target restrictions. Empty string is valid and occurs upstream. |
| `settings` | Native JSON object of rows or array of rows. Each row supplies `namespace` and `joomla_version`; the form presents 1–10 rows. Do not put encoded JSON text inside this field: the import model JSON-encodes structured values for database storage. |
| `settings.*.namespace` | Complete symbol name, without `use` or a trailing semicolon. The form requires it and limits new input to 250 characters. Component placeholders are allowed and resolved by the compiler. |
| `settings.*.joomla_version` | Number or number-like string; form values are `0`, `3`, `4`, `5`, `6` in the inspected source. `0` is a fallback, not an automatic compatibility check. |

The exporter can map absent properties to null. The compiler needs nonempty decoded settings and a usable namespace for the chosen target. Author complete records with explicit text fields and nonempty native rows. Do not equate missing/null/empty settings with a valid mapping or assume an imported null clears an existing database field. Inspect saved state after maintenance.

`Compiler/JoomlaPower::setNamespaceAndType()` also reads an optional row `type`, defaulting to `class`. Neither the inspected Table row definition nor its XML form exposes that setting. Preserve existing source-specific data while investigating its producer; do not invent a required type field or copy Super Power `type` semantics into this format.

## Version selection and placeholder expansion

`Compiler/JoomlaPower::setTargetVersion()` walks the settings rows in their stored order. A `0` row sets a fallback; the first exact match to the configured compiler target is selected and ends the search. An exact target wins over a fallback. With no exact target, the last fallback encountered wins. With neither, the compiler reports a missing namespace for that Joomla version.

**Authoring policy:** allow at most one row per numeric version, including one fallback. Duplicate rows make meaning depend on order and should be resolved explicitly rather than silently sorted. The mapping helper rejects them, which is stricter than the compiler's sequential behavior.

The selected namespace passes through the compiler's placeholder expansion. The official `@ComponentHelper (site)` mapping uses `[[[NamespacePrefix]]]\Component\[[[ComponentNamespace]]]\Site\Helper\[[[Component]]]Helper`, with a Joomla 3-specific helper name. This refers to a generated helper; it does not create that helper or move a custom class. Verify the corresponding component, client and generated class exist. Custom class placement belongs to the [Super Power workflow](../super-powers/SKILL.md).

Namespace selection does not adapt method names, argument contracts, runtime services or removed APIs. Verify those against the selected Joomla release, including interface/trait usage and any version-specific calling code.

## Acquisition and compilation

Configure a repository with Joomla Power target **2**, the actual provider/base/organization/repository, read branch, enabled state and effective source precedence. Use dynamically discovered alternatives for the same logical repository; never treat a mirror as a different identity catalogue or an override.

The inspected controller routes **Init** to initialization selection and **Pull** to pull selection. The AJAX paths call the shared builder's `init()` with `force=false` and `force=true`, respectively. Init skips an already-local GUID; Pull can replace it from the selected repository. **Reset** acts on selected local rows by GUID and performs a remote-only lookup. Back up local work before authorized replacement and verify which repository won. These labels do not prove an import succeeded.

The compiler's `add_power` setting also gates Joomla Power loading unless an explicit force-build flag is used; inspect effective settings when tokens remain unresolved. At compilation, the Joomla Power loader first queries the local `joomla_power` record. When absent, it attempts remote/local acquisition and retries once. The JPK extractor identifies tokens; the injector adds the selected `use` import, reuses or derives aliases to avoid conflicting names, and replaces the token with the chosen PHP identifier. These mechanisms do not copy the Joomla symbol's implementation into your extension.

The normal compilation path and reverse namespace-discovery code are separate. The inspected extractor's `namespaces()` contains unfinished/debug behavior; this module does not claim a verified reverse-conversion service. Inspect the actual target before automating reverse conversion of arbitrary PHP into JPKs.
