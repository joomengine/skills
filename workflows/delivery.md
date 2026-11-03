# Deliver and recover a JCB project

Choose the deliverable from the user's goal. A compiled extension, its editable blueprint, separately maintained Powers/Field Types and a full development-site archive preserve different things. Complete the requested build and checks before asking for an optional backup destination.

## Delivery choices

| Requested result | Deliver | Verify |
| --- | --- | --- |
| Install the extension | JCB-generated component/module/plugin installation ZIPs with version and checksum | Install into compatible Joomla and exercise the required behaviour. |
| Maintain it in another JCB instance | Packages blueprint plus identified external Power, Joomla Power, Field Type and other dependency repositories/revisions | Acquire into a fresh JCB instance, inspect the graph, compile, install and retest. |
| Continue with this complete Playground workspace | **Download → Complete site** portable ZIP | **Upload** the exact archive as an independent site and verify files, records, relationships and behaviour. |
| Recreate the initial setup | Deployment recipe or Share link | Launch an independent installation; edited files/database are intentionally not transferred. |

Include only deliverables actually generated. A working source repository is not an installation ZIP; a compiled component does not preserve editable JCB records; a Share link does not back up a completed site.

## Compile and retain installable packages

Use the actual root's compiler operation and inspect every warning/error. Download each requested extension package through JCB or a verified MCP artifact flow. Record filename, extension version, target Joomla/PHP, source commit/root identity, dependencies and SHA-256. Test installation and the user's actual use cases; successful compilation alone cannot prove payment, shipping, authorisation or stock-synchronisation behaviour.

Preserve maintained source for every correction. A generated PHP edit in JoomEngine Code must return to the appropriate JCB code field, Power definition, asset source or compiler before the next compile can reproduce it. Record any external integration still requiring the user's account or configuration rather than presenting a simulated result as live acceptance.

## Back up editable blueprints and supporting entities

If the user already supplied authorised repositories and branches, use them. Otherwise, after the build is concrete, offer an editable-source backup and request only the desired destinations and missing write access. The user may choose the installation ZIP alone. Use private credential entry, with temporary/restricted tokens when available; do not request tokens in ordinary chat.

Follow [GUI authoring and source Push](../packages/workflows/author-in-playground.md). Record separate read/write branches and inspect **all effective writable destinations** before pushing. A selected component does not guarantee a single target repository. Package export is several remote writes and can partially fail.

Treat supporting entity exports explicitly:

1. Preserve unchanged public dependencies as external references with their canonical identities, actual read sources, order and revisions. They do not all need copies in the user's repository.
2. Export project-owned or adapted Super Powers to the intended Power repository; preserve `settings.json`, `code.power`, indexes and consistent derived representations. Do not put them into a fabricated package `src/power` tree.
3. Use the relevant model's actual export operation for project-owned Joomla Powers, Field Types or Snippets. Confirm it exists in the installed release and inspect every effective writable connection for that target. A component Push message alone does not prove all separate catalogues were exported.
4. Inspect remote changes, dependency closure, source attribution and absence of credentials. Use the model validators and acquire into a clean JCB instance with the intended repository order. Compile and exercise the restored project.

Deliver the root GUID/key, repositories, branches, exact tested commits, dependency list, required target versions and verification outcome. Never equate a bare repository link with a proven portable blueprint.

## Preserve and restore a complete Playground site

The source-backed workflow below applies to Playground `58b21b3`, inspected 2026-11-03. See the [current agent guide](https://github.com/joomengine/playground/blob/58b21b3d61c7415c231f8d180c388409b4910d74/docs/agent-guide.md), [export implementation](https://github.com/joomengine/playground/blob/58b21b3d61c7415c231f8d180c388409b4910d74/src/export.mjs), [archive producer](https://github.com/joomengine/playground/blob/58b21b3d61c7415c231f8d180c388409b4910d74/src/export/site.php) and [Upload implementation](https://github.com/joomengine/playground/blob/58b21b3d61c7415c231f8d180c388409b4910d74/src/site-import.mjs).

1. Save intended editor buffers and finish any intended JCB/database changes. Use Playground **Save** and wait for success. Keep the owner tab open until export completes.
2. Download **Complete site**. It includes `site/`, `database.sql`, `database.ndjson` and `export.json`, together with deployment material. The current importer requires those root-level files and installed Joomla files; preserve the generated layout. Verify the archive exists and retain its checksum. Files-only and SQL-only downloads are partial alternatives, not this portable site.
3. Inspect the archive's intended sharing scope. Complete exports preserve Joomla account data and known sandbox administrator details; JCB repository tokens and other application secrets can also be present in database records. Remove temporary write tokens from the saved site before producing a distributable export and use test data. A complete archive is not automatically safe for a public repository.
4. Use Playground **Upload** with the exact complete-site ZIP. It restores an independent saved site without replaying the original installer commands. The current importer verifies the payload hash when available; older complete exports without it are accepted with a notice.
5. Verify the restored Joomla/JCB versions, login, project root, representative Fields/views/relationships, custom Power code, database contents, files and initial route. Compile and test a representative consumer from the restored source. Check that unwanted credentials have not reappeared.
6. Retain the original and restored evidence. If Upload fails, preserve the error/archive, inspect whether it is the expected complete export and keep the original site; do not reset the only copy.

For conventional hosting, use the archive's `DEPLOYMENT.md`: provision compatible PHP/MariaDB, upload files, import SQL, configure destination database/paths and verify the installation. A successful Playground restoration is not a native-host compatibility test.

## Store the complete archive in Git when requested

Uploading a complete-site archive to an authorised repository is an artifact-storage operation, separate from JCB blueprint Push. Preserve the exact ZIP and its checksum with a short restore instruction and source/runtime receipt; select a private destination for private state. Check repository/file-size constraints and use an appropriate authorised release/large-file facility where required.

Do not promise that a forge's **Download ZIP** of an arbitrary expanded Joomla checkout can be uploaded directly to Playground. Forge archives commonly add a wrapper directory and do not create the required database and export metadata. If the repository stores the complete-site ZIP, the recipient downloads that inner ZIP and supplies it to Playground **Upload**. Restoring the exact artifact is the acceptance test. There is no verified one-button Playground “push entire site to Git” operation in this inspected release; use the available repository tools to publish the downloaded artifact when authorised.

## Completion receipt

Report what was delivered, how to consume it, source/root identities, target versions, hashes and the checks actually performed. Keep acquisition, compilation, installation, runtime, blueprint read-back and whole-site restoration results separate. If a user declines source backup, has not supplied write access, or a runtime feature remains unverified, record that boundary accurately without withholding independently completed deliverables.
