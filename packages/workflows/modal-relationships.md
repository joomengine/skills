# Build modal and linked-New relationships

Use a managed relationship when users need to choose an existing entity, create one or edit its details. Start with the shared ModalSelect Field and its target Admin View/controller pattern from the [reference catalogue](../../examples/reference-patterns.md#managed-relationships). Reuse the complete feature through JCB; it already supplies selection, title lookup and modal actions.

Choose [application identities](application-identities.md) first. The default for a new application relationship is a stored row GUID, while each Joomla table keeps its numeric primary key. A blueprint definition GUID is not a selected application value.

## Reuse the complete relationship

1. Identify the entity the user manages separately and create or reuse its actual Admin View, database Fields, title and GUID lifecycle. Attach it to the component. A managed category, for example, needs a category entity and selector; a free-text category control cannot provide shared records, selection or repeatable relationships. If the task explicitly calls for Joomla core categories, use that integration's key contract instead.
2. Find the closest existing ModalSelect Field and target view in the Demo or Service Directory. Use [entity reuse](../../standards/entity-reuse.md) to Init/Pull the Field, Field Type, target records and companion Custom Code/Powers. Preserve unchanged definitions; allocate new identities for independent adaptations and remap their references.
3. Adapt the Field name and label, target table/title/key and Select/New/Edit routes together. Store the chosen GUID in a matching indexed relationship column. Keep the target's numeric `id`, unique application `guid` and actual title column distinct.
4. Include the target view's GUID-aware Edit behavior. Both reference components use the reusable `formControllerEdit` Custom Code in the target Admin View's `php_controller`; it resolves the selected GUID to the numeric Joomla identity and delegates to the ordinary controller. Import this companion behavior and its Power dependency with the Field rather than writing a new controller merely to open the modal.
5. Enable the actions the application needs: `select`, `new`, `edit`, `clear`. Match required/clear behavior to the relationship's nullability and access policy. Use the corresponding shared custom selector recipe if that better fits the UI; its `key_field`/`value_field` and component/table/view context must describe the same relationship.
6. Use the same relationship key in list filters, [Dynamic Get](dynamic-get.md) joins and import/export mapping. For managed categories, verify the selected record's title appears where the user needs it; do not reintroduce an unrelated text category beside the actual relationship.
7. Save/reopen, compile and install. Select an existing target, save/reopen its owner, create a target through New, edit it and return. Inspect persisted keys and exercise the actions as the intended user. Fix any discrepancy in the authoring records and regenerate.

## Configure one coherent key contract

**Observed specimen:** Demo [Country modal Field](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/8d1b9d7e-77c1-43d9-bc97-0dd021bfe779/item.json), Packages `master@4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9`, inspected 2026-11-09. Its exact native attribute shape is:

```xml
<field
	type="ModalSelect"
	name="country"
	label="Country"
	sql_title_table="#__###component###_country"
	sql_title_column="name"
	sql_title_key="guid"
	urlSelect="index.php?option=com_###component###&amp;view=countries&amp;layout=modal&amp;tmpl=component&amp;titleKey=guid"
	urlNew="index.php?option=com_###component###&amp;task=country.add&amp;layout=modal&amp;tmpl=component"
	urlEdit="index.php?option=com_###component###&amp;task=country.edit&amp;guid={id}&amp;layout=modal&amp;tmpl=component&amp;titleKey=guid"
	titleSelect="Select A Country"
	titleNew="New Country"
	titleEdit="Edit the Country"
	iconSelect="icon-copy"
	select="true"
	new="true"
	edit="true"
	clear="true"
	required="true"
	class="input-large"
	description="Select the country."
	hint="Select a Country"
/>
```

The Country names are this reference's entity names; adapt them together for the requested relationship. `###component###` is a compiler placeholder to preserve in portable source. XML query separators use `&amp;`. The specimen uses the shared ModalSelect Field Type `a1cdb0a5-517c-425c-998a-333e92af3e32`.

| Setting | GUID relationship | Deliberate numeric relationship |
| --- | --- | --- |
| Stored relationship | String matching the target row's `guid`, indexed | Integer matching the target row's `id`, indexed |
| `sql_title_table` / `sql_title_column` | Actual target table and display column | Same target table and display column |
| `sql_title_key` | `guid` | `id` |
| Select route | Target plural modal view with `titleKey=guid` | Target plural modal view with `titleKey=id` |
| New route | Target singular `.add` task and modal layout | Same creation contract |
| Edit route | Target singular `.edit`, `guid={id}`, `titleKey=guid` | Target singular `.edit`, `id={id}`, `titleKey=id` |
| Controller identity | Shared GUID-to-numeric lookup, then normal Joomla Edit | Normal numeric Joomla Edit |

`{id}` in a modal URL means the selected control value; in the GUID case it is a GUID despite the placeholder's spelling. Do not cast it to an integer. Likewise a generated custom selector's `ID` token can represent `guid`; inspect its declared key before substituting `a.id`.

The Field specimen's `VARCHAR(255)`, nullable and ordinary-index settings are observed configuration, not mandatory settings for every GUID column. Choose matching relationship types and explicit target uniqueness under the identity policy.

## Reuse the target controller behavior

The Demo [Country Admin View](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/admin_view/6acc4069-1c33-4470-85a6-07bc9bb16d10/item.json) sets `php_controller` to `[CUSTOMCODE=formControllerEdit]`. The corresponding [Custom Code](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/custom_code/formControllerEdit/item.json) uses the GuidHelper Super Power key with `###view###` and `###component###` placeholders, resolves the target's numeric key and calls `parent::edit()`.

Service Directory uses the same arrangement in its [Country blueprint](https://github.com/joomengine/joomla-packages/blob/a0041f0d408ca65ac43796f89a90c88063fe85a8/src/admin_view/73177bc7-8db6-403e-b859-0613a2876171/item.json); the generated [CountryController::edit](https://github.com/joomengine/Joomla-Service-Directory/blob/d25ca95084d79e552e2ae99f67011679d41d3ad4/admin/src/Controller/CountryController.php) shows where JCB places it. These examples were inspected on 2026-11-09 at blueprint `master@a0041f0d408ca65ac43796f89a90c88063fe85a8` and generated component `6.x@d25ca95084d79e552e2ae99f67011679d41d3ad4`.

Preserve the ordinary controller's checkout, component/record ACL and redirects. Verify invalid, missing and inaccessible targets on the actual consumer; add a scoped correction if its requirements demand different handling. A working title lookup alone does not exercise Edit, and an incomplete import of only the Field can omit the companion behavior.

## Bind linked-New defaults without overwriting input

A linked child list's New action and a selector's New action are different consumers. Configure the linked view and relationship first, then inspect the generated route and fresh child form. Reuse the existing linked-view behavior when it already fills the relationship correctly.

If the intended default is missing:

1. Decode the actual `init_defaults` using the generated model's contract and compare its keys with the saved child Fields. A hint named `product` does not populate a Field named `product_guid` automatically.
2. Correct the source mapping. If the target needs a default adapter, apply it only to a fresh administrator GET with no existing child identity, submitted form data or failed-save recovery state; accept only the intended default keys.
3. Resolve the parent and apply the required create/parent access checks. A URL hint is not authorization. A numeric `refid` fallback needs its own parent lookup; it is not a GUID string.
4. Fill only an empty relationship and preserve posted choices. Save through the normal child model so the relationship's validation also covers enabled API/import callers.

The Clothing Store handover reported a `product` versus `product_guid` mismatch in its linked-New path. Treat that as a diagnostic example: compare the actual names before adding custom code to an otherwise working reference pattern.

## Acceptance and failure diagnosis

| Case | Check |
| --- | --- |
| Select/reopen | Persist the selected key unchanged and display the target title |
| Clear/reselect/cancel | Follow required/null rules; cancel retains the previous selection |
| Edit selected target | Resolve the right numeric row and retain checkout/ACL behavior |
| New target/return | Return the new persisted key/title without confusing blueprint GUIDs |
| Linked child New, when enabled | Preselect the intended parent; preserve user choice and failed-save recovery |
| Filters and queries | Match the same key/type used by storage and selection |
| Inaccessible or invalid target | Follow the relationship's access/validation policy without unrelated writes |
| Restricted user | Exercise the enabled selection, create and edit actions under the intended permissions |
| Multiple selectors for the same target | Exercise each key/title variant's list and saved-return paths |

For a raw key instead of a title, inspect field override inclusion and SQL lookup. For Edit opening the wrong/new row, inspect `{id}` substitution and the target's imported controller Custom Code. For lost defaults, compare URL hint keys with the child form and recovery state. For denied values disappearing, inspect ACL filtering. [Trace the relevant GUI field](debug.md#trace-a-gui-code-field) when its generated destination is unclear, then fix authoring source and recompile.

## Pinned source map

The following compiler paths were inspected at JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f` on 2026-11-09. Use the [latest JCB policy](../../standards/version-policy.md); these references identify observed behavior, not a required installation.

- [Field/Attributes](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php): `getSqlTitleKey` adds `data-key-name` for a non-`id` title key; `getKeyField` and `getValueField` govern custom selector keys.
- [Field/ModalSelect::extract](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/ModalSelect.php) supplies target metadata and administrator/site field overrides for a non-`id` key. The [Joomla 6 override](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/FORM_MODAL_SELECT_FIELD.php) binds numeric title values as integers and nonnumeric values as strings.
- [ListItem/LinkLogic](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/AdminViews/ListItem/LinkLogic.php), [modal list](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/ADMIN_VIEWS_MODAL.php) and [modal return](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/ADMIN_VIEW_MODAL_RETURN.php) implement linked/default and return paths. List selection returns the requested key as `data-id`; saved return uses the target view's compiled metadata. `ModalSelect::extract` stores that metadata by target view, so test differing key/title selectors sharing one target.
- JCB's [FieldController::edit](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/src/Controller/FieldController.php) contains GUID resolution. The [generic controller template](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/ADMIN_VIEW_CONTROLLER.php) does not supply that override itself; the Demo and Service Directory Custom Code above supplies it for those generated targets.

For an unresolved build obstacle or missing reusable recipe, follow the [Skills feedback workflow](../../testing/reporting-issues.md) with the affected Field/view mapping and a minimal reproduction.
