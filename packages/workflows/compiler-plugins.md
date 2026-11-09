# Maintain compiler plugins and repeatable builds

Use a compiler plugin for an intentionally scoped build transformation or assertion that the ordinary blueprint cannot express. First check supported JCB settings and maintained source. Keep the plugin definition, dependencies and source assets with the authoring graph; a patch to emitted PHP or a ZIP is not a compiler fix.

Identify the exact unsupported compiler behaviour before adding a plugin. Inspect current JCB source, the relevant blueprint settings and [reference implementations](../../examples/reference-patterns.md); use a [temporary GUI trace](debug.md#trace-a-gui-code-field) when code placement is unclear. Ordinary application persistence, smart subforms, file uploads and site rendering belong in their existing authoring records and runtime dependencies. A compiler plugin is not their default repair mechanism. If one is needed, record why those supported mechanisms do not meet this particular build requirement and when the workaround can be removed.

**Source baseline:** JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`, inspected 9 November 2026. These are source observations and recommended validation steps, not a new installed-plugin test.

## Event contract

[JoomlaSix/Event::trigger()](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/JoomlaSix/Event.php) retrieves listeners and calls them with unpacked positional arguments. Native JCB compiler events are not automatically Joomla Event-object callbacks.

| Event | Arguments in order | Timing |
| --- | --- | --- |
| `jcb_ce_onGetFileContents` | `&$string, &$name, &$path, &$bom, &$view` | Immediately after reading the file; before BOM handling and placeholder expansion. |
| `jcb_ce_onBeforeWriteFileContent` | `&$answer, &$name, &$path, &$bom, &$view` | After placeholder/custom-code processing; before Super/Joomla Power token injection and the file write. |

The exact call sites are in [Extension/FileContent::set()](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Extension/FileContent.php). Keep mutable arguments by reference and match the chosen event; the five-argument contract does not apply to every compiler event.

Declare a native `public static function getSubscribedEvents(): array` map when explicitly controlling subscriptions. The inspected [JoomlaSix plugin compiler](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Architecture/JoomlaSix/Plugin/Extension.php) also infers public `jcb_ce_` methods if no map exists, preserving their positional contract. Its ordinary `on...` inference instead validates Joomla event signatures. Do not duplicate a generated subscriber method or wrap compiler arguments in an unrelated Event object.

## Author and activate

1. Record the component GUID, Joomla target, affected path and expected source shape. Design unrelated components/files as no-ops. Validate the expected input before changing it; reject unexpected drift instead of broad text replacement. Make repeated application idempotent.
2. Author the plugin using the installed extension-plugin group/base contract and [extension guide](../models/extensions.md). Follow the [authored-code standard](../../standards/authored-code.md): readable methods, tabs, established braces and comments explaining the transformation's preconditions. Keep imports, JPK/SPK references, dependency selections and the actual class body consistent. Add only the handlers needed for the change; put each transformation in a small named method rather than one compressed replacement block.
3. Compile the plugin, install/update its genuine ZIP on the **authoring** Joomla site and enable it. Select its plugin element in JCB's **compiler plugins** configuration without removing existing selections. `JoomlaSix/Event` imports enabled `extension` plugins from `compiler_plugin`; component Compile & Export attachment alone does not activate them.
4. Compile the application with the installed plugin active. Treat any component emitted while bootstrapping the plugin as preliminary. Inspect changed files, untouched targets, PHP syntax and SQL/asset presence.
5. Compile again from the same maintained state. Compare archive member names and bytes, including historical SQL. Different ZIP timestamps can change the ZIP hash while member contents remain equal. Same-site repeatability is distinct from rebuilding after fresh graph acquisition.
6. Install the final application on a clean consumer and exercise the affected runtime/update path. Deliver the compiler plugin separately as a build prerequisite unless the user explicitly needs it on the consumer. Keep it out of the ordinary runtime combined installer.

## Retain historical update SQL

A versioned source failure needs a durable source correction, not dependence on one compiler run's history. In the inspected source, [VersionUpdate::set()](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Extension/VersionUpdate.php) chooses key `guid` when no existing Component Updates ID exists but supplies `joomla_component`, not `guid`. [Data/Item::set()](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Data/Item.php) returns false for a missing key; this caller does not check that result. [JoomlaSix/History](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/JoomlaSix/History.php) advances history watches. Therefore verify persistence and the next build instead of assuming generated update SQL will recur.

Prefer a valid maintained Component Updates record where the installed contract supports it. If a necessary historical file cannot be retained that way, use the supported [Files Full Path processing route](../models/libraries-and-assets.md#retain-update-sql-and-close-runtime-dependencies), with one owner for the destination. Keep the actual historical filename and schema transition; extension version and SQL history names are different contracts. Do not modify Joomla schema history to force an update, invent a release URL, or maintain two conflicting copies.

The Clothing Store handover reports one such workaround using a processed SQL asset and a narrowly scoped plugin that validates eight statements. The original acceptance receipts remain reported evidence, distinct from the later authoring-site inspection in the [contribution review](../evidence/clothing-store/documentation-review.md). Its filename, statement count and `/** CAN FAIL **/` marker are **not** a universal recipe. Do not add an error-suppression marker to unknown SQL: a statement-error bypass requires exact preconditions, throwing post-install verification and a tested recovery path. A compiler plugin cannot validate an update file that was never generated, and does not make DDL transactional.

## Validation and recovery

Record plugin identity/version, selection/enabled state, event/signature, exact source and final artifacts. Exercise the intended target, an unrelated target, repeated execution, unexpected template drift and missing asset. If the transformation does not run, inspect activation and subscription before changing its logic. If it fails after a partial build, preserve the failed output, repair maintained inputs and regenerate. A clean-source rebuild additionally requires restoring all assets/dependencies and bootstrapping this plugin in a fresh JCB instance; report that separately from two same-site builds.

On a JCB upgrade, reevaluate the original gap against the current compiler. Retire a workaround when supported source handles the case, then rebuild and repeat the affected checks with the plugin removed from compiler selection. Keep the production default on the [latest JCB release](../../standards/version-policy.md), not the historical revision that first required the plugin.
