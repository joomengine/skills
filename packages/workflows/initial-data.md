# Ship initial data through JCB

Use this workflow when a newly installed component must already contain reference or demonstration records. **For Playground installer delivery, use the Admin View's native Table source by default.** Populate the component, configure its Admin Views and let JCB generate the SQL during compilation. Do not hand-write INSERT statements or patch generated installers to reproduce this feature.

This is installation data, not a runtime spreadsheet importer, schema migration or a complete-site backup. See [import routing](imports.md), [component SQL/update paths](../models/component.md#schema-data-and-updates) and [delivery choices](../../workflows/delivery.md) for those separate tasks.

## Choose the source and deliverable

| Source | What JCB uses at compilation | Appropriate delivery |
| --- | --- | --- |
| **Table** (`source=1`) | Current rows from the selected database table, restricted to the saved source map and any effective SQL tweaks | A generated installer containing the selected initial data; the authoring database remains the source for the next build |
| **Dump** (`source=2`) | SQL already saved in that Admin View's SQL field | An editable blueprint that must carry embedded seed SQL without needing the original live source table |

Both require **Add MySQL install = Yes** (`add_sql=1`). Table mode does not require SQL authoring. Dump mode requires actual populated SQL, not merely selecting Dump. Changing the source selector is not an automatic Table-to-Dump conversion.

A Packages repository blueprint is not the compiled installer or the live application database. At the inspected source revision, Admin View package export excludes `addtables`, the local Table selection/source map; it does not convert that map or its live rows into stored Dump SQL. For an independently rebuildable blueprint with embedded data, deliberately maintain the required SQL in Dump mode and verify the exported/imported SQL. To continue Table-mode development, retain the complete workspace or restore the source data and configure the table map in the destination JCB instance. Inspect the destination after acquisition rather than assuming a successful Push carried everything.

## Table-mode procedure

1. **Build and install the empty component first.** Author Fields, Admin Views and their component links in JCB, compile and install the raw component with no bundled data. This creates the real application tables in the same Joomla database used by the authoring JCB instance.
2. **Populate the installed component.** Use its normal application forms or supported import flow to create the data to ship. Use intentional, distributable records, not customer data, credentials or temporary test clutter. Check relationships and save/reload behaviour before exporting them as initial data.
3. **Configure every relevant Admin View.** Open its **MySQL** tab, set **Add MySQL - (Install)** to **Yes**, and set **Select MySql Source** to **Table** rather than **Dump**. In the table subform select that view's installed application table, for example the actual city table for a City Admin View. Do not select JCB's authoring tables. Repeat this for each Admin View whose data must ship; configuring one view does not automatically include every related view's rows.
4. **Review the generated source map.** Selecting the table loads its columns into **Source Map**. Each mapping is a separate `source_column => destination_column` line, such as `id => id`. Keep the required fields and remove unnecessary mappings using the checklist below. Save, reopen and confirm the table and edited map survived. If the map is blank, verify the selected table and column-loading result rather than compiling an assumed mapping.
5. **Compile with the intended current data.** JCB reads the source table at compilation time and creates the INSERT data for the Admin View's generated component table. Later row changes are reflected by the next compile; an already downloaded ZIP does not change. Check effective component SQL tweaks: they can disable a view's added data or restrict selected IDs/ranges. Without a restriction, the configured source query includes its matching rows; publication status alone is not a privacy filter.
6. **Inspect and retain the actual installer.** Download the generated ZIP. Inspect its MySQL install SQL for the expected target tables, selected column lists, representative values and related records. No source rows, missing mappings, disabled data or an unsuccessful source query can mean no dump is produced. A successful compile notification alone is not proof that the data is present.
7. **Install into a fresh consumer and verify.** Use a separate compatible Joomla site where this component is not installed. Confirm installation creates the intended records and that administration and site views display/use them correctly. Preserve the populated authoring site; do not uninstall it to simulate a fresh consumer. Follow the [initial-data acceptance scenario](../../testing/scenarios/initial-data.md), then deliver the tested ZIP and requested workspace/source artifacts.

## Source-map checklist

Keep one simple application table per Admin View for the normal recipe. The compiler also supports joined source mappings, but adding unrelated tables to the subform is not a shortcut for independently seeding several Admin Views.

| Column category | Default review decision |
| --- | --- |
| `id` and application `guid` when present | Retain both. Preserve row identities and the IDs/GUIDs used by related records; an application GUID is not the JCB definition GUID. |
| Application values and relationship columns | Retain everything needed for meaningful records and valid relationships. Include the referenced records through their own Admin Views. |
| `access`, `ordering` and publication/state fields | Retain as needed for correct visibility, ordering and application behaviour. Verify access levels exist on the fresh target. |
| `asset_id` | Omit source-site asset IDs; they belong to that site's ACL asset tree. Verify the target's normal installation/save behaviour and permissions instead of copying foreign asset references. |
| `created_by`, `modified_by`, `checked_out`, `checked_out_time` | Normally omit source-user and edit-lock state. Check the target schema defaults and any application requirements. |
| `created`, `modified`, `version`, `hits` | Normally omit incidental timestamps, revision counters and hit counts unless they are part of the intended data. |
| Metadata/description fields | Optional: retain meaningful content the application needs, otherwise omit to keep the seed lean. |

Removing a map line removes that column from the generated INSERT, not from the schema or source table. The destination must be able to supply a valid default or other supported value for omitted columns. Do not omit a required custom field merely because it resembles an audit field. Also review values, not just names: no secrets or private records should enter a distributable installer. Referenced media/files must be delivered through JCB's [managed assets workflow](media-files.md); a database path alone does not include its file.

## Fresh install is not an update policy

This procedure targets a Joomla site where the component does not yet exist. Do not promise that installing another version over an existing component will replay installation data, merge it safely or refresh previously seeded rows. Existing-installation data changes require an explicit [update/migration design](../models/component.md#schema-data-and-updates) and separate upgrade testing. Keep the authoring data, installer version/hash and tested consumer result together in the delivery receipt.

## Evidence and limits

Source reviewed on 2026-11-16 against official JCB revision `037752c7e6599aa4cec900138dfb61af7ee4ba8f`. The procedure and checklist combine that implementation with the maintainer's intended Table-mode workflow. This page does not claim a new Playground compile/install test; the linked scenario is **not run** until a receipt establishes its result.

- [Admin View form](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/forms/admin_view.xml): MySQL options, Table/Dump source and table/source-map subform.
- [Admin View JavaScript](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/media/js/admin/admin_view.js): source-dependent controls and table-column loading.
- [SQL model](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Sql.php) and [SQL dump generator](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Sqldump.php): source selection, mapped live-row queries, generated INSERTs and empty/failure paths.
- [SQL tweaks](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Sqltweaking.php): per-view enablement and ID selection.
- [Admin View package configuration](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/AdminView/Remote/Config.php): excluded local table mapping. Verify the exported payload, not just the UI state, when claiming blueprint portability.
