# Define concrete Fields and application relationships

A package [`field`](../reference/field.md) is a concrete reusable form/storage definition. Its `fieldtype` GUID points to the separate [Field Type catalogue](../../field-types/README.md). The catalogue describes available properties and suggestions; the Field owns its chosen XML and storage settings. A Field becomes part of an Admin View through `admin_fields`, or part of component/module/plugin options through the corresponding configuration collection.

## Keep four boundaries explicit

| Boundary | What to author and verify |
| --- | --- |
| Package graph | Field GUID, Field Type GUID and detected dependencies; these identify authoring records. |
| Form | XML `name`, runtime `type`, label/description, attributes/options, filtering, required/validation and custom code where supported. |
| Storage | Datatype, `datalenght`/`datalenght_other`, `datadefault`/`datadefault_other`, `null_switch`, indexes and store/model transforms. Preserve the historical field names. |
| Consumer attachment | Tab/list/title/alias/search/filter/permissions and database inclusion in `admin_fields`, or option grouping/override in another owner. |

The compiler [Field/Data](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php) joins the current Field Type properties to the saved Field and decodes its database XML/model values. Package serialization reverses database storage transforms: use the [reference](../reference/field.md) and package contract, not database-encoded strings copied by inspection. In particular, database JSON storage of XML does not mean adding another JSON-string layer to an already decoded repository value.

Read [Joomla source research](../../field-types/joomla-research.md) before claiming an XML attribute/default is supported. A catalogue example is not necessarily the Joomla core default or this Field's chosen value. The runtime `type` and custom field implementation must actually exist for the target Joomla version.

## Storage choices change behaviour

The inspected Field form offers indexes `0` none, `1` unique key, `2` ordinary key; nullability is the literal `NULL` or `NOT NULL`. Use `datalenght=Other` with `datalenght_other` for an allowed custom length, and `datadefault=Other` with its companion for a custom default. Empty, zero, SQL NULL and a literal empty string require deliberate design; do not normalize them together.

`store` exposes `0` default, `1` JSON, `2` Base64, `3` basic encryption using a local database key, `5` medium encryption using a local file key, and `6` expert custom handling. The compiler also contains a legacy `store=4` path; its existence is not a reason to select an unoffered mode for a new Field. Resolve older specimens against source instead of silently changing their values.

Expert mode uses `on_get_model_field`/`on_save_model_field` and optional initiator hooks; the inspected compiler only activates the custom path when both model handlers contain code. Choose a reversible transformation and document expected input/output types, failure behaviour, key/configuration dependencies and migration effects. Base64 is encoding, not encryption. Searching/sorting/filtering a transformed column may not have the meaning it had for plaintext/scalar data. Test saved raw values, decoded values, empty/zero/null, multiple rows and failed decoding.

Initiator availability is version-sensitive: [Field/Data at `037752c`](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php) tests `initiator_on_save_model` before preparing the get initiator from `initiator_on_get_model`. A get-only initiator is therefore not independently enabled by that inspected path. Inspect generated output and test both/get-only configurations before relying on it. A scalar GUID relationship normally uses ordinary scalar storage; selecting expert mode solely because the value is a GUID adds no identity guarantee.

CSS/JavaScript settings on a Field have their own singular/plural view enable flags. A reusable Field can therefore affect several consumers. Preserve existing identity for an intentional shared update and enumerate affected consumers; create a distinct checked Field identity when it is an independently adapted definition.

## Choose the relationship mechanism

