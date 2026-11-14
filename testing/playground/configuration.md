# Configure a Playground build

Use the [canonical Playground guide](README.md) to build and deliver the requested extension. Select current releases using the [version policy](../../standards/version-policy.md): latest compatible production releases for production work, or the latest applicable development releases for development/testing. The [source ledger](sources.md) records inspected implementation revisions; those citations are evidence, not required runtime pins.

**Lifecycle version scope:** the controls below describe merged Playground PR #24 (`c403f035`, 2026-11-14). Check the deployed manifest and visible controls before applying them: the initial review saw `c49d025`, while the [later live test](verification.md#2026-11-14-live-follow-up-after-pr-24-deployment) confirmed deployed `c403f035`. Older builds retain different Save/Close and temporary-site behavior. See the [source ledger](sources.md#workspace-lifecycle-refresh-2026-11-14) and [storage recovery](storage-recovery.md).

Playground's URL selects a runtime, deployment and initial Joomla route. It does **not** select a Power/Field Type/Snippet/Package Git read branch. Configure the repository target, provider, read branch, enabled state and precedence **inside JCB** using the [common acquisition workflow](README.md#3-configure-the-candidates-real-jcb-repository-connection).

## Select current compatible versions

Select the target through the live **Joomla**, **JCB** and **PHP** controls. Read the published `assets/version-catalog.json` and its `generatedAt` when available. The build stages discovered packages and hashes; opening a selector refreshes that published catalogue, not the upstream release servers. Do not hardcode a list of newest releases into a skill or assume a saved site was upgraded by a catalogue refresh.

Choose the latest compatible Joomla, JCB and PHP releases offered by the published catalogue for the requested target. Use the **stable** group for production work; select the latest applicable **nightly** or **upcoming preview** (alpha, beta or release candidate) when the task calls for development testing. Respect an explicit older compatibility target while choosing its latest supported releases. If the requested release is absent, investigate catalogue freshness and compatible deployment choices rather than silently using a historical example version.

The catalogue and recipe determine valid Joomla/JCB pairings. An experimental forward-test pairing is useful for compatibility work and needs its own runtime checks; selecting it does not establish production compatibility. Confirm the effective installed versions after launch. The inspected build obtains native 64-bit PHP integer runtimes from a resolved `php-wasm-int64` release and retains JCB's bundled spreadsheet dependencies. Record the effective PHP patch, `PHP_INT_SIZE` and selected package identities/hashes as the build receipt; do not turn that receipt into a fixed version requirement for later builds.

A restored installation can show **Saved version** with its stored package identity/hash. Refreshing the catalogue does not upgrade that installation. Use **Use this deployment** for an independent build with the newly selected releases, and preserve work with a complete downloaded export before replacing an environment. Prepared images are eligible only when their package identities match the selected configuration.

## Ready-to-use test links

