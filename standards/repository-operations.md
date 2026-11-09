# Choose Init, Pull, Reset or Push

Use this overview before acquiring or publishing JCB definitions. **Source baseline:** JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`, inspected 9 November 2026. These are definition-repository operations, not application-data imports, Git merges, compiler runs or Joomla installation. Follow the selected module's acceptance procedure after the operation.

## Choose the content category first

The repository **target** identifies the content pool; the operation says what to do with it. Registering a repository connection does not import its definitions.

| Content category | Repository target in the inspected form | Operational guide |
| --- | --- | --- |
| Super Powers | `1` | [Power import and integration](../super-powers/workflows/validate-and-integrate.md) |
| Joomla Powers | `2` | [Joomla class mappings](../joomla-powers/workflows/use-and-maintain.md) |
| Field Types | `3` | [Field Type integration](../field-types/workflows/validate-and-integrate.md) |
| Packages | `4` | [Package acquisition and integration](../packages/workflows/validate-and-integrate.md) |
| Snippets | `5` | [Snippet integration](../snippets/workflows/integrate.md) |
| Repositories | `6` | [Repository network and connection setup](repository-network.md) |

These numbers are form values at the pinned revision, not network API target names. Provider is another field: Gitea-compatible `1`, GitHub `2`. Do not choose Super Powers merely because a generic toolbar or method name contains “Powers.”

## Choose the operation by its effect

| Operation | What the agent selects | Effect on existing local definitions | Source or destination |
| --- | --- | --- | --- |
| **Init** | Remote identities from a selected repository | Ordinary GUI Init preserves existing local identities and imports missing ones | Selected repository's read branch |
| **Pull** | Remote identities from a selected repository | Requests replacement/update, and can initialize missing selected identities | Selected repository's read branch; this is not a merge with local edits |
| **Reset** | Existing local records | Fetches and applies repository definitions; can replace local work | Effective ordered sources and their read branches, without an explicit source selection in this call |
| **Push** | Local definitions to export | Publishes definitions and relevant graph/assets; does not refresh local definitions | Every eligible configured write destination for the content pool, subject to that model's gates |

The ordinary GUI distinction is implemented by `AjaxModel::initSelectedPackages()` using default `force=false` and `pullSelectedPackages()` passing `true`. **CLI Init with `--force` is a separate explicit overwrite mode**; it does not change what ordinary GUI Init means. Inspect the installed command's help/options before use.

Reset is not a metadata-only cleanup command. At this baseline the CLI help says “Reset local tracking/state,” but `Console\Package\Reset::doExecuteAction()` invokes the same entity reset workflow that writes local definitions. Treat it as a refresh with possible replacement. Do not use it to clear a cache while preserving unsaved/local changes.

## Understand dependency scope

| Path | Established scope | Required follow-up |
| --- | --- | --- |
| Package Init/Pull | Drains supported recorded dependencies and file/folder requests, propagating the same repository and force setting | Verify each required service/source exists; a selected repository does not imply fallback to unrelated sources |
| Package Reset | Recurses through owned/direct-child `direction: in` requests and invokes asset reset separately | Acquire or refresh outgoing shared definitions separately; consult the [asset reset limitation](../packages/specification.md#import-pull-reset-and-persistence) |
| Selected Super Power import | Acquires the selected Power's settings and body through its registered path | Verify referenced Powers and their versions independently; do not infer a forced refresh of the full transitive graph |
| Compiler Power acquisition | Resolves the references used by the consumer during compilation | Inspect generated dependency/namespace/autoload closure; it is not evidence that a prior Pull refreshed every linked local Power |

Only fetched payloads expose their remote dependency descriptors. An Init that keeps an existing local root is not proof that its entire missing dependency graph was inspected. An unsupported/unregistered handler can be skipped; check saved definitions, references and assets rather than relying solely on the result banner. See the [package contract](../packages/specification.md#import-pull-reset-and-persistence) for exact persistence semantics.

## Keep three kinds of order separate

1. **Definition precedence:** Reset looks through the effective configured repository order for the same indexed identity. “Closest” means that resolution order, not geographic distance, newest content or a search of all branches.
2. **Read transport:** the [network procedure](repository-network.md) selects a suitable advertised mirror while preserving logical source identity, branch and precedence. The agent's Codefloe preference is maintainer policy; the inspected runtime's health resolver randomly selects an eligible active alternative and does not implement a deterministic Codefloe-first retry chain.
3. **Write eligibility:** a prior Init/Pull selection does not constrain Push. A usable write branch makes a configured target eligible; Super Powers additionally require approval and matching approved paths. Inspect [publication preflight](../packages/workflows/publication-preflight.md).

The global reader selects the first matching indexed identity. Failure to fetch that selected payload does not guarantee retry against every later duplicate. Inspect the selected index, payload path, read branch and messages. Repair the intended source or deliberately change resolution; do not silently switch to a different definition and call it equivalent.

## Execute and verify

1. Record the content category, selected identities, intended operation, actual JCB version and candidate repository/ref. Preserve local differences before Pull/Reset.
2. Inspect effective enabled connections and read branches. For Push, inspect all write destinations first. Reuse authorization already provided by the task.
3. Run the supported GUI/MCP/CLI action. Start a fresh request after configuration changes to avoid interpreting request-local cached indexes as a new lookup.
4. Reopen the definitions and compare a distinctive expected value, stable identity and relationships. Inspect dependency and asset outcomes separately. An “added” count is not a byte comparison or a complete build.
5. For publication, read back each intended branch, index and authoritative payload. Report per-destination results; the writer's at-least-one-success return can coexist with another destination's error.
6. Compile and exercise the real consumer under the selected module's workflow. If partial writes or missing dependencies occur, preserve the observed state, resolve the exact cause and retry the remaining coherent operation; do not repeatedly overwrite unrelated local work.

## Source map

All links below pin the reviewed revision. Reinspect the installed release when behaviour differs.

- [Repository form](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/forms/repository.xml): content targets, provider and separate read/write fields.
- [GUI actions](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/admin/src/Model/AjaxModel.php): `initSelectedPackages`, `pullSelectedPackages`.
- [Remote getter](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php): `init`, `reset`, `item`; local preservation and writeback.
- [Package builder](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Builder/Get.php): `init`, `reset`, `getDirectChildrenGuids` and asset dispatch.
- [Repository reader](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Grep.php): `get`, `searchSingleRepo`, `existsRemotely`; [Power reader](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Grep.php): `getRemote`.
- [CLI Init](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Console/Package/Init.php) and [CLI Reset](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Console/Package/Reset.php): force mode and actual reset call versus help text.
- [Exporter](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Set.php): `save`, `canWrite`; [Power eligibility](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Set.php): `targetRepo`.
- [Network resolver](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Network/Resolve.php): `api`; [network status](https://github.com/joomengine/Joomla-Component-Builder/blob/037752c7e6599aa4cec900138dfb61af7ee4ba8f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Network/Status.php): `active`.

This review establishes source behaviour, not a newly executed live Init/Pull/Reset/Push round trip. The supplied annotation also identifies public wording to reconcile in [CLI Command Suite](https://github.com/orgs/joomengine/discussions/1013) and [Packaging Engine](https://github.com/orgs/joomengine/discussions/995): describe Reset as definition refresh and list Pull explicitly. Updating those discussions is separate from updating this guide.
