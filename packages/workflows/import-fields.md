# Derive importer fields from JCB Table metadata

Use this shared pattern for [immediate](immediate-import.md) and [queued](staged-import.md) application-table importers. **Project policy:** reuse JCB's Table-driven field discovery and import services; do not maintain a parallel list of every table column, label and type in an application `targets()` array. A single handwritten list shared by two screens still duplicates the schema JCB already maintains.

**Source evidence:** inspected 17 November 2026, core JCB `dev@037752c7e6599aa4cec900138dfb61af7ee4ba8f` and Packages `master@4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9`. The links below pin those inspected implementations. They establish the source path, not a newly passed Playground adaptation. Follow the [latest-version policy](../../standards/version-policy.md) for builds.

## Understand the native chain

1. **Component Table metadata.** The [Table interface](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Interfaces/TableInterface.php) exposes `fields`, `get` and `exist`. [BaseTable::fields](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/BaseTable.php) returns field names or full metadata; `fields($table, false, true)` requests details without adding standard default fields. This is the component's metadata registry, not Joomla's MVC Table class and not a query for stored rows. Author schema changes in JCB and compile/install the updated consumer; arbitrary database alterations do not update its compiled metadata.
2. **Target discovery.** The native Custom Code [getItemImportFields](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/custom_code/getItemImportFields/item.json) delegates to `getImportFields($parent, $tables, $simple)`. That helper enumerates configured tables using the Table service and derives `table.field` targets, translated labels, database type and link information. It applies GUID/exclusion/link policies rather than manually enumerating every column.
3. **Mapping and example.** The same Custom Code supplies `getItemImportSubformValues()` and matching helpers; Demo's [Example controller code](https://github.com/joomengine/packages/blob/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9/src/custom_admin_view/917d2c1a-1b37-4ded-9ace-ef486fcc3e4d/item.json) is located through the [staged reference](staged-import.md). Reuse the discovered targets for mapping and the helper's simple labels for `Spreadsheet.Exporter`. Keep example labels and mapping matching behavior aligned and verify the downloaded file through the actual importer.
4. **Mapper consumes, rather than discovers, UI targets.** [Mapper::set/getTableField](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Import/Mapper.php) parses submitted `column`/`target` rows, checks `Table->exist()`, retrieves `Table->get()` metadata and separates parent and joined-table mappings. [Service Import::getMapper](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Service/Import.php) injects that Table service. Existence checks do not independently enforce the application's allowed-field/permission policy.
5. **Row processing.** The configured Entity and native row services use these mappings. [Import Item](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Import/Item.php) interprets mapped values and link metadata. Reuse that composition and its actual provider dependencies; a field-selection helper alone is not a complete importer.

## Include the component Table Power

The metadata above is supplied by the reusable **VDM.Table** Super Power, GUID `bfd1d6d5-56c1-4fe9-9fee-1c5910e1f5d8`, not a table catalogue the agent must write. Its authoritative [settings.json](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/bfd1d6d5-56c1-4fe9-9fee-1c5910e1f5d8/settings.json) and [code.power](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/bfd1d6d5-56c1-4fe9-9fee-1c5910e1f5d8/code.power) were inspected at shared Powers revision `9cd980492bed4c8177a6e32b703641950ec93604` on 17 November 2026.

1. Acquire this Power through the [Super Powers workflow](../../super-powers/SKILL.md), preserving its identity and native dependency closure. It extends [VDM.Abstraction.BaseTable](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/e0f6ddbe-2a35-4537-942c-faff2ebd04f6/settings.json), GUID `e0f6ddbe-2a35-4537-942c-faff2ebd04f6`, and implements [VDM.Interfaces.TableInterface](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/2da6d6c4-eb29-4d69-8bc2-36d96e916adf/settings.json), GUID `2da6d6c4-eb29-4d69-8bc2-36d96e916adf`. Use supported dependency selections/SPKs and the existing provider composition; do not paste expanded upstream classes into the component.
2. Keep the Power's component-aware namespace `[[[NamespacePrefix]]]\Joomla\[[[ComponentNamespace]]].Table`. JCB resolves those placeholders for the component being compiled. In the Power namespace syntax, the final `.Table` identifies the class; it is not a literal dot to paste into a PHP namespace. Do not hard-code `VDM\Joomla\Componentbuilder\Table` for an unrelated component.
3. Keep its maintained property initializer intact:

   ```php
   protected array $tables = ###ALL_COMPONENT_FIELDS###;
   ```

   During compilation, [Component Finalise](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/Component/Finalise.php#L207-L210) sets `ALL_COMPONENT_FIELDS` from `$this->componentfields->varExport(null, 1)`. The placeholder is replaced with the compiled component field metadata. Author or change the fields in JCB and compile again; do not replace this placeholder with a hand-maintained array.
4. Retain the native service provider that exposes the generated class as `Table` to the chosen Factory/container. The [core Table provider](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Service/Table.php) illustrates that binding and the associated Schema/Validator services. Resolve its actual Power dependencies through the workflow rather than inventing a class alias. Inspect the generated consumer's resolved Table class and confirm it describes the application's own attached Admin Views/fields.

A **compiler-generated `$tables` array is correct**: it is the runtime representation of the maintained JCB definitions. The problematic duplication is an independently maintained `targets()`/schema array that must be edited whenever those definitions change. Do not mistake generated output for that anti-pattern or manually edit the compiled Table class.

This Power is useful beyond importing. Its metadata APIs support field discovery, labels, title-field lookup, storage metadata and relationship inspection; the native Table Schema/Validator services use the same definition. Reuse those capabilities for a concrete consumer need rather than creating another schema registry. The Power describes structure; fetching stored data rows remains the responsibility of the relevant Data/Model services.

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
