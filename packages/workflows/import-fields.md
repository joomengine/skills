# Derive importer fields from JCB Table metadata

Use this shared pattern for [immediate](immediate-import.md) and [queued](staged-import.md) application-table importers. **Project policy:** reuse JCB's Table-driven field discovery and import services; do not maintain a parallel list of every table column, label and type in an application `targets()` array. A single handwritten list shared by two screens still duplicates the schema JCB already maintains.

**Source evidence:** inspected 17 November 2026, core JCB `dev@037752c7e6599aa4cec900138dfb61af7ee4ba8f` and Packages `master@4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9`. The links below pin those inspected implementations. They establish the source path, not a newly passed Playground adaptation. Follow the [latest-version policy](../../standards/version-policy.md) for builds.

## Understand the native chain

1. **Component Table metadata.** The [Table interface](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Interfaces/TableInterface.php) exposes `fields`, `get` and `exist`. [BaseTable::fields](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/BaseTable.php) returns field names or full metadata; `fields($table, false, true)` requests details without adding standard default fields. This is the component's metadata registry, not Joomla's MVC Table class and not a query for stored rows. Author schema changes in JCB and compile/install the updated consumer; arbitrary database alterations do not update its compiled metadata.
2. **Target discovery.** The native Custom Code [getItemImportFields](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/custom_code/getItemImportFields/item.json) delegates to `getImportFields($parent, $tables, $simple)`. That helper enumerates configured tables using the Table service and derives `table.field` targets, translated labels, database type and link information. It applies GUID/exclusion/link policies rather than manually enumerating every column.
3. **Mapping and example.** The same Custom Code supplies `getItemImportSubformValues()` and matching helpers; Demo's [Example controller code](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/custom_admin_view/917d2c1a-1b37-4ded-9ace-ef486fcc3e4d/item.json) is located through the [staged reference](staged-import.md). Reuse the discovered targets for mapping and the helper's simple labels for `Spreadsheet.Exporter`. Keep example labels and mapping matching behavior aligned and verify the downloaded file through the actual importer.
4. **Mapper consumes, rather than discovers, UI targets.** [Mapper::set/getTableField](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Import/Mapper.php) parses submitted `column`/`target` rows, checks `Table->exist()`, retrieves `Table->get()` metadata and separates parent and joined-table mappings. [Service Import::getMapper](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Service/Import.php) injects that Table service. Existence checks do not independently enforce the application's allowed-field/permission policy.
5. **Row processing.** The configured Entity and native row services use these mappings. [Import Item](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Import/Item.php) interprets mapped values and link metadata. Reuse that composition and its actual provider dependencies; a field-selection helper alone is not a complete importer.

## Reuse and configure the helper

Acquire `getItemImportFields` and its dependency graph through [entity reuse](../../standards/entity-reuse.md), keeping its Custom Code natural-key identity and [argument contract](custom-code.md). Inspect the maintained `item.json` code and its actual callers before adapting it. The specimen has two argument placeholders: `arg0` initializes the parent and participating table configuration; `arg1` extends the exclusion condition. Supply both arguments at every invocation and preserve their receiving PHP syntax. Do not paste an unresolved `[[[arg0]]]` into generated output.

Its central metadata lookup is:

```php
$items = Super___ff8d5fdb_2d1f_4178_bd18_a43b8efd1068___Power::_('Table')
	->fields($table, false, true) ?? [];
```

This is the reference helper's Factory dependency, not a universal namespace to copy into every component. Follow the [native Factory/provider composition](translation-import.md#reuse-the-actual-power-roots), retain compiler-aware Power dependencies, and verify that the resulting `Table` service contains **the application's** tables. Do not accidentally enumerate JCB's own tables in an unrelated component or replace the dependency with an undeclared namespace copied from generated PHP.

Configure the parent table and participating related tables, their GUID exposure and the applicable exclusion/link policy. Preserve one discovery path for the mapping form and example exporter. The specimen caches `ItemImportFields`; inspect the cache's lifetime when adapting it for multiple contexts or simple/detailed calls in one request, and do not let a result for one context stand in for another. Keep adjustments in maintained JCB Custom Code/Powers and recompile.

The [translation importer](translation-import.md) is a specialized source/language-subform example: its headers depend on published language records and its Mapper targets include the two-value subform format. Retain its immediate upload/Apply architecture where appropriate, but use this Table-derived helper for ordinary application columns instead of inventing a static schema list from the translation example.

## Keep policy separate from schema duplication

Explicit application policy is necessary: participating tables, allowed/excluded fields, required import values, match keys, relationships and any aliases or transformations. An alias such as `surname` can supplement a discovered field; it must not become a second authority for whether that field exists. “Dynamic” does not mean exposing all writable fields to every actor. Apply authorization and supported-target policy on the server as well as in the UI.

Derive names, labels, types and available fields from JCB's metadata. Reuse its link information and existing import services, configuring only the actual application rules. Do not replace those services with a separate discovery/persistence framework. Use the [source-quality and added-field acceptance test](import-acceptance.md#review-source-quality-and-field-discovery) to prove a schema change flows into the generated importer without editing a duplicate field catalogue.
