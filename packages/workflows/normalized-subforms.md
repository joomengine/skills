# Persist subforms in their own tables

Use this workflow when a repeated editor represents independently stored application entities, such as Product → Variants. A normal JSON subform serializes a parent column. Separate-table persistence requires the child table/model, relationships, read/write handlers and actual service dependencies.

**Project policy:** create a real **Admin View for every separately persisted child entity**, attach its database Fields and include that view in the component. A parent subform is an additional editor of those rows. Whether the child's list is exposed in a menu and whether it has an API are separate choices. Both editors must enforce the same domain rules.

## Contents

- [Build the authoring graph](#build-the-authoring-graph)
- [Inspect the normal reference](#inspect-the-normal-reference)
- [Understand replacement and failure behavior](#understand-replacement-and-failure-behavior)
- [Use MultiSubform deliberately](#use-multisubform-deliberately)
- [Place the transaction correctly](#place-the-transaction-correctly)
- [Verify and recover](#verify-and-recover)

## Build the authoring graph

1. Record Joomla/JCB/PHP versions and resolve the parent, child and Field definitions. Choose [application identities](application-identities.md): normally each child retains a numeric `id`, has its own immutable application `guid`, and stores an indexed parent GUID. These are not the JCB definitions' GUIDs.
2. Create or reuse the child Admin View, its real database Fields, unique application identity index, parent relation and component-to-view attachment. For nested entities, repeat this for **each** physical table. Inspect installed SQL; an XML control cannot create a missing table.
3. Create the repeated Field with child controls. Include a child key control and all values required for a complete edit round trip. Attach the repeated Field to the parent as a non-database field, using the installed version's setting; the Demo's attachment uses `list=2`. Do not add a second parent JSON column as an accidental competing source of truth.
4. Set expert storage (`store=6`) and supply **both** `on_get_model_field` and `on_save_model_field`. The inspected compiler enables expert modeling only when both are nonempty. Keep complex logic in a cohesive application Power; keep Field handlers as callers.
5. Resolve Data Factory, `Data.Subform`, its interfaces, Guid trait, Items implementation and providers through their actual `settings.json` dependencies. The final Subform class accepts `ItemsInterface` aliased as `Items`; composition can inject a guarded adapter without copying the shared class.
6. Save and reopen the blueprint. Compile, inspect the expanded get/save code and install it. Verify child rows through both parent and child interfaces before adding a second nesting level or exposing an API.

The compiler's [Field Data::getData](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php) was inspected at `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f` on 2026-11-09. Its get-initiator branch tests `initiator_on_save_model` before decoding `initiator_on_get_model`. Thus a get-only initiator is not independently enabled by that path. Verify the both/get-only matrix on the actual compiler; do not assume optional initiators operate independently. Field ACL filtering can also remove submitted data using `unset`.

## Inspect the normal reference

**Observed example**, Packages `master@4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9`, inspected 2026-11-09:

| Role | Definition |
| --- | --- |
| Parent Look Admin View | `93a34bf3-aa25-4a14-8496-ae7d0340e0b9` |
| Child Address Admin View | [`b7b2aba5-8a94-443b-814b-aed5b0b7c550`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/admin_view/b7b2aba5-8a94-443b-814b-aed5b0b7c550/item.json) |
| Repeated Addresses Field | [`71e5f1b0-7c81-4fbb-8a05-e3949212f2ed`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/71e5f1b0-7c81-4fbb-8a05-e3949212f2ed/item.json) |
| Parent attachment | [`admin-fields.json`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/admin_view/children/93a34bf3-aa25-4a14-8496-ae7d0340e0b9/admin-fields.json), `list=2` |
| Data Factory / Subform | `9d76b8dc-3883-4755-b11c-131d19ca8a53` / `85785701-07b2-4f81-bc1e-0f423700c254` |

The specimen's get handler is:

```php
[[[field]]] = Super___9d76b8dc_3883_4755_b11c_131d19ca8a53___Power::_('Data.Subform')
	->table('address')
	->get($item->guid ?? '', 'look', 'addresses',
		['guid', 'type', 'line_one', 'line_two', 'country', 'state', 'city', 'postal']);
```

Its save handler calls `set(rows, 'guid', 'look', parentGuid)` when the submitted Field is set, but ignores the boolean result. This is configuration evidence, not a safe domain policy to copy unchanged. `[[[field]]]` is a compiler placeholder whose expansion differs in get/save contexts. `get()` projects only requested columns; repeated output uses keys such as `addresses0`. Reject/skip reads with an empty new-parent key in the application facade, and retain the expected form shape.

## Understand replacement and failure behavior

**Source behavior:** [Subform::set/process/purge](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/85785701-07b2-4f81-bc1e-0f423700c254/code.power), shared Powers `master@9cd980492bed4c8177a6e32b703641950ec93604`, inspected 2026-11-09:

| Input or stage | Behavior / required application decision |
| --- | --- |
| Non-array submitted collection | Converted to `[]`; can purge all existing children. Validate shape before calling. |
| Existing child omitted from submitted collection | Purged before remaining rows are written. Define whether omission means deletion; reject omissions when independent child editing or PATCH requires preservation. |
| Supplied `guid`/`id` not owned by this parent | Treated as a new row: GUID regenerated or numeric ID reset to `0`. Reject hostile/wrong-parent identities in the adapter when silent duplication is unacceptable. |
| Parent relation in submitted row | Overwritten with the supplied `linkValue`. Validate the parent and access before selecting that value. |
| Purge fails with `false` | `purge()` ignores the delete result. Checking only the outer boolean is insufficient. Make the injected Items adapter throw on failed operations. |
| Empty collection after purge | Returns `true`; no upsert happens. A true return does not prove deletion succeeded. |
| Other `indexKey` name | Does not receive the GUID/ID ownership regeneration logic. Do not assume arbitrary alternate keys are equally protected. |

The class does not supply application ACL, revisions, inventory invariants or a transaction. A guarded Items adapter must validate the complete proposed set before any delete/update; enforce typed ownership and immutable identity; and check every database result. Keep business rules shared with the child Admin View/API/importer. A stored `0` GUID is invalid even if the hidden control uses it as a new-row sentinel.

## Use MultiSubform deliberately

[MultiSubform](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/e0198c3f-777a-4a0b-87b7-e6a198afc8f9/code.power), GUID `e0198c3f-777a-4a0b-87b7-e6a198afc8f9`, composes Subform with a `_core` map plus nested maps. Core get requires `table`, `linkValue`, `linkKey`, `field`, `get`; core set requires `table`, `indexKey`, `linkKey`, `linkValue`. A nested `linkValue` such as `data:guid` resolves from the current core row; it is not a literal stored parent key.

Trace the Demo [Countries Multi Field](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/4d96ceea-7dd1-45c3-86fd-0d73d66332a8/item.json) and [States/Cities Multi Field](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/9a21f28b-b818-4cc5-b18a-c3fa33a5876d/item.json), their owner attachments and all child Admin Views before adapting them.

At the pinned source, omitted or null nested keys are skipped (`isset`); explicit empty/non-array nested values become `[]` and can clear children. False nested results set an overall false status while siblings continue; exceptions escape. Deleting a core row does not establish grandchild cascading. Define and test deletion at each level.

Two source-level hazards require a target-specific reproduction before new nested writes: `prepLinkValue()` may allocate a new core GUID, but inner Subform replaces unowned GUIDs in its by-value data, leaving the outer nested-link data with the earlier GUID; and `handleCoreSetMap()` validates a nested set map using `validGetMap()`. Do not describe these versions as safe for arbitrary deep nesting. Preserve a synthetic failing case and use a maintained, scoped adapter/correction with verified keys, or choose a tested single-level editor. A Skills change does not fix these shared implementations.

## Place the transaction correctly

The supplied Clothing Store handover reports that Joomla parent Table save/asset nested-set locking caused an implicit database commit, leaving earlier child writes after a failed parent save. Its companion runtime artifacts were not supplied with this documentation change; treat that installed result as a reported finding, not a newly reproduced pass.

**Derived safe workflow for that lifecycle:** validate and stage children without writes; save the Joomla parent normally; then open a child-only application transaction, reload/recheck parent authorization, child ownership and revisions, and apply the entire child batch. Throw on every failed write and roll back the child batch. If the last phase fails, report explicitly that parent details were saved but children were not. Do not promise whole-aggregate atomicity around Joomla Table/Asset storage without testing the exact driver and lock path.

Maintain the staged parent GUID across guarded recursion, clear temporary state in `finally`, and verify every caller, including API saves. A controller post-save hook alone is not proof all save paths invoke the boundary. Save as Copy must generate a fresh parent identity and deliberately duplicate or omit children with new identities; it must never adopt the original child rows.

Protect revision checks through the actual writes with row locks or conditional revision updates and checked affected-row counts. A child transaction with an ordinary reread alone does not exclude a concurrent editor between validation and mutation.

## Verify and recover

Use [Playground package acceptance](validate-and-integrate.md) with synthetic parents A/B and at least two children. Record generated handler locations, installed schema, before/after keys and exact runtime versions.

- Create a new parent with children, reopen, edit one child, save unchanged, and inspect both Admin Views against the same rows.
- Submit wrong-parent, duplicate, malformed and new-child keys; inspect rejected writes and ensure parent B is untouched.
- Exercise missing Field, empty collection, malformed collection, omitted row, denied Field access, failed validation and Save as Copy separately.
- For MultiSubform, add a new core plus grandchild and prove the persisted grandchild key equals the **persisted** core GUID; test omitted/null/empty nested inputs, nested failure and core deletion.
- Force failure before parent save and late in child writes. Check actual committed rows, not only exceptions or success banners. Test parent/child partial-success reporting.
- Repeat through each enabled API/import path with revisions and partial-update semantics. Compile again from maintained source and repeat the affected case.

On an unexpected delete or partial write, stop dependent edits, preserve the sanitized reproduction and restore the disposable fixture. Correct the blueprint/Power adapter and recompile. Report source inspection, isolated probes and installed acceptance separately; no full runtime pass is established by this guide.