| Need | Appropriate mechanism and boundary |
| --- | --- |
| Reference another JCB authoring record | A declared GUID link/subform field plus package dependency; not automatically an application database relation. |
| Select one generated application record with create/edit/select actions | A supported ModalSelect Field; configure actual target table/title/key and selection/edit/new routes. Verify stored key type and ACL. |
| Query a straightforward option list | A Joomla SQL Field with correct query, key/value mapping and target context; a query-backed control does not create its target table. |
| Reusable/context-sensitive selector logic | A Custom Field extending the appropriate core type, with generated class body, table/component/view/key/value context and dependencies as required by the actual template. |
| Store repeated embedded rows | Subform XML referring to child Field GUIDs; deliberate structured storage, usually requiring JSON-compatible model handling. Does not create a normalized join table. |
| Store multiple selected values | A supported multiple control plus chosen storage and query strategy. `multiple` is not a database cardinality/migration definition. |
| Model a relationship with its own attributes/lifecycle | A separate Admin View/table with appropriate reference Fields, uniqueness/query/permission design and owner/child presentation. |
| Use users/categories/tags/access or other Joomla-managed data | Prefer the applicable Joomla core Field and service; do not replace a Joomla-managed relationship with a similarly named local table without a reason. |
| Read/join records for presentation | [Dynamic Get](presentation-and-queries.md), separate from the form's write/storage path. |
| Compose list columns | [Admin Field Relations](admin-views.md#relations-are-list-composition), separate from foreign-key or read-query design. |

Before writing XML, decide target ownership, cardinality, key type, editing/read needs, delete/update policy and permissions. Recommend an immutable application GUID for new portable application relationships while retaining numeric Joomla primary keys. Distinguish definition GUID, application GUID, local numeric ID and business key using [application identities](../workflows/application-identities.md); that guide also specifies the supported numeric-ID alternative. Existing applications need an explicit [migration](../workflows/guid-migration.md), not an automatic change of every integer column.

For ModalSelect, inspect `sql_title_table`, `sql_title_column`, `sql_title_key`, `urlSelect`, `urlNew`, `urlEdit` and the enabled actions against the real component routes. For Custom Fields, use the actual compiler's body/context contract and proper concrete XML encoding. A raw PHP body in catalogue metadata and the encoded value in a saved Field are separate stages. See [custom Field Type example](../../field-types/examples/custom-repository/README.md) and [Field/ModalSelect](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/ModalSelect.php), [Field/Attributes](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php).

Follow [modal relationships](../workflows/modal-relationships.md) for the complete GUID/ID configuration and acceptance sequence. `sql_title_key=guid` can enable GUID title lookup and selection without supplying the target controller's GUID-to-numeric edit adapter. Verify stored value, displayed title, edit route, linked-New defaults and authorization independently.

## Subform Fields and validation

JCB can also present a subform whose rows persist in a separate application table. The inspected [Addresses (look-subform) specimen](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/field/71e5f1b0-7c81-4fbb-8a05-e3949212f2ed/item.json) uses expert storage (`store=6`) and both model handlers to call the `Data.Subform` service against the `address` table with the parent `look` relation. Its PHP handlers provide normalized persistence; the subform XML provides the controls. Trace the [complete reuse example](../../examples/clothing-store.md#trace-an-existing-normalized-subform), including its separate Admin View, factory/service dependencies, owner attachment and API configuration. Test writes from both parent form and child API against the same rows. A plain subform does not create this infrastructure automatically.

Give **each separately stored child entity its own actual Admin View**, with database fields, identity, parent relationship and permissions, and attach it to the component's generated model graph. A hidden menu item or nested editing experience does not remove that authoring requirement. Attach the parent's expert subform as non-database UI when its handlers own persistence; do not also save a competing JSON copy as the authoritative child data. Follow [normalized subforms](../workflows/normalized-subforms.md) for exact reference handlers, replacement semantics and safe save boundaries.

The package resolver scans a Field XML's `fields="..."` references and `validate="..."` rule separately from ordinary table links. Ensure every nested Field exists, has its own intended type/attributes, and is not accidentally attached as an extra top-level database column. Check nested names, repeatability, required fields, save/reopen shape and how the application queries/validates that structure. Do not presume arbitrary alternate quoting or dynamically assembled XML is recognized by every scanner; use the exact supported representation and inspect generated dependencies.

[`validation_rule`](../reference/validation_rule.md) uses its **name** as repository identity. Use a native Joomla rule where it provides the required behaviour; otherwise provide the custom rule's complete PHP under a deliberate unique natural key. Its `inherit` selector is an authoring aid that fetches existing rule code into the PHP editor, not a portable GUID dependency or proof of runtime class inheritance. Inspect and save the resulting PHP; do not rely on another installation having the same local numeric selector ID. See the [editor implementation](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/media/js/admin/validation_rule.js).

The compiler extracts the `validate` name, normalizes it, checks the target's core rule list, then looks up custom PHP by name. A core rule is not a missing package record. Conversely, a missing custom rule can reach a source path that removes its custom link without a completed diagnostic; explicitly verify the generated class and actual validation rather than relying on compiler silence. [Field/Rule::set](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Rule.php), [Joomla6 core rule source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/JoomlaSix/CoreRule.php).

### Enforce length on the server as well as the form

An XML `maxlength` limits ordinary browser input; it does not by itself establish server-side length validation. Use a compatible core rule or a JCB Validation Rule, and inspect the generated form's `validate` attribute and rule class. The current core Text metadata lacks `validate_regex`, and [Field/Attributes::extraAttributes](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php) does not pass arbitrary additional attributes through. Adding an unrecognized XML property is therefore not a reliable workaround.

For a title-length rule of 1–120 Unicode code points, a distinct JCB rule can reuse Joomla's inherited regex implementation. Save these **class members only** in the rule's PHP field, then reference that rule's actual unique natural name from the concrete Field:

```php
protected $regex = '\\A.{1,120}\\z';
protected $modifiers = 'u';
```

The inspected [Joomla FormRule](https://github.com/joomla/joomla-cms/blob/ed920e9103e8354f221968f5ffdf27221bc28191/libraries/src/Form/FormRule.php) owns those protected, untyped members and tests the expression. This is a source-derived pattern, not a universal Field Type override: keep the shared Text definition unchanged, preserve the Field's `required`/filter/storage choices, and inspect the generated target class. Test empty, accepted-boundary and oversized submissions against the installed server; a browser that prevents typing the invalid value does not prove the server rejected it. See the [execution ledger](../../testing/scenarios/verification.md) for the stages actually exercised.

## Author, integrate and debug

1. Research the real Joomla Field and choose/reuse the external catalogue identity. Declare the required runtime version and assets/context.
2. Allocate/preserve the Field identity and write concrete XML plus explicit storage/model settings. Check XML syntax and source references; optional code needs its enabling settings.
3. Attach the Field to the actual owning view/configuration and resolve every nested Field/rule/code dependency. Inspect the package reference for serialization, not the form's hidden/UI values.
4. Import/reopen the Field and owner. Verify actual XML/storage values, catalogue resolution and existing consumer overrides.
5. Compile and inspect form XML, custom classes/rules, model get/save logic and install/upgrade SQL. Install and test rendering, accessibility, invalid/valid input, save/reopen and raw stored values.
6. For a change to an existing Field, test an unchanged existing consumer as well as a new one. Record and execute a migration when datatype, transform, default, key or cardinality changes; refreshing a Field record does not migrate installed data.

For a wrong control inspect the actual `type`, catalogue properties and generated class registration. For a missing attribute inspect the current Field Type property list and compiler extra-attribute path. For dropped/invalid values inspect XML filter/validation, attachment database inclusion, null/default and the model transform before changing the catalogue. For a relationship mismatch inspect application keys and routes separately from the package GUID graph.