Start with [JCB setup](https://playground.joomengine.org/?deploy=jcb&start=0), [JCB + MCP setup](https://playground.joomengine.org/?deploy=jcb-mcp&start=0), or [Joomla-only consumer setup](https://playground.joomengine.org/?deploy=blank&start=0). Inspect the current selectors, choose the requested supported target and launch. `start=0` suppresses the countdown so configuration can be reviewed.

For an independent installation, use **Configure deployment → Use this deployment** or [fresh JCB setup](https://playground.joomengine.org/?deploy=jcb&fresh=1&start=0). `fresh=1` also bypasses prepared images and runs the recipe. A normal visit can resume the persisted live site. Name long-running work clearly and retain a complete downloaded export before replacing it. The current live workspace is replaced only after the dirty-work/backup checks; a new key is not a backup.

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
| `persist=0` | Ignored by the post-PR #24 Rocket interface: the live site always persists. Older temporary-mode URLs are not a current recovery guarantee. |
| `key` | Select a browser-local saved-site identity; reusing it can reopen existing data. It is not a shared site URL or an access secret. |
| `fresh=1` | Create a new live-site key and run the recipe instead of a prepared image; replacing the current live workspace offers backup/download first. |
| `toolbar=0` / `hideToolbar=1` | Hide header/footer with edge restore controls. Explicit `hideToolbar` takes precedence. |
| `start=0` | Show configuration without automatic launch. |
| `extensions` | Encoded JSON array of `{ "url": "..." }` package objects; use the editor's repeatable URL rows for ordinary setup. User-supplied package checksum fields are ignored. |
| `extension` | Repeatable package URL parameter, added to the extension list. |
| `commands` / `startupCommands` | Encoded arrays of Joomla CLI argument arrays, for example `[["cache:clean"]]`. `commands` wins. These are not host shell commands. |
| `config` and optional `sha256` | Public deployment-document URL and optional document digest. This digest does not cover every custom package. |
| `#deploy=...` | Share-generated deployment configuration. Prefer the UI's encoding and keep credentials out of links. |

## Install another extension

In **Deployment → Extension packages**, add one URL row per package. **Use this deployment** installs them in an independent site; **Apply to this site** applies the supported changes to the running site. Once Joomla is open, its normal extension installer also accepts packages through the supported upload or URL flow.

Custom extension/template URLs support HTTP and HTTPS without embedded credentials or fragments. They are installed through Joomla's `extension:install --url=URL`. Current source routes PHP HTTP through the shared transport with its configured Worker fallback when browser Fetch cannot expose a remote response; this supersedes the earlier direct-Fetch-only restriction. A custom-package failure stays visible while Joomla opens so it can be retried. Required managed deployment packages must install successfully, and their staged package hashes are verified. Do not apply the old direct-fetch checksum behaviour to the current custom-URL path. Inspect actual installer errors, especially for slow database-heavy packages. Installation has its own bounded execution budget; changing ordinary page timeouts alone does not prove the installer limit changed. See the [2026-11-09 network evidence](sources.md#current-network-and-mcp-refresh-2026-11-09).

Startup commands execute after installation and are not replayed merely by reopening a completed saved site. Review commands/packages before **Apply to this site**; removing an item from a recipe does not uninstall it. Failed apply offers checkpoint recovery as a separate site.

## Deployment presets

**Configure deployment** stages the site name, administrator account, login behavior, Joomla/JCB/PHP selection, extension packages, languages, menus, template and starter content. **Basic** and **JSON** edit the same configuration. Inspect validation messages and recipe requirements when choices are disabled, then use **Use** for a new site or **Apply to this site** for supported changes. After launch, **Site**, **Admin** and **Credentials** open the current site's frontend, administrator and actual login details.

**Save** in the deployment editor saves a recipe, with changes to built-ins becoming a Custom copy. **Save as copy** creates another recipe; deleting a custom recipe does not delete installed sites. **Use** starts an independent installation. **Apply to this site** checkpoints and applies supported changes to the running site. Joomla/deployment selection does not perform an in-place Joomla upgrade of an existing site.

The version 3 **Export configuration** document (with version 2 import compatibility) includes administrator details and deployment settings. **Import configuration** restores that recipe, not its site's files/database. **Share** produces password-free version 1 public setup for an independent installation. The inspected limits are 1 MiB per configuration document and 16 KiB per Share link.

Prepared images are used only for compatible selected package identities; other catalogue choices install their staged packages. Source recipes include `jcb`, `jcb-mcp`, `blank`, Service Directory and other demonstrations. Their current requirements and selected release determine eligibility; do not treat a static recipe listing as a full version matrix. The optional MCP deployment is subject to the [MCP capability gate](../../workflows/mcp.md#use-mcp-with-playground).

## Lifecycle, persistence and evidence

| Action | Effect |
| --- | --- |
| JCB form Save / database submit | Commit the intended record or data to the active site. Unsubmitted forms are not captured by background persistence. |
| Editor Save / Save All | Write active virtual files. Unsaved editor buffers are not exported. |
| Automatic live persistence | Background file/database flushing follows completed changes; a failure stays visible and does not advance the saved-state indicator. Keep the owner open while a write is pending or failed. |
| Playground Save / Save as copy | Save a reusable deployment recipe, not a full snapshot of the site's files/database. |
| Restart | Restart PHP with the same files/database; do not redeploy. |
| Stop / Start | Stop waits for persistence before releasing runtime ownership; Start resumes that site without reinstalling it. Do not stop the only live copy after a persistence failure before downloading recovery data. |
| Editor Reload | Refresh the preview after in-flight editor saves; do not write dirty buffers or restart PHP. |
| Reset | Confirm replacement of the current live site with the default JCB deployment; offers backup/download first. This is not JCB entity Reset. |
| Export / Import configuration | Transfer the recipe, including administrator settings, not installed files/database. |
| Backup / Backups | Open the panel; **Back up current site** creates an intentional full archive. Choose **Update this backup** or **Create a new backup**. Opening the panel does not create one. |
| Backup restore / download / delete | Restore the archive into the live workspace while retaining the stored backup, retain an external copy, or delete that chosen backup respectively. |
| Backups storage management | Inspect storage estimates and removable old live sites, legacy deployment images, recipes and preferences. Active/locked stores are protected; unassigned stores need individual confirmation. |
| JCB Download Component | Retain the compiled installable extension ZIP, separately from editable JCB source and the complete workspace. |
| Complete Download / Upload | Download the full live site; Upload restores it into a live workspace and persists automatically without creating an implicit backup. Follow [delivery and restore](../../workflows/delivery.md). |
| Share / recipe import | Recreate setup only. |
| Files-only / SQL-only download | Partial recovery/inspection artifacts; neither alone is a complete-site archive. |
| Recover saved site | Access recovery without booting Joomla. If MariaDB cannot start, files-only read-only recovery lacks SQL and may contain private settings; do not label it a complete backup. |

One window owns the runtime and storage lock; companion Playground views share it. If the owner closes, another view can explicitly resume the last persisted site, not unfinished live changes. Browser-held backups share browser storage and can be cleared or evicted too: download a complete archive outside the browser. File and database flushes are serialized but not one atomic cross-store transaction.

Full backup replacement is atomic: a rejected write retains the old archive and offers the prepared new archive for download. The storage estimate uses actual archive size plus a 10 MiB margin, but an estimate can still be followed by a rejected write. Follow [storage recovery](storage-recovery.md) rather than resetting or repeatedly replaying a successful application action.

Default PHP settings remain `upload_max_filesize=128M`, `post_max_size=160M`, `max_execution_time=60`, `max_input_time=60`, `max_input_vars=10000`, `memory_limit=512M`. The settings dialog validates bounds and checks effective values. Browser memory, installation/export budgets and HTTP limits remain separate constraints. An authorised API harness can read `runtimeInfo`; a UI-only agent records observable information and names what it could not inspect.

Use HTTPS/localhost, a supported browser, service workers, IndexedDB, Web Locks, SharedArrayBuffer and cross-origin isolation. Embedded hosting must supply compatible isolation; an iframe attribute alone is insufficient. Follow browser capability restrictions and diagnose failures rather than disabling browser security.
