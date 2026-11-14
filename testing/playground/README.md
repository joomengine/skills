# Build and deliver Joomla extensions in Playground

[JoomEngine Playground](https://playground.joomengine.org/) runs Joomla, JCB, PHP and MariaDB in the browser. Use this canonical agent guide to take an application request through maintainable JCB source to a complete, stable, runnable Joomla extension ready for deployment on the agreed target. Author, compile, install and exercise the requested features, then deliver the extension installers and requested portable site. No local JCB server deployment is required. The Playground footer links here; maintain the agent workflow in this Skills repository.

**Project policy:** when implementation work calls for JCB integration testing, use an available suitable Playground/browser environment within the user's authorization. Continue ordinary test setup and reversible test changes without adding an approval pause. Respect an explicit opt-out, a different requested environment, and the browser/tool's actual capabilities. If the environment is unavailable, unsupported or blocked, retain the evidence, continue independent checks, and report the exact unexecuted stage. Never turn a blocked test into a pass or require an account, paid AI provider or public publication merely to run this procedure.

Select the latest compatible production releases for production work, or the latest applicable development releases for development/testing, using the [version policy](../../standards/version-policy.md). Check the actual installed versions and current controls. The [source ledger](sources.md) records implementation revisions, including the int64 PHP distribution, dynamic Joomla/JCB catalogue and current network/MCP transport; the [verification record](verification.md) retains execution history separately. Source citations and past receipts do not pin a new build to those versions.

**Playground lifecycle version scope:** automatic persistence, recipe Save, Backups and Stop/Start below describe merged PR #24 (`c403f035`). The live manifest still reported the older `c49d025` during the 2026-11-14 review. Check the deployed `sourceCommit` and visible controls; do not apply new controls blindly to an older owner session or reload the only live copy merely to update it. [Source evidence](sources.md#workspace-lifecycle-refresh-2026-11-14).

For monitored core mirrors and access recovery, use [repository network discovery and JCB setup](../../standards/repository-network.md#configure-jcb-and-playground). Preserve the actual candidate branch and keep read transport separate from authorized Push destinations.

## Reading path

| Task | Read next |
| --- | --- |
| Build an application from a prompt | [Request-to-extension workflow](../../workflows/request-to-extension.md) |
| Understand JCB's architecture and source models | [Architecture references](../../architecture/README.md) and [model router](../../packages/models/README.md) |
| Choose production or development releases | [Latest-version policy](../../standards/version-policy.md) |
| Select versions, create a link, reopen or export a test site | [Configuration and lifecycle](configuration.md) |
| Recover failed browser persistence without losing JCB work | [Storage recovery](storage-recovery.md) |
| Super Power acceptance | [Import, compile and runtime workflow](../../super-powers/workflows/validate-and-integrate.md) |
| Field Type acceptance | [New/existing Field, compilation and runtime workflow](../../field-types/workflows/validate-and-integrate.md) |
| Snippet acceptance | [Acquisition, copied consumer and runtime workflow](../../snippets/workflows/integrate.md) |
| Package blueprint acceptance | [Graph acquisition, component/module/plugin compile and runtime](../../packages/workflows/validate-and-integrate.md) |
| Build in the GUI and export source | [Package authoring, write destinations and Push/read-back](../../packages/workflows/author-in-playground.md) |
| Use a user-hosted MCP or assess Playground MCP | [Connection, discovered capabilities and browser limits](../../workflows/mcp.md) |
| Deliver ZIPs, source repositories or the whole site | [Delivery and restore verification](../../workflows/delivery.md) |
| Understand what has actually run | [Verification record](verification.md) |
| Report guidance that prevents the required outcome | [Skills feedback and issue reporting](../reporting-issues.md) |

## Build from a request

1. Follow the [request-to-extension workflow](../../workflows/request-to-extension.md) to establish entities, operations, permissions, integrations and acceptance cases. Reuse the user's supplied answers and environment. Use an existing capable Joomla/JCB MCP connection when provided; otherwise open [JCB setup](https://playground.joomengine.org/?deploy=jcb&start=0) and work in the administrator GUI.
2. Pull complete reusable features from the [reference blueprints](../../examples/reference-patterns.md), including the Fields, views, queries, Templates, Layouts and Powers that make them work. Keep application-row GUIDs separate from definition GUIDs and business keys, retain numeric Joomla primary keys, and create a real Admin View for each separately stored child entity. Use [application identities](../../packages/workflows/application-identities.md), [normalized subforms](../../packages/workflows/normalized-subforms.md), [Dynamic Get](../../packages/workflows/dynamic-get.md) and [managed files/images](../../packages/workflows/media-files.md) for the affected features.
3. Build one complete source-to-runtime slice, then finish the remaining requested features. Save and reopen definitions, compile, inspect the genuine installer, install it and exercise its behaviour. Carry lasting corrections back to JCB records, Power source or maintained assets and rebuild.
4. Follow [delivery](../../workflows/delivery.md) to provide the runtime installers and requested **Complete site** archive. Upload that exact archive as an independent site and verify the JCB graph, application relationships, save/reload behaviour and representative compilation. Keep runtime dependencies and build-only prerequisites explicit.
5. If missing, incorrect or unclear skills prevent the agreed outcome, create or contribute to a matching [Skills issue](https://github.com/joomengine/skills/issues) with the reproduction and improvement needed. Follow the [feedback procedure](../reporting-issues.md), continue useful implementation work, and use the resulting issue to improve the shared instructions.

## Operate the browser

The outer page is Rocket; Joomla runs in its preview. Use Rocket to configure sites, save/download work and open **JoomEngine Code** or **DB**. Use the Joomla administrator to install extensions and edit JCB records. **Site** and **Admin** navigate the running preview; **Credentials** shows this site's login details.

Wait for provisioning, navigation and dialogs to finish, then inspect the resulting controls before acting. Open the preview or its iframe through the browser tool's supported interface. Use current labels and fields, scrolling or keyboard focus where necessary; layouts can vary by version. Keep the owner tab open. Use supported file upload/download controls to transfer packages and verify each transfer.

The optional **JCB + MCP** deployment supplies same-browser authenticated HTTP. Discover the actions needed for the task and use the GUI for unavailable operations. A private browser site is not exposed to an external client merely by sharing the static Playground URL; follow the [MCP execution route](../../workflows/mcp.md#use-mcp-with-playground).

## Common workflow

### 1. Prepare authoritative source and a testable revision

Read the entity's specification and run its applicable static checks first. Record the source repository, branch, commit, affected identities, dependencies and intended Joomla/PHP targets. Apply the module's identity rules, including fresh catalogue collision checks for genuinely new items. Fixture-only identifiers remain fixture-only.

| Change | Authoritative input to fix |
| --- | --- |
| Super Power | Repository `settings.json` and `code.power`, plus consistent index/derived representations |
| Field Type | Repository `item.json` and index; actual Field choices remain separate JCB authoring data |
| Snippet | Repository item/index/type references; copied consumer markup is maintained separately |
| Package blueprint | Per-model repository payloads/indexes, parent-owned records and assets; see the exact [package contract](../../packages/specification.md) |
| Compiled extension | Its JCB authoring source and dependencies; generated PHP/XML is evidence of the result |

Use the task's staging branch or fork to expose the candidate to JCB. Commit a coherent source/index change and record its SHA. Push that branch when repository publication is already authorized by the task. If publication is outside the authorization, use an approved accessible staging source or report acquisition as blocked; do not silently publish the work. A local checkout invisible to the browser cannot be tested by configuring its filesystem path as a Git repository.

Do not merge or change the production/default branch to make testing convenient. A branch name is a moving pointer: record the tested commit and recheck it after subsequent pushes. If the candidate is already published at the authorized PR branch, use that branch rather than creating an unnecessary second copy.

### 2. Start a separate test site and record its actual environment

Choose a [version-specific link](configuration.md#ready-to-use-test-links), inspect setup and Launch. Use a temporary site for a short test or a uniquely named saved site for work spanning reloads. Keep the owning Playground tab open. Wait for successful provisioning and the actual JCB administrator screen; a loaded outer page is not a successful Joomla launch.

Record the live build's source revision when obtainable from its public `assets/manifest.json`, resolved Joomla/PHP versions, installed JCB version, recipe, browser and candidate revision. The deployment manifest records package provenance; a saved site may still contain an older JCB installation. Use the running site's version information as well. Preserve non-secret setup/progress diagnostics if launch fails. Do not use a guessed `window.playground` global: the shipped UI keeps its runtime handle private to its module. [P01–P04, P07](sources.md)

### 3. Configure the candidate's real JCB repository connection

Open the test JCB instance's Repositories area. Inspect existing records before adding or changing one: a core repository can be present but disabled, configured for another target, or still pointing at another branch. Do not enable every repository. Enable/configure only the intended candidate and needed dependencies, preserving the known test baseline.

Record these values for every effective source:

| Setting | Required check |
| --- | --- |
| Content target | Super Power (`1`), Joomla Power (`2`), Field Types (`3`), Packages (`4`), Snippets (`5`), or the separate Repositories catalogue (`6`) as appropriate; a package's concrete Fields differ from Field Type catalogue records |
| Provider/type | GitHub or Gitea matching the actual host; these are independent of the content target |
| Host, organization and repository | Exact source; the inspected GitHub provider normalizes its API base to `https://api.github.com`; Gitea uses the configured base |
| Read branch | Candidate branch containing the tested commit, explicitly set; a write branch does not select import source |
| Published/enabled state | Confirm the record participates in this instance's lookup; mere existence is insufficient |
| Effective order | Candidate and dependency precedence, including every intentional same-GUID override and shadowed source |
| Access | Working public access or appropriately scoped configured credentials; never include tokens in source, URLs, screenshots or receipts |

The inspected JCB helper selects target-matching rows with `published >= 1` and reads `ordering DESC`; each entity config then prepends entries. For distinct repository keys, the resulting configured order puts smaller numbers first. The predicate also includes archived state `2`: do not infer exclusion from its label. Duplicate owner/repository keys collapse and do not include the host; tied order or ambiguous duplicate connections require inspection, not assumptions. Explicit selection can constrain lookup to one repository. Confirm the source actually selected for the item. [J01–J03](sources.md)

Each entity config starts with its configured initialization fallback paths before prepending eligible database rows. Disabling a repository row therefore does not necessarily remove an equivalent fallback source. Inspect the effective source list and selected provenance rather than treating the database row's disabled state as proof of exclusion. [J03](sources.md)

For new Field Type/Snippet identities, the mandatory current official catalogue comparison remains part of source validation even if its connection is disabled in a particular test site. Runtime dependency availability and global catalogue collision checks are different obligations. Follow the corresponding module's registry and dependency rules.

### 4. Acquire or refresh deliberately

Use the entity list's supported authenticated toolbar/selection flow with its normal permissions and request tokens. The inspected controllers use `initPowers`, `pullPowers` and `resetPowers` under `powers`, `fieldtypes` or `snippets`; verify the installed version's actual UI before acting. [J04–J05](sources.md)

| Operation | Meaning and verification |
| --- | --- |
| **Init** | Discover/select remote definitions to acquire. Ordinary initialization preserves an already-local GUID; an “already local” result does not prove the candidate was imported. |
| **Pull** | Can initialize missing selected items and replace existing definitions from the selected source. Inspect the offered changes, complete selection, then inspect the resulting records and dependencies. |
| **Reset** in a JCB entity list | Refreshes selected local definitions from remote lookup. Preserve intentional local edits first; verify the expected GUID and source before overwriting. Dependency traversal differs by entity. |
| **Reset** in Playground | Deletes the selected test site's saved files/database. It is unrelated to refreshing an entity. |
| **Push** in JCB | Exports to eligible configured write destinations, potentially more than one. Audit effective destinations using [publication preflight](../../packages/workflows/publication-preflight.md); the selected read source does not restrict Push. |

Import only the required items. Capture meaningful success/local/not-found/error results. Inspect the saved local record's GUID, changed content and dependencies; a toast, record count or HTTP 200 is insufficient. For an update, check a distinctive intended difference. If a cached index or wrong branch hides a change, verify remote commit, indexed paths and selection first, then use the target version's supported reload/refresh path. Do not bypass an import failure by writing directly to JCB's database and call that a successful repository import.

Package authoring may start in this GUI: create and connect the actual component/module/plugin records, compile/test them, then export their portable source through Push. Follow the [package authoring workflow](../../packages/workflows/author-in-playground.md) before supplying credentials or writing. Audit all eligible package write destinations; the inspected generic exporter can write beyond one apparently selected repository. Verify the remote payload/index/asset diff and acquire it into another test instance. A compiler ZIP download is not this repository export.

### 5. Exercise the actual authoring consumer

For a new component, create concrete **Fields** with the required Field Types and storage settings, create an **Admin View**, attach the Fields in its association editor, and attach that view to the **Joomla Component** through its component association editor. Add the required site views, permissions, code, assets and dependencies. Use the [model router](../../packages/models/README.md) for each record's contract and verify the saved associations.

Follow the linked module workflow. A referenced Super Power, an attached concrete Field, or source copied into an actual Snippet consumer must participate in the build. An imported but unused catalogue item proves only acquisition. Preserve and compare existing consumers when the change affects existing identities.

Save/reopen the JCB authoring record and verify that the change persists. Record the test component/view/Field or calling code and relevant configuration. Do not assume that a refreshed catalogue automatically migrates existing Fields, copied snippets or already-installed extensions.

### 6. Compile, inspect, install and run

Compile the selected test component for the intended Joomla target through JCB. Check compilation messages and download the resulting package. Inspect actual generated PHP/XML/templates, dependencies, autoloading/assets and relevant SQL using the module's acceptance criteria. Record the package hash and generated paths where available; successful ZIP creation alone does not prove the changed feature is included.

Use the compiler's **Download Component** result to retain the ZIP outside the browser runtime, then list/extract it into a separate scratch directory for inspection with available ZIP/PHP/XML tools. Keep the original package and its hash alongside the receipt. Upstream's compiler test finds its generated ZIP under `/persist/www/tmp/`, but take the current result/download location as authoritative rather than guessing a filename. Code can inspect files that actually exist in the active site; it does not automatically expand a ZIP into an installed component. After installation, inspect the real installed paths and compare the relevant files with the compiled package. If the available browser cannot download/upload or expose artifact bytes, record that inspection/install stage as blocked instead of inferring package contents from a success page. [P08, P12](sources.md)

If the embedded compiler link does not yield a download, use JoomEngine Code's **Download file** dialog with the actual compiled ZIP path, then verify the received file and checksum. This fallback retained the [Notes test package](../scenarios/notes-admin-verification.md). Download before an installation action that removes the temporary ZIP; the separate [Power test](power-placement-verification.md) completed installation/runtime but did not retain that package. A timed-out file chooser or absent download is not a completed transfer.

Install/update that package through Joomla's supported extension flow in the disposable test site, or in a separate compatible [Joomla-only site](configuration.md#deployment-presets) when a clean runtime consumer is needed. Capture the installer result and open the actual runtime page/caller. Execute the module's success, failure and boundary cases. An isolated browser instance is not a remotely reachable deployment; moving a compiled package to another instance requires its supported download/upload or package-URL flow.

A compiler/runtime failure needs diagnosis against the actual source revision. If using Code to inspect or temporarily instrument generated/installed files, preserve a diff and label it diagnostic. Apply the durable correction to authoritative source, refresh the intended record, recompile and reinstall, then repeat the affected check. A passing test after patching only generated PHP does not validate the repository change.

### 7. Save evidence and report the stages separately

Record source and runtime revisions, repository settings/effective order, changed identities, exact actions, expected/observed results, artifact hashes/paths, and remaining limits. Separate static, discovery, import/refresh, compile, installation and runtime outcomes. Mark skipped or blocked stages explicitly, including the opt-out or concrete blocker. Use the [verification record](verification.md) as an example of bounded evidence, not a result to copy into another task.

Submit intended JCB forms and save intended editor buffers, then export the requested artifacts. In post-PR #24 builds the live site persists automatically; check the persistence indicator and retain an external full backup. Keep credentials and private recovery files out of public receipts. A Share link transfers public setup; use **Complete site** for the database and files. Preserve failures before reset or closing the owner tab; use [storage recovery](storage-recovery.md) when persistence fails. Report skill gaps through the [Skills feedback procedure](../reporting-issues.md); upstream JCB issue submission follows its separate human-led route.

## Save and deliver the finished work

Retain the JCB-generated installers and **Download → Complete site** when the client needs the editable workspace. A successful manual Playground Save is not a prerequisite for download: post-PR #24 **Save** stores a recipe, while live data persists automatically. **Upload** restores the full archive into the live workspace; preserve existing work before replacement. For isolated validation, use a clean browser storage context. Verify login, project definitions, application GUID relationships and a real save/reload after import. Follow the canonical [delivery and restoration procedure](../../workflows/delivery.md) for archive contents, hashes, compiler prerequisites, clean-consumer dependencies and conventional hosting through the archive's `DEPLOYMENT.md`.

Remove temporary repository write credentials before producing a distributable site and select delivery visibility appropriate to its account/application data. Keep the original site until restoration succeeds. The [lifecycle table](configuration.md#lifecycle-persistence-and-evidence) distinguishes editor saving, automatic live persistence, recipes, installers and complete-site archives.

## Inspect and diagnose with JoomEngine Code

To find where a GUI code field lands, follow the [compiler tracing recipe](../../packages/workflows/debug.md#trace-a-gui-code-field): add a distinctive comment, set **Add Custom Code Placeholders** and **Debug (line numbers)** to **Yes**, compile/install the extension and search for the comment in Code. A refreshed compiler page returns the overrides to **Global**, which inherits the component settings. When the effective tracing settings are off, the next compile/install removes generated markers automatically. Remove your own probe in the GUI source and rebuild; do not manually strip generated comments. Keep the resulting authoring code readable under the [source standard](../../standards/authored-code.md).

Open **JoomEngine Code** beside the running site. Its workspace is the active Joomla document root, `/persist/www`, so it can inspect generated/installed PHP, XML and templates. File **Save/Save All** writes the runtime filesystem; **Refresh site** reloads the preview separately. Later requests can use saved files even before refresh. In post-PR #24 builds, automatic persistence retains committed runtime changes; Playground **Save** saves the recipe, not the site snapshot. Unsaved editor drafts are neither saved runtime files nor portable exports. Preserve intended changes and resolve conflicts rather than overwriting a newer file. The editor is not a host terminal or a Git checkout of the source Power catalogue. [P08](sources.md)

Imported Powers, Field Types, Snippets and JCB authoring records are held in the site's database. Browsing or editing a PHP file in Code does not update those records. Use JCB's supported record editor/acquisition flow for them, then compile again. Likewise, updating a repository JSON/body file is not complete until the intended database record is refreshed. Keep repository source, JCB database state, compiled package and installed files distinct when tracing a mismatch.

Select **DB** beside Code to open Adminer against the same running MariaDB. Inspect actual saved values and generated table relationships when debugging. Submitted queries and edits affect the real site; switching or hiding the panel does not submit unfinished forms. Do not replace JCB model saves with direct SQL and then claim the normal authoring/import path passed. Use a clean checkpoint for diagnostic mutations and reproduce durable changes through the maintained model. Detached database/editor windows still need the owner tab; automatic persistence retains committed site state, and a complete download preserves an external copy. [Current database sources](sources.md#current-workflow-refresh-2026-11-03)

For a PHP failure, use **Debug and refresh** for the current GET, or **Arm PHP request** with the exact URL/query and method before the matching navigation/form submission. Set a breakpoint in an executed source location; inspect stack/variables and step/continue. Expression evaluation executes PHP and can have side effects. While paused, source writes and normal requests queue: continue/stop before waiting for them. Stopping a POST does not roll back completed writes or authorize replay; inspect state before retrying. [P09](sources.md)

The optional **AI Assistant** is separate from the external agent operating this workflow. It can read bounded context and propose file changes for review; it has no shell or PHP execution tool. It needs a user-configured provider accepting requests from its opaque origin, and live provider compatibility is not established merely by a preset or fixture test. Normal editing/debugging needs no AI key. Its changes still require the authoritative-source/rebuild procedure above. Do not put credentials in project files or ask for them when browser testing does not need the assistant. [P10](sources.md)

For an authorized automated harness, Playground exports `prepareEnvironment()` and `createPlayground()`; the returned handle offers `runtimeInfo`, `configuration`, `installation`, `request`, `runPhp`, filesystem operations, save and export. Upstream Playwright tests demonstrate this path. It requires a compatible browser context and an explicitly created handle, not a server-side PHP endpoint. Follow the active browser tool's rules; do not use a hidden handle or unsupported script evaluation to bypass them. [P07, P12](sources.md)

## Environment limits that change test conclusions

| Boundary | Consequence |
| --- | --- |
| WASM runtime and JCB package | Record browser/PHP/Joomla/JCB, actual integer size and package provenance. Current source uses int64 PHP; this does not certify every native server or an older saved site's runtime. |
| HTTP transport | Current PHP HTTP and application downloads share direct Fetch plus a configured Worker fallback for unreadable cross-origin responses. No user grant or destination registration is required. Actual HTTP errors are returned, and cancellation/incomplete bodies are not replayed. Inspect the deployed configuration and actual failure; do not assume an item-format or CORS defect. [P20](sources.md) |
| Same-site HTTP | Current source serves nested HTTP through disposable CGI workers with separate connections to the same database. This is a bounded callback path, not arbitrary parallel filesystem execution; cancellation can leave committed database changes. [P20](sources.md) |
| Optional `jcb-mcp` | Same-browser discovery and a nested API category read have an upstream test contract. Discover and verify each needed JCB action; native CLI jobs and external access to a private browser instance remain separate limitations. Follow the [MCP workflow and GUI fallback](../../workflows/mcp.md#use-mcp-with-playground). |
| Database/host facilities | Real MariaDB/PDO is available; remote database connections, `mysqli`, arbitrary sockets, host executables and a production mail server are not. |
| Browser storage and memory | Distinct resources: a browser storage rejection does not prove exhausted RAM or a JCB component-size limit. Preserve the owner and follow [storage recovery](storage-recovery.md). Browser storage may be cleared/evicted; PHP memory limits do not measure its quota. |
| Browser isolation | Requires HTTPS/localhost, service workers, Web Locks, IndexedDB, SharedArrayBuffer and cross-origin isolation. This release documents desktop Chromium/Firefox support; unsupported browsers are a recorded blocker. |
| Trusted development | Installed code can access this origin's test data. Site keys organize sites; they are not a hostile-code or multi-tenant security boundary. Use reviewed inputs and appropriate test data. |

The pinned [runtime, package, transport and MCP sources](sources.md) establish these limits. Keep native-environment checks for affected behaviour outside the browser's coverage, and describe exactly which environment passed.
