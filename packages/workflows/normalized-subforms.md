# Persist subforms in their own tables

Use this workflow when a repeated editor represents rows in another application table. Start with the Demo's ordinary `Data.Subform` get/set pattern and reuse its complete authoring graph. Service Directory uses the same pattern in a larger component; complexity elsewhere in an application is not a reason to replace it with a new persistence framework.

**Project policy:** create a real **Admin View for every separately persisted child entity**, attach its database Fields and include that view in the component. The parent subform is another editor of those same rows. Menu visibility and API exposure are separate choices. Keep application rules consistent across the enabled editors.

JCB deliberately gives advanced builders unrestricted extension points. Use the existing feature first; add application-specific behavior where an actual requirement calls for it. A normal JSON subform stores a parent column; the smart-subform recipe below instead uses the child table, its GUID relationship and the shared Data service.

## Contents

- [Build the authoring graph](#build-the-authoring-graph)
- [Inspect the normal reference](#inspect-the-normal-reference)
- [Understand replacement and failure behavior](#understand-replacement-and-failure-behavior)
- [Use MultiSubform deliberately](#use-multisubform-deliberately)
- [Place the transaction correctly](#place-the-transaction-correctly)
- [Verify and recover](#verify-and-recover)

## Build the authoring graph

1. Resolve the current target under the [version policy](../../standards/version-policy.md), then find the nearest complete [smart-subform reference](../../examples/reference-patterns.md#smart-subforms). Use [entity reuse](../../standards/entity-reuse.md) to Init/Pull its records and dependencies. Retain unchanged identities; give independent adaptations new identities and update their references coherently.
2. Create or reuse the child Admin View, its real database Fields, application GUID and indexed parent relation. Include the child view in the component. Normally both parent and child retain numeric `id` primary keys and immutable row `guid` values; the child relation stores the parent's row GUID. Follow [application identities](application-identities.md) for GUID generation, indexes and copy behavior. Definition GUIDs identify blueprint records, not these application rows.
3. Reuse the repeated Field and its child controls, including the hidden child GUID. Match the control names to actual child columns. Attach it to the parent as a non-database field using the installed version's setting; the Demo attachment uses `list=2`. The child Admin View owns the stored schema, so do not introduce a competing parent JSON column.
4. Keep expert storage (`store=6`) and provide **both** `on_get_model_field` and `on_save_model_field`. Adapt the table, parent link, repeated-field name and selected columns together as shown below. The inspected compiler enables expert modeling when both handlers are nonempty.
5. Resolve the Data Factory and its `Data.Subform` dependencies through the imported Power definitions and providers. Retain the Super Power key in authored PHP so JCB resolves the class and its dependencies. The standard handlers are sufficient callers; create a custom Power only for additional behavior the application actually needs.
6. Save and reopen the blueprint, compile and install. Inspect the generated schema and handlers, then create and edit the same child rows through both editors. If a GUI code location is unclear, [trace it with a comment and compiler diagnostics](debug.md#trace-a-gui-code-field). Repeat the child-view requirement for every physical table in a nested design.

The result is a reusable parent Field, a real child entity and a reproducible relationship, all maintained in JCB authoring records.

## Inspect the normal reference

**Observed examples**, inspected 2026-11-09: Demo in Packages `master@4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9`; Service Directory blueprint `master@a0041f0d408ca65ac43796f89a90c88063fe85a8`. These are source references, not required JCB installation versions. The [reference catalogue](../../examples/reference-patterns.md#smart-subforms) locates the complete graphs.

| Role in the Demo example | Definition |
| --- | --- |
| Parent Look Admin View | `93a34bf3-aa25-4a14-8496-ae7d0340e0b9` |
| Child Address Admin View | [`b7b2aba5-8a94-443b-814b-aed5b0b7c550`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/admin_view/b7b2aba5-8a94-443b-814b-aed5b0b7c550/item.json) |
| Repeated Addresses Field | [`71e5f1b0-7c81-4fbb-8a05-e3949212f2ed`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/71e5f1b0-7c81-4fbb-8a05-e3949212f2ed/item.json) |
| Parent attachment | [`admin-fields.json`](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/admin_view/children/93a34bf3-aa25-4a14-8496-ae7d0340e0b9/admin-fields.json), `list=2` |

The complete ordinary get/save pair below preserves the Demo's behavior, with line breaks for readability. These example names describe that source graph; adapt them to the requested entity rather than creating an Address feature in every application.

**Get handler** (`on_get_model_field`):

```php
[[[field]]] = Super___9d76b8dc_3883_4755_b11c_131d19ca8a53___Power::_('Data.Subform')
	->table('address')
	->get(
		$item->guid ?? '',
		'look',
		'addresses',
		['guid', 'type', 'line_one', 'line_two', 'country', 'state', 'city', 'postal']
	);
```

**Save handler** (`on_save_model_field`):

```php
if (isset([[[field]]]))
{
	Super___9d76b8dc_3883_4755_b11c_131d19ca8a53___Power::_('Data.Subform')
		->table('address')
		->set([[[field]]] ?? [], 'guid', 'look', $data['guid'] ?? '');
}
```

| Value | Meaning to preserve when adapting |
| --- | --- |
| `address` | Child table name used by the Data service |
| `look` | Child column containing the parent row GUID |
| `addresses` | Repeated Field name used to shape the returned rows |
| `guid` in `set()` and the selected columns | Child row identity, round-tripped by a child control |
| `$item->guid` / `$data['guid']` | The same parent application identity in get/save contexts |
| Remaining selected columns | Actual child values required by the editor |

`[[[field]]]` is a compiler placeholder: JCB supplies the appropriate field expression in each handler. Keep it in authored source. `get()` returns the requested columns with repeated keys such as `addresses0`. The `isset` save guard leaves an absent/null Field untouched; an explicitly submitted empty array requests an empty child collection. This is a complete-collection editor, not a partial-row PATCH operation.

Service Directory's [Company Addresses Field](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/field/9ef6e0ca-7d3e-40e6-b8ea-ff43224573f8/item.json) uses the same pair with `company` as the parent link. Its generated [CompanyModel](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/admin/src/Model/CompanyModel.php) contains the corresponding get and save calls. Reuse this mechanism for an ordinary smart subform; do not replace it with manual database queries, staged saves or bespoke access/store classes merely because those extension points exist.

## Understand replacement and failure behavior

The ordinary form needs a complete child collection and a valid parent identity. Additional API, import, ownership or business requirements can change how that collection is prepared; identify the requirement before extending the handler.

**Source behavior:** [Subform::set/process/purge](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/85785701-07b2-4f81-bc1e-0f423700c254/code.power), shared Powers `master@9cd980492bed4c8177a6e32b703641950ec93604`, inspected 2026-11-09:

| Input or stage | Behavior and when it matters |
| --- | --- |
| Non-array submitted collection | Converted to `[]`; can purge existing children. Validate collection shape for callers that can submit malformed input. |
| Existing child omitted from the collection | Purged before remaining rows are written. This implements removal in the complete editor; a partial-update API must prepare its intended complete set or use a suitable partial-write operation. |
| Supplied `guid`/`id` not owned by this parent | Treated as new: GUID regenerated or numeric ID reset to `0`. If the application requires rejection of cross-parent identities, enforce that requirement before mutation. |
| Parent relation in a submitted row | Replaced with the supplied `linkValue`. Obtain it from the actual parent being edited. |
| Empty collection after purge | Returns `true` without an upsert. |
| Purge returns `false` | `purge()` does not propagate the delete result. Where checked failure handling is required, inspect the current Items implementation and verify deletion; an outer boolean alone does not establish success. |
| Other `indexKey` name | Does not receive the GUID/ID ownership regeneration logic; inspect its semantics before substituting a business key. |

Application permissions, stock invariants, revision checks and aggregate transactions are separate requirements. Apply them consistently to the parent editor, child Admin View and any enabled API/import path. When one requires an extension, reuse or compose the shared implementation and add the smallest necessary behavior; `Subform` accepts `ItemsInterface` for specialized consumers. A guarded adapter is an available design choice, not a prerequisite for every smart subform. Preserve the established GUID lifecycle; a control's new-row sentinel must not become a stored application GUID.

For a get/save initiator problem, inspect the target compiler. In [Field Data::getData](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php), `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`, the get-initiator branch tests `initiator_on_save_model` before decoding `initiator_on_get_model`. A get-only initiator is therefore not independently enabled by that inspected path. Verify the affected combination on the installed release. Field ACL filtering can also remove submitted data using `unset`; inspect that before changing persistence code.

## Use MultiSubform deliberately

Use the Demo's Countries and States/Cities examples when the requested editor needs nested child collections. Import their complete graph and inspect how each physical table is represented by an Admin View. A nested form is not a reason to merge several entities into a JSON column or create a custom persistence engine by default.

[MultiSubform](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/e0198c3f-777a-4a0b-87b7-e6a198afc8f9/code.power) composes Subform with a `_core` map plus nested maps. Core get requires `table`, `linkValue`, `linkKey`, `field`, `get`; core set requires `table`, `indexKey`, `linkKey`, `linkValue`. A nested `linkValue` such as `data:guid` resolves from the current core row, rather than storing that expression literally. Trace the [Countries Multi Field](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/4d96ceea-7dd1-45c3-86fd-0d73d66332a8/item.json) and [States/Cities Multi Field](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/9a21f28b-b818-4cc5-b18a-c3fa33a5876d/item.json) when adapting the maps.

At that pinned source, omitted/null nested keys are skipped (`isset`); explicit empty/non-array values become `[]` and can clear children. False nested results make the overall result false while siblings continue; exceptions escape. Core deletion does not itself establish grandchild cascading. Verify the requested deletion behavior at each level.

If a new nested row links to the wrong GUID or a set map is rejected, inspect two source paths identified at that revision: `prepLinkValue()` can allocate a core GUID before inner Subform replaces an unowned GUID in its by-value data; and `handleCoreSetMap()` validates a nested set map using `validGetMap()`. Reproduce the affected case on the current target before choosing a correction. Record the failing keys/map and fix the appropriate maintained source or use a scoped workaround. These findings concern those paths; they do not require replacing ordinary single-level `Data.Subform` handlers.

## Place the transaction correctly

Use the ordinary get/set lifecycle unless the application requires an additional transaction boundary or an observed failure demonstrates a need. For requirements such as an atomic stock adjustment, identify all writers and test the actual Joomla/database lifecycle before designing the boundary.

The Clothing Store handover reported that parent Table save/asset nested-set locking caused an implicit database commit, leaving earlier child writes after a failed parent save. That reported lifecycle motivated its custom staging implementation. It is a case to investigate when similar symptoms occur, not the default recipe for all child editors.

If that lifecycle is reproduced and the required child batch must be atomic, one option is to validate/stage without writes, save the parent normally, then apply the child batch in a checked child-only transaction. Recheck the relevant access, ownership and domain constraints at the write boundary; protect concurrency-sensitive invariants with suitable locks or conditional writes. Roll back on failed operations and report a parent-saved/children-failed outcome accurately. Do not promise whole-aggregate atomicity across Joomla Table/Asset storage without exercising the exact driver and lock path.

Any such extension must cover each enabled caller, clear temporary state on failure and preserve the intended Save as Copy behavior. Keep it in maintained authoring source with real callers and [readable code](../../standards/authored-code.md), rather than adding unrelated staging machinery to every Field handler.

## Verify and recover

Use [Playground package acceptance](validate-and-integrate.md) with a parent and at least two children. Confirm the child table exists, the repeated Field has no competing parent column, and generated handlers use the intended table and keys.

- Create, reopen and edit the parent and its children; confirm both Admin Views show the same persisted rows and GUID relationship.
- Add a child, remove one, clear the collection and save unchanged. Confirm an absent Field does not clear existing rows. Verify Save as Copy follows the chosen fresh-identity/copy policy.
- Check the permissions and validation relevant to the feature. For an API/importer, also exercise its collection shape, ownership and partial-update contract.
- For MultiSubform, add a new core row plus grandchild and compare the persisted link with the persisted core GUID; check the requested omission, removal and deletion behavior at each level.
- If the feature has transaction, revision or inventory requirements, force the relevant failure/concurrent change and inspect committed rows. Test any promised partial-success message through each applicable caller.

If children disappear, duplicate or fail to load, trace the saved Field, its child controls, parent GUID lifecycle, generated handler and installed table before creating a replacement service. Restore disposable test data after a failed probe, correct the authoring records or shared Power, and compile/install again. Report unresolved build obstacles through the [Skills feedback workflow](../../testing/reporting-issues.md) with the smallest reproducible case.
