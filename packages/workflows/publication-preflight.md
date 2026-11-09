# Publish Packages and Powers to the intended destinations

Use this workflow when the task includes source publication. Inputs are the maintained JCB graph, its separately maintained project Powers/assets, the authorized repository and branch, and an authenticated supported export path. Read the [operation overview](../../standards/repository-operations.md) first. A component ZIP, source checkpoint and complete-site export are different [deliverables](../../workflows/delivery.md); none proves that repository publication succeeded.

**Source baseline:** JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`, inspected 9 November 2026. The steps below derive from the exporter, repository helper and form; they do not claim a live publication test.

## 1. Inspect effective connections

Record each effective target's provider, host, owner, repository name, read branch, write branch and enabled state, without credential values. `RepoHelper::get(target)` loads `published >= 1`, orders records, and keys the resulting map by `owner/repository`, omitting host. Same-target duplicate records can shadow one another even on different hosts. Avoid ambiguous duplicates and inspect the effective configuration rather than counting visible rows.

| Setting | Required interpretation |
| --- | --- |
| Packages target `4` | Package definitions and supported graph/assets |
| Super Powers target `1` | Separately exported Power definitions; a second record may name the same physical repository |
| GitHub provider `2` | Owner and repository are separate values; repository name omits `.git` |
| Read branch | Acquisition source; does not select the export destination |
| Write branch | Must be nonempty and not literal `default` to be eligible in the inspected writer |
| Access Override | Selects per-record credentials; it is not a write-enable switch |
| Power Approved / Approved Paths | Power must be approved and its exact `owner/repository` path must match a target |

The exporter iterates eligible destinations without stopping after its first success. Inspect **all** effective writable records in the relevant pool. Leave the write branch empty on read-only sources and mirrors. Constrain configuration to the task's intended targets before Push; choosing a repository earlier in Init/Pull does not constrain export. Preserve unrelated configuration, and do not transfer credentials between hosts.

## 2. Establish a real branch

Follow [repository creation](create-repository.md). Confirm the default branch exists at a real commit, then create the authorized candidate from that verified ref. Do not invent a parent SHA or assume an empty remote already has `main` or `master`.

For an empty GitHub repository, an authorized first Contents API file creation on the default branch can initialize it. Read the resulting commit and branch back before creating a named candidate. This is an alternative bootstrap path, not proof that any nonexistent named branch can be created by a file write. A README-only initial commit makes the branch real; it does not constitute a JCB source export.

## 3. Export each source family

1. Save and reopen the selected JCB records. Check portable identities, dependencies and owned assets before export.
2. Push the Package graph to the intended candidate. Read back its root/index, child records, definitions and file/folder payloads. Check all intended destinations independently.
3. Export project Super Powers through their own supported action, with Approved and Approved Paths correctly set. Verify `settings.json`, `code.power`, generated preview, `super-powers.json` and dependency metadata. Package Push alone does not prove these Powers were exported.
4. Compare the remote graph against the intended maintained source and run [package validation](validate-and-integrate.md) plus the [Power checks](../../super-powers/workflows/validate-and-integrate.md). Keep required external catalogues in the recorded dependency closure.
5. Reconcile the landing page after the final export. Both export families can regenerate root `README.md`; durable project documentation belongs in a separate maintained path linked from the final landing page. Check actual root content after combining families in one repository.

Readback must identify the exact branch/commit and authoritative payloads. The writer's per-item success can mean **at least one** destination succeeded; it does not prove every configured destination or subsequent index/README write succeeded. Preserve error messages without credentials and inspect partial state before retrying. These are successive file writes, not one multi-file transaction.

## 4. Prove that another authoring site can consume it

Acquire the candidate graph in a clean authorized JCB instance, supply recorded external dependencies and owned assets, activate required compiler plugins, compile and install the genuine output. Record this separately from same-site recompilation. If a fresh reconstruction is not run, say so explicitly; an exported source tree is still useful, but is not proof of a complete reproducible build.

The review includes the candidate URL/commit, root identities, exported family list, destination-by-destination outcome, dependency/asset inventory, checks performed and any unresolved writes or reconstruction gaps. Keep source publication, installer acceptance and complete-site export/restore as separate results. Never publish complete-site archives, credentials or private migration journals to make the source graph appear complete.

## Source anchors

- [Repository helper](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Utilities/RepoHelper.php): `get`, `modelRepoDetails`, target pooling, duplicate keys and credential selection.
- [Repository form](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/forms/repository.xml): target/provider/branch/override fields.
- [Common exporter](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Set.php): `items`, `save`, `canWrite`, `saveRepoMainSettings` and separate file writes.
- [Power exporter](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Set.php): `targetRepo`, `createItem`, `createPower`, `updateItem`, `updatePower`.

The supplied handover reports a successful first-README GitHub bootstrap at [commit 1c1cf3b](https://github.com/lemuelvdm/JCB-Demo-Eshop/commit/1c1cf3bc9cc39a3907cb03f02b894d31b05a2148). That reported outcome concerns initialization only; it is not evidence that later Package/Power exports or clean reconstruction completed.
