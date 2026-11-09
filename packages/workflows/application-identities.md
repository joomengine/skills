# Choose and preserve application identities

**Authority:** project policy for new applications; source-derived implementation boundaries are pinned below. Use this workflow before authoring tables, selectors, subforms, imports or APIs. It applies to runtime application data, alongside the separate [Package identity contract](../specification.md#typed-identities-and-supported-families).

## Contents

- [Choose the relationship contract](#choose-the-relationship-contract)
- [Author the GUID variant](#author-the-guid-variant)
- [Support the numeric-ID variant](#support-the-numeric-id-variant)
- [Preserve identity through the save lifecycle](#preserve-identity-through-the-save-lifecycle)
- [Verify the whole path](#verify-the-whole-path)
- [Source and evidence limits](#source-and-evidence-limits)

## Choose the relationship contract

Recommend immutable application GUIDs for relationships between new application entities. This supports imports and exports without assuming identical auto-increment sequences in every database. Retain numeric Joomla primary keys for normal Table/controller/asset handling. Do not convert user IDs, access levels, quantities, money or every other integer into a GUID.

| Layer | Product example | Rule |
| --- | --- | --- |
| Definition | Product Admin View's package GUID | Preserve across blueprint repositories; allocate a new definition identity only for an independent adaptation |
| Application row | Product `guid` | Preserve when moving the same business record between installations |
| Local row | Product `id` | Resolve in the destination; do not assume exported numeric IDs are available or mean the same row |
| Business key | Variant `sku` | Define uniqueness, case and mutability independently; it does not replace every entity's identity |

GUIDs aid data portability; database replication, conflict resolution, ownership and deletion propagation still need an explicit design. Keep typed relationships: a Variant's Product GUID must resolve in the Product table, not whichever table happens to contain that string. Enforce uniqueness per entity table rather than inventing one cross-table database constraint.

## Author the GUID variant

For a Product with many Variants, create **both Product and Variant Admin Views**, attach them to the component and author these runtime columns through their Fields:

| Table | Column | Contract |
| --- | --- | --- |
| Product | `id` | Retained Joomla numeric primary key |
| Product | `guid` | Canonical immutable GUID with a database UNIQUE index |
| Variant | `id`, `guid` | Local primary key plus its own immutable application identity |
| Variant | `product_guid` | Indexed scalar GUID matching Product `guid`; not the Product Admin View's definition GUID |
| Variant | `sku` | Separately defined business uniqueness |

1. Search existing concrete GUID and relationship Fields before creating variants. Inspect XML, validation, save hooks and dependency closure; a readonly control is presentation, not server enforcement.
2. Use a consistent string representation, such as lowercase hyphenated GUIDs in `VARCHAR(36)`, across both sides. Choose compatible charset/collation and inspect the emitted/installed schema. A `guid` Field with `indexes=2` has an ordinary Key setting; the compiler's `DatabaseUniqueGuid` registry name does not prove a SQL UNIQUE index. Use the explicit unique setting or maintained SQL and check the actual result.
3. Validate incoming nonempty GUIDs, reject nil/malformed identities, and protect existing identities from mutation. A hidden subform `0` new-row sentinel is a form convention to consume before persistence, not a valid stored GUID. Preserve valid existing supported UUID versions during migration; do not regenerate them to enforce a new allocation preference.
4. Allocate missing new-row identities once using an appropriate secure GUID service. Keep retries and staged saves bound to that identity. Store and return the actual persisted identity; generic API creation can replace submitted GUIDs on the pinned compiler path below.
5. Configure the relationship's scalar filter, selector, query and save lookup as strings. Validate target existence, access level and parent ownership before mutation. Decide whether parent deletion is prohibited, soft, cascading or explicitly detached; a form Field does not implement that decision.
6. Use [modal relationships](modal-relationships.md) for select/edit/new flows and [normalized subforms](normalized-subforms.md) if the parent also edits Variants inline. A separate-table subform still requires the Variant Admin View and its normal model contract.
7. Seed parents first, capture persisted GUIDs, then create children. For coherent install SQL, verify both records and relations in a fresh install. Never use blueprint GUIDs or assumed local row numbers as seed relationships.

If an existing `product_id` must remain for compatibility, derive it on the server from the selected Product GUID. Reject conflicting dual inputs rather than letting clients independently choose two parents. Keep the compatibility column only for an identified consumer and migrate it deliberately.

## Support the numeric-ID variant

A deliberate local-only relationship can store `variant.product_id → product.id`. Keep both Admin Views; use the exact parent integer type/range, index the relationship, use numeric selector/query filters and enforce the same ownership/ACL/deletion rules. The relationship contract changes; the package's definition GUIDs do not.

For cross-installation import of this variant, load or create the destination Product, build a typed source-to-destination ID map using an established stable identity, and resolve children through that map. Never import a source `product_id=17` on the assumption that destination row 17 is the same Product. If no unambiguous matching identity exists, obtain a domain decision instead of matching similar titles.

Numeric and GUID variants are both supported. Prefer GUIDs when portable linkage is a requirement; preserve existing ID applications until an explicit [GUID migration](guid-migration.md) is reviewed and implemented.

## Preserve identity through the save lifecycle

Define these expectations in the maintained model/domain service, then verify every entry path:

| Operation/input | Recommended application behavior |
| --- | --- |
| Create, GUID omitted/empty/null | Allocate once and return the persisted GUID |
| Create, valid supplied GUID under an import/API contract | Preserve canonically if authorized and unique; do not promise this before inspecting the generated path |
| Create, malformed/nil/duplicate GUID | Reject explicitly; do not silently manufacture a different imported identity |
| Edit, GUID omitted/empty/null | Preserve the stored GUID |
| Edit, supplied different GUID | Reject; canonical-equivalent formatting can normalize without changing identity |
| Save as Copy | Clear local identity and application GUID; allocate a new parent and apply an explicit child-copy policy |
| API PATCH | Distinguish omitted input from explicit null/empty and from hydrated stored values |

**Pinned implementation boundary:** JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f` emits `RecordKeyFix` before `php_before_save`. It restores stored GUIDs for existing numeric IDs, clears an API-create GUID, and replaces empty/invalid/nonunique GUIDs. Therefore later `$data['guid']` alone cannot establish what the caller submitted. This protects ordinary generated identity but does not implement the stricter import-preservation/rejection contract above.

When that contract is required, preserve and validate original mutation input at the correct maintained controller/model boundary (raw API body or administrator `jform`), separate it from route selectors, authorize the target, and restore only the validated intended identity in the supported hook before downstream save logic. Inspect the exact generated ordering. Keep recursive save guards bounded, retain any staged GUID and clear temporary state in `finally`. Do not copy source-specific hook code into a different version without checking its caller and lifecycle.

Reuse relevant shared Custom Code such as `setGUIDFormPower`, `saveGUIDPower` and `formControllerEdit` only after acquiring and inspecting the actual definitions/dependencies. Their names are discovery keys, not proof that a view enables every hook. Maintain corrections in authoring records and Powers, then recompile.

## Verify the whole path

Run the same simple Product/Variant scenario for the selected key contract. Record static, generated and installed results separately:

- Create two parents and children; save/reopen and inspect the raw stored key and installed indexes.
- Select, clear, reselect, edit and linked-New through the modal; verify titles, filters and no overwrite of failed-save input.
- Attempt malformed/missing/unauthorized parent selection and identity mutation; confirm the expected error and unchanged rows.
- Exercise omission/null/empty/uppercase/duplicate/create/edit/Copy cases through the actual administrator and enabled API/import paths. Verify Copy never adopts the original parent's children.
- Import/export the graph to a second instance with different numeric IDs; assert stable GUID linkage or the explicit numeric remapping result.
- Test two simultaneous creates/imports against the uniqueness constraint; application prechecks alone do not prove race safety.

## Source and evidence limits

Inspected 2026-11-09 at JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`:

- [Creator/Builders::configureDatabaseSchema](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Creator/Builders.php): separate ordinary/unique indexes and GUID save-support registration.
- [RecordKeyFix::get](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Model/RecordKeyFix.php) and [ItemSave::get](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Model/ItemSave.php): generated identity normalization and hook order.
- [Extrusion/Resolver/Guid](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Extrusion/Resolver/Guid.php): supplied/derived blueprint identity; not an application backfill policy.

The contribution handover reports a stricter Clothing Store adapter and partial installed acceptance. This guide verifies the public source boundaries and specifies the required application tests; it does not independently certify those unavailable application archives or claim a new runtime pass.
