# Develop through an existing JoomEngine MCP connection

Use this route when the user provides a Joomla/JCB installation with a reachable, authorised MCP connection. Keep the same blueprint, identity, reuse, PHP-class and validation rules used by the [Playground route](../testing/playground/README.md). MCP changes the operation interface; JCB remains the authoring and compilation system.

## Contents

- [Choose the current implementation](#choose-the-current-implementation)
- [Set up the Joomla side](#set-up-the-joomla-side)
- [Connect and discover actual capabilities](#connect-and-discover-actual-capabilities)
- [Author, acquire and compile](#author-acquire-and-compile)
- [Use MCP with Playground](#use-mcp-with-playground)
- [Failure recovery and acceptance](#failure-recovery-and-acceptance)
- [Source evidence](#source-evidence)

## Choose the current implementation

For a new installation, follow the Joomla-native [MCP package setup](https://github.com/joomengine/mcp_component/blob/main/docs/GETTING-STARTED.md). It bundles `mcp_component`, `mcp_webservices` and `mcp_plugin`. Install JCB and its required API/console plugins separately. The PHP [mcp_client](https://github.com/joomengine/mcp_client) is a separate workstation/client bridge. The earlier TypeScript `joomla-mcp` repository directs new users to this native stack; do not choose the predecessor merely because its repository name resembles the task.

At the inspected native baseline, Joomla 6.1–6.x and PHP 8.3+ are documented. Confirm the installed release's requirements and discovered capabilities before assuming another target works. A selected Playground recipe, a PHP client installation, and a remotely reachable MCP endpoint are three different prerequisites.

## Set up the Joomla side

When an operational connection already exists, inspect it and continue; do not reinstall it or ask for credentials again. Otherwise carry out the authorised installation using the current upstream guide:

1. Install a stable tagged `mcp_package` ZIP through Joomla's extension installer. Install compatible JCB, its native command plugin, and the JCB webservices distribution when entity API access is needed.
2. Check **Web Services - JoomEngine MCP**, **Console - JoomEngine MCP**, **API Authentication - Web Services Joomla Token**, and **User - Joomla API Token**. Updates can preserve a previously disabled state. Enable the native resource plugins the application needs.
3. In **JoomEngine MCP → Options**, set **Canonical Joomla API URL** to this installation's trusted HTTPS URL ending in `/api/index.php`, including any installation subdirectory. Record the **Site alias**. The client and Joomla's own API forwarding must reach this host.
4. Use a dedicated authorised API identity. Check `core.login.api`, `mcp.access`, `mcp.execute`, viewing access levels, provider/definition publication and the target component's ACL. Writes additionally require the relevant `mcp.write`, resource and approval permissions. A server grant never expands Joomla ACL.
5. Configure the identity's active Joomla API token through the supported private credential flow. A Joomla user can view its own token; an administrator cannot obtain another user's token merely by editing that profile. Never put the token in a blueprint, Git URL, deployment link or receipt.
6. Refresh installed JCB definitions through **Operations → Refresh JCB definitions**, or run `php cli/joomla.php joomla:mcp:jcb-sync` from the actual Joomla root when server-console access is available. Repeat after changing JCB or its registration plugins. Refresh discovers installed contracts; it cannot create absent API routes.

For background JCB jobs, verify a compatible PHP CLI, process launch permissions, `proc_open`, `pcntl_fork`, `posix_setsid` and private writable artifact storage. The native component's API-only operation and background-job support are separate capabilities. A browser WASM instance does not supply these host processes.

## Connect and discover actual capabilities

Use the [upstream connection guide](https://github.com/joomengine/mcp_component/blob/main/docs/CLIENT-CONNECTIONS.md) for executable client installation and launcher configuration. Select the transport supported by the actual agent host:

| Connection | Address/configuration | Boundary |
| --- | --- | --- |
| Local stdio bridge | PHP `mcp_client`; configured site base URL and private token; launch `joomengine-mcp serve` for its saved alias | Requires an agent application that can start local processes. |
| Direct Streamable HTTP | Installation base URL plus `/api/index.php/v1/joomengine-mcp`; supported Joomla token header | Host must support that authentication and reach the endpoint. A session ID is not authentication. |
| Remote-only host needing OAuth | Separately hosted compatible adapter with supported authentication and the Joomla token upstream | The native PHP client does not itself ship an HTTP listener or OAuth adapter. Do not invent one or claim that a local stdio command connects a cloud host. |
| Trusted local server console | Native console/stdio command from the Joomla root | Uses local server authority; do not confuse it with a remote API user's permissions. |

After connecting, complete MCP initialisation through the client and paginate `tools/list` using `nextCursor`. Inspect the returned schemas instead of constructing tool names from database tables. With the seeded catalogue, the useful starting reads are `joomla_sites_list` and `joomla_capabilities` with `{}`, followed by `joomla_actions_search` and `joomla_action_describe` for the intended task. Use the server's discovered site alias, not a different local client nickname.

Record which operations are actually available: entity list/read/create/update, package acquisition, compiler jobs and artifact access. Confirm JCB is installed and its definitions refreshed if expected actions are missing. A discoverable tool can still have runtime prerequisites; distinguish discovery, permission and execution evidence.

## Author, acquire and compile

1. Resolve reusable sources and build the application graph using the [reuse procedure](../standards/entity-reuse.md) and model-specific contracts. Read existing records before creating duplicates. Preserve GUIDs and relationships across repository and MCP representations; local numeric record IDs are not portable GUID replacements.
2. Describe each selected action. Use its exact input schema, filters, nested form/subform representation and identity aliases. Inspect whether code fields are decoded text or require a documented transform. Never guess a generic CRUD endpoint or insert straight into JCB tables to bypass a missing model operation.
3. For writes, follow the server's returned grant/plan/apply protocol. At this baseline: inspect `joomla_permissions_list`; request a missing scope with `joomla_permission_request`; have the operator supply the exact required acknowledgement before `joomla_permission_approve`; prepare the write with `joomla_action_write_plan`; inspect effects and apply its valid `confirmationToken` with `joomla_write_apply` after the required confirmation. An AI host's approval dialog does not replace a server challenge. Reuse valid task-authorised grants; do not introduce additional blanket approval pauses.
4. A `dryRun: true` plan is a non-mutating preview and supplies no apply token. Keep the same operation's UUID idempotency key and execution evidence. After a lost response, inspect the operation before retrying; a newly invented key can duplicate an already-completed write.
5. Save/read back the fields, views, linking records and custom code. Package `get`, Init, Pull, Reset and Push can change state; select them from their actual discovered contracts and the [package operation scope](../packages/workflows/README.md#operation-scopes-that-govern-these-workflows), not their names alone. Acquire the smallest useful root and inspect its dependencies.
6. Request the supported compiler operation for the actual component and target. A returned job is an acceptance receipt, not completion. Poll `joomla_job_status` for that `jobId`; inspect errors and terminal state. Use `joomla_job_artifacts` and bounded `joomla_job_artifact_read` chunks where available; verify assembled size and SHA-256 against server metadata.
7. Install and exercise the generated consumer using the authorised available interface. Test CRUD, relationships, custom PHP behaviour, API permissions and relevant failure cases. Carry diagnostic fixes back to JCB records or repository definitions, then compile and test again. Finish using [delivery and portability](delivery.md).

This protocol is source-backed guidance, not a claim that every resource on every installed JCB version passes it. The native integration ledger includes version-specific unavailable operations, including legacy language-translation source creation. Report a concrete missing capability and use another supported authoring interface when possible.

## Use MCP with Playground

Choose **JCB + MCP** when the selected deployment/runtime supports it. The inspected Playground supplies an authenticated **same-browser** HTTP client for the installed native package. Its explicitly created Playground API handle exposes `getMcpConnection()`; `src/mcp.mjs` exports `createMcpClient()`. An authorised integration harness can use that handle's request transport and private token, initialise the client, discover tools, and close the session. Follow the browser tool's permitted APIs: the shipped UI does not promise a public `window.playground` handle.

**Current capability gate:** Playground `df82e34a`, inspected 2026-11-09, supports nested same-site HTTP through disposable CGI workers. Its upstream `test/mcp-http.mjs` asserts authenticated initialisation, discovery, action description and a real `content.categories.list` API read, including returned category data, MCP ping and subsequent frontend health. This supersedes the earlier `58b21b3` restriction on recursive API requests. It is a source/test-contract finding; this documentation review did not execute that browser test or certify every JCB write/compiler action.

Discover and describe the needed action, execute an authorised read first, and verify the saved state for each write. Native CLI worker jobs and stdio remain outside this browser integration. For an unavailable operation, continue through the same site's supported GUI. Do not infer full component authoring support merely from successful category listing, or reject a current action solely because the older worker implementation could not execute it.

The static Playground URL does not expose a private browser instance to an external PHP client or a remote MCP connector. Installing the MCP package alone cannot create that connection. A future browser relay must be separately implemented, authenticated and verified before this guide can claim it works. Until the installed version demonstrates the required operation, continue authoring and compiling through the [JCB browser GUI](../testing/playground/README.md), or use the user's reachable native Joomla/JCB MCP installation. This preserves the JCB workflow without misreporting MCP execution.

## Failure recovery and acceptance

- On 401/403, inspect identity, token, canonical host, origin, ACL and definition visibility; do not weaken site permissions to force a pass.
- On missing tools, inspect actual extension/plugin installation and refresh definitions. Missing API or CLI routes are not created by a registry entry in this skill distribution.
- On uncertain or long-running writes, inspect the owned operation/job and read the resulting state. Cancellation can leave partial effects. Reconciliation records inspected reality; it is not an undo or replay.
- If a client transport or browser route is unavailable, name the exact missing capability and continue independent source work or a supported GUI route. Ask only for the connection, permission decision or business information actually needed.

Retain a sanitised receipt: site identity, installed Joomla/JCB/MCP versions, discovered action/schema, source and destination revisions, affected GUIDs, grant/plan/job outcome without secret tokens, saved-value verification, artifact hashes and application checks. Report connection/discovery, authoring, compilation, installation and runtime separately. A tool listing is not evidence of a completed component.

## Source evidence

Inspected 2026-11-03. These links pin the inspected implementation and upstream instructions; check the installed revision before applying version-specific claims.

| Source | Evidence |
| --- | --- |
| [Native setup](https://github.com/joomengine/mcp_component/blob/f1375656ea4f1f62955253a6b5daa0979e9c6cb5/docs/GETTING-STARTED.md) | Package/plugin setup, ACL, token, canonical API URL, grant/plan/apply flow, JCB refresh, worker prerequisites and artifacts. |
| [Native client connections](https://github.com/joomengine/mcp_component/blob/f1375656ea4f1f62955253a6b5daa0979e9c6cb5/docs/CLIENT-CONNECTIONS.md) | PHP/stdin bridge, direct HTTP, host authentication compatibility and absent hosted OAuth adapter. |
| [JCB integration contract](https://github.com/joomengine/mcp_component/blob/f1375656ea4f1f62955253a6b5daa0979e9c6cb5/docs/integrations/JCB.md) | Installed route/command discovery, generated API maintenance source and version-specific acceptance gaps. |
| [TypeScript predecessor notice](https://github.com/joomengine/joomla-mcp/blob/8a2dc91cec01244950a544517fe907d41406ff5f/README.md) | New installations are directed to the Joomla-native stack. |
| [Playground MCP integration](https://github.com/joomengine/playground/blob/df82e34a104019c34bcbfd251d37bd9d88d347a0/dependencies/mcp/README.md), [client](https://github.com/joomengine/playground/blob/df82e34a104019c34bcbfd251d37bd9d88d347a0/src/mcp.mjs), [test](https://github.com/joomengine/playground/blob/df82e34a104019c34bcbfd251d37bd9d88d347a0/test/mcp-http.mjs), [network contract](https://github.com/joomengine/playground/blob/df82e34a104019c34bcbfd251d37bd9d88d347a0/docs/network.md) | Refreshed 2026-11-09: same-browser transport, nested API category-read test contract, per-action verification and external reachability boundary. |
