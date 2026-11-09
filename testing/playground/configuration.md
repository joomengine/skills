# Configure a reproducible Playground test

Use [the common workflow](README.md) to acquire and test a candidate. This configuration follows Playground `58b21b3`, inspected 2026-11-03; [current source evidence](sources.md#current-workflow-refresh-2026-11-03) identifies the implementation. Verify the published build and running installation before relying on a supported version or feature.

Playground's URL selects a runtime, deployment and initial Joomla route. It does **not** select a Power/Field Type/Snippet/Package Git read branch. Configure the repository target, provider, read branch, enabled state and precedence **inside JCB** using the [common acquisition workflow](README.md#3-configure-the-candidates-real-jcb-repository-connection).

## Available version baseline

Select the target through the live **Joomla**, **JCB** and **PHP** controls. Read the published `assets/version-catalog.json` and its `generatedAt` when available. The build stages discovered packages and hashes; opening a selector refreshes that published catalogue, not the upstream release servers. Do not hardcode a list of newest releases into a skill or assume a saved site was upgraded by a catalogue refresh.

The inspected source supports current stable, nightly and newest upcoming preview choices for Joomla 5–7 and JCB 5 onwards. Joomla 5 uses JCB 5; Joomla 6 uses JCB 6. Joomla 7 with JCB 6 is an **experimental forward-test pairing**, offered when the actual catalogue and recipe support it. A menu entry is not evidence that a candidate passed on that target. Confirm recipe requirements and effective installed versions after launch.

Source defaults still identify Joomla 6.2.0, PHP 8.4 and `jcb`; PHP minor selections include 8.3, 8.4 and 8.5. The current build obtains native 64-bit PHP integer runtimes from a resolved `php-wasm-int64` release. Record the effective PHP patch, `PHP_INT_SIZE`, build/package hashes and selected JCB release rather than copying the earlier 32-bit runtime's patch table. The current JCB build retains its original bundled spreadsheet dependencies. Historical 32-bit compatibility receipts do not describe this new build.

## Ready-to-use test links

Start with [JCB setup](https://playground.joomengine.org/?deploy=jcb&start=0), [JCB + MCP setup](https://playground.joomengine.org/?deploy=jcb-mcp&start=0), or [Joomla-only consumer setup](https://playground.joomengine.org/?deploy=blank&start=0). Inspect the current selectors, choose the requested supported target and launch. `start=0` suppresses the countdown so configuration can be reviewed.

For an independent installation, use **Configure deployment → Use this deployment** or [fresh JCB setup](https://playground.joomengine.org/?deploy=jcb&fresh=1&start=0). `fresh=1` also bypasses prepared images and runs the recipe. A normal visit can reopen the previous saved site. Name long-running work clearly and preserve it with Save plus a complete export.

To select the compiler as the first page, encode the entire **inner Joomla path including its query** as one `path` value:

[Open JCB setup at the compiler](https://playground.joomengine.org/?deploy=jcb&start=0&path=%2Fadministrator%2Findex.php%3Foption%3Dcom_componentbuilder%26view%3Dcompiler).

This decodes to `/administrator/index.php?option=com_componentbuilder&view=compiler`. An unescaped `&view=compiler` becomes an outer Playground parameter. The path must be local to Joomla; it is not the owner page's URL or its generated `__site/...` prefix. Selecting a screen does not import a candidate revision.

## Verified URL parameters

Boolean values support `1/0`, `true/false` and `yes/no`. Use the current deployment editor for richer configuration instead of inventing query names.

| Parameter | Behaviour and boundary |
| --- | --- |
| `deploy=jcb` | Select a known compatible deployment; `blank` chooses Joomla without a required JCB installation. |
| `joomla` | Select an actual available release or supported minor prefix. Preserve exact selected package identity/hash for reproducibility. |
| `jcb` | Select a compatible published JCB version, or `none` where the recipe allows it. |
| `php=8.4` | Select an available compatible PHP minor; this is not a promise of an arbitrary PHP patch. |
| `path` / `initialPath` | Initial local Joomla route; `path` wins. Maximum 2048 characters. |
| `name` | Site name, at most 100 characters. |
| `language` | Joomla language; a non-English choice needs a supported language package. |
| `uiLanguage` | Rocket's interface language, independent of Joomla content language. |
| `login=no` | Disable automatic administrator login; use Credentials for this site's actual login. |
| `persist=0` | Start a temporary site. Save explicitly if it must be retained. |
| `key` | Select a browser-local saved-site identity; reusing it can reopen existing data. It is not a shared site URL or an access secret. |
| `fresh=1` | Allocate an independent site and run the recipe instead of a prepared image; does not delete other saved sites. |
| `toolbar=0` / `hideToolbar=1` | Hide header/footer with edge restore controls. Explicit `hideToolbar` takes precedence. |
| `start=0` | Show configuration without automatic launch. |
| `extensions` | Encoded JSON array of `{ "url": "..." }` package objects; use the editor's repeatable URL rows for ordinary setup. User-supplied package checksum fields are ignored. |
| `extension` | Repeatable package URL parameter, added to the extension list. |
| `commands` / `startupCommands` | Encoded arrays of Joomla CLI argument arrays, for example `[["cache:clean"]]`. `commands` wins. These are not host shell commands. |
| `config` and optional `sha256` | Public deployment-document URL and optional document digest. This digest does not cover every custom package. |
| `#deploy=...` | Share-generated deployment configuration. Prefer the UI's encoding and keep credentials out of links. |

Custom extension/template URLs support HTTP and HTTPS without embedded credentials or fragments. They are installed through Joomla's `extension:install --url=URL`. Current source routes PHP HTTP through the shared transport with its configured Worker fallback when browser Fetch cannot expose a remote response; this supersedes the earlier direct-Fetch-only restriction. A custom-package failure stays visible while Joomla opens so it can be retried. Required managed deployment packages must install successfully, and their staged package hashes are verified. Do not apply the old direct-fetch checksum behaviour to the current custom-URL path. Inspect actual installer errors, especially for slow database-heavy packages. Installation has its own bounded execution budget; changing ordinary page timeouts alone does not prove the installer limit changed. See the [2026-11-09 network evidence](sources.md#current-network-and-mcp-refresh-2026-11-09).

Startup commands execute after installation and are not replayed merely by reopening a completed saved site. Review commands/packages before **Apply to this site**; removing an item from a recipe does not uninstall it. Failed apply offers checkpoint recovery as a separate site.

## Deployment presets

**Save** in the deployment editor saves a recipe, with changes to built-ins becoming a Custom copy. **Save as copy** creates another recipe; deleting a custom recipe does not delete installed sites. **Use** starts an independent installation. **Apply to this site** checkpoints and applies supported changes to the running site. Joomla/deployment selection does not perform an in-place Joomla upgrade of an existing site.

The version 2 **Export configuration** document includes administrator details and deployment settings. **Import configuration** restores that recipe, not its site's files/database. **Share** produces password-free version 1 public setup for an independent installation. The inspected limits are 1 MiB per configuration document and 16 KiB per Share link.

Prepared images are used only for compatible selected package identities; other catalogue choices install their staged packages. Source recipes include `jcb`, `jcb-mcp`, `blank`, Service Directory and other demonstrations. Their current requirements and selected release determine eligibility; do not treat a static recipe listing as a full version matrix. The optional MCP deployment is subject to the [MCP capability gate](../../workflows/mcp.md#use-mcp-with-playground).

## Lifecycle, persistence and evidence

| Action | Effect |
| --- | --- |
| Editor Save / Save All | Write active virtual files; preview refresh and persistent site Save are separate. |
| Database viewer submit | Changes the active site's real data. Unsubmitted forms/queries are not saved by toggling the panel. |
| Playground Save | Flush files and database to browser storage; wait for success. |
| Restart | Preserve site data while restarting the runtime. |
| Close | Close runtime ownership; saved sites can reopen. Preserve temporary work first. |
| Reset / delete site | Delete the selected site's files/database. This is distinct from JCB entity Reset. |
| Complete Download / Upload | Transfer and restore the complete site as an independent saved instance; follow [delivery and restore](../../workflows/delivery.md). |
| Share / recipe import | Recreate setup only. |
| Files-only recovery | Salvage files from a failed site; can contain private data and lacks SQL. It is not a complete-site archive. |

Only one tab owns a saved site. Detached editor/database windows still depend on the owner tab. Browser storage can be cleared or evicted; exported artifacts provide a separate backup. Saving files and database is not a guarantee of a single atomic transaction across every store.

Default PHP settings remain `upload_max_filesize=128M`, `post_max_size=160M`, `max_execution_time=60`, `max_input_time=60`, `max_input_vars=10000`, `memory_limit=512M`. The settings dialog validates bounds and checks effective values. Browser memory, installation/export budgets and HTTP limits remain separate constraints. An authorised API harness can read `runtimeInfo`; a UI-only agent records observable information and names what it could not inspect.

Use HTTPS/localhost, a supported browser, service workers, IndexedDB, Web Locks, SharedArrayBuffer and cross-origin isolation. Embedded hosting must supply compatible isolation; an iframe attribute alone is insufficient. Follow browser capability restrictions and diagnose failures rather than disabling browser security.
