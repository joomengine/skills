# Build modal and linked-New relationships

Use this after choosing [application identities](application-identities.md). **Source baseline:** JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`, inspected 2026-11-09; recheck the installed compiler and Joomla target. A working title lookup does not establish a working edit route or authorized write.

## Configure one coherent key contract

For a Variant selecting a Product, first create/attach the Product Admin View, its numeric primary key, title and selected relationship key. The following concrete configuration variants use example component `com_catalogue`, table `#__catalogue_product`, singular view `product` and plural view `products`; substitute the actual persisted consumer names when authoring a different component.

| Setting | Recommended GUID relationship | Deliberate numeric relationship |
| --- | --- | --- |
| Variant Field name | `product_guid` | `product_id` |
| Storage | String matching Product `guid`, indexed | Integer matching Product `id`, indexed |
| `sql_title_table` | `#__catalogue_product` | `#__catalogue_product` |
| `sql_title_column` | `title` | `title` |
| `sql_title_key` | `guid` | `id` |
| `urlSelect` | `index.php?option=com_catalogue&view=products&layout=modal&tmpl=component&titleKey=guid` | `index.php?option=com_catalogue&view=products&layout=modal&tmpl=component&titleKey=id` |
| `urlNew` | `index.php?option=com_catalogue&task=product.add&layout=modal&tmpl=component` | Same create route |
| `urlEdit` | `index.php?option=com_catalogue&task=product.edit&guid={id}&layout=modal&tmpl=component&titleKey=guid` | `index.php?option=com_catalogue&task=product.edit&id={id}&layout=modal&tmpl=component&titleKey=id` |

Escape query separators as `&amp;` inside XML. Use `type="ModalSelect"`, the chosen `name`, label, hint and the actual supported `select`, `new`, `edit`, `clear` actions. Required/clear behavior must match the domain's nullability. Follow the concrete [Country modal specimen](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/8d1b9d7e-77c1-43d9-bc97-0dd021bfe779/item.json) for the native attribute shape, preserving its definition identity only for unchanged reuse.

The specimen's `VARCHAR(255)`, nullable and ordinary-key settings are observed configuration, not mandatory settings for every GUID column. Choose matching application schema and explicit target uniqueness. Custom Field selectors instead use `key_field`/`value_field` and table/component/view/views context; the generated `ID` token can represent `guid`, so do not cast it to integer or replace it with `a.id` blindly.

## Verify generated selection and edit independently

The inspected compiler provides these mechanisms:

1. `Attributes::getSqlTitleKey` adds `data-key-name` when the title key differs from `id`.
2. `ModalSelect::extract` supplies target metadata and adds administrator/site field overrides for a non-`id` key. The Joomla 6 override binds numeric title values as integers and nonnumeric values such as GUIDs as strings.
3. Modal list selection returns the requested key as `data-id`; it need not be the numeric primary key. Saved modal return uses the compiled target view's key/title metadata.
4. The target's ordinary Joomla edit controller still needs a numeric Table identity. JCB's own `FieldController::edit` resolves a valid `guid` when `titleKey=guid`, sets the local key and delegates to `parent::edit`.

The generic Joomla 6 `ADMIN_VIEW_CONTROLLER` template does **not** itself contain that GUID-resolving `edit()` override. For a generated component, inspect the controller/custom code and either use a verified existing adapter or maintain an equivalent target-specific adapter in the JCB definition. Resolve the GUID only in the intended table; reject missing/invalid targets; preserve parent controller checkout, component/record ACL and normal redirects. Never cast the selected GUID to an integer or bypass access checks to make Edit open.

`{id}` in `urlEdit` means the selected control value. In the GUID variant it is a GUID, regardless of the placeholder's spelling. A correct `sql_title_key` and title do not by themselves provide the edit adapter.

If two Fields select the same target using different keys or titles, test both list selection and new/edit return. `ModalSelect::extract` stores return metadata by target view, whereas the list path reads request `titleKey`; do not infer independent return contracts from one working selector.

## Bind linked-New defaults without overwriting input

A linked child list's New action and a selector's New action are different consumers. For a Product opening a new Variant, inspect the generated URL and child form's exact field names:

1. Decode the actual `init_defaults` using the generated model's contract and compare its keys with the saved child Fields. A hint named `product` does not populate a Field named `product_guid` automatically.
2. Apply a supported default adapter only for a fresh administrator GET with no existing child identity, submitted form data or failed-save recovery state. Whitelist expected keys rather than copying arbitrary request data into the model.
3. Validate/canonicalize the parent key, resolve the real Product, and check component/create/parent access and ownership requirements. A hint is not authorization.
4. Fill only an empty relationship. A numeric `refid` fallback requires its own Product lookup; do not treat it as the GUID string or override a posted choice.
5. Save through the normal child model so server-side relationship validation also covers API/import calls. Keep unauthorized values rejected even if the form hid them.

The contribution handover reports this exact `product` versus `product_guid` mismatch in Clothing Store build22 and a maintained correction. It is a reported application observation, not proof that every linked-New configuration is defective. Verify the current consumer before adding an adapter.

## Acceptance and failure diagnosis

| Case | Check |
| --- | --- |
| Select/reopen | Persist the selected key unchanged and display the target title |
| Clear/reselect/cancel | Follow required/null rules; cancel retains the previous selection |
| Edit selected target | Resolve the right numeric row and retain checkout/ACL behavior |
| New target/return | Return the new persisted key/title without confusing blueprint GUIDs |
| Linked child New | Preselect the intended parent; preserve user choice and failed-save recovery |
| Filters and queries | Match the same key/type used by storage and selection |
| Bad or inaccessible parent | Reject malformed, missing, wrong-owner and unauthorized references without unrelated writes |
| Restricted user | Test selection visibility, view level, create and edit rights separately |
| Dual selectors | Exercise each key/title variant's list and saved-return paths |

For a raw key instead of a title, inspect field override inclusion and SQL lookup. For Edit opening the wrong/new row, inspect `{id}` substitution and controller resolution. For lost defaults, compare URL hint keys with the child form and recovery state. For denied values disappearing, inspect ACL filtering before assuming serialization failed. Fix the authoring source, recompile and retest.

## Pinned source map

- [Field/Attributes](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php): `getSqlTitleKey`, `getKeyField`, `getValueField`.
- [Field/ModalSelect::extract](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/ModalSelect.php) and [Joomla 6 field override](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/FORM_MODAL_SELECT_FIELD.php).
- [ListItem/LinkLogic](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/AdminViews/ListItem/LinkLogic.php), [modal list](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/ADMIN_VIEWS_MODAL.php), [modal return](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/ADMIN_VIEW_MODAL_RETURN.php).
- [FieldController::edit](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/src/Controller/FieldController.php) compared with [generic controller](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/compiler/joomla_6/ADMIN_VIEW_CONTROLLER.php).

These are source inspections and an operational acceptance procedure, not a claim that a new compiled GUID/ID consumer was installed during this documentation update.
