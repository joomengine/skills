---
name: playground
description: "Use JoomEngine Playground to author and validate Joomla Component Builder models in browser-hosted Joomla, PHP and MariaDB. Use for repository setup, Init/Pull/Reset, persisted-record inspection, package authoring and Push/export, component/module/plugin compilation and installation, generated-file inspection and PHP debugging. Select model-specific acceptance tests and record actual version and capability limits."
---

# Exercise the real JCB path in Playground

Read the [common procedure](README.md) and choose the requested supported runtime from [configuration](configuration.md). Record the actual installed versions, candidate source commit and relevant repository configuration. Respect opt-outs; otherwise use the available browser for authorized implementation testing without a routine approval pause.

| Changed artifact | Required model procedure |
| --- | --- |
| Super Power | [Import, generated class and real caller](../../super-powers/workflows/validate-and-integrate.md) |
| Field Type | [Concrete Fields, generated forms and persisted values](../../field-types/workflows/validate-and-integrate.md) |
| Snippet | [Copied view, assets and rendered behaviour](../../snippets/workflows/integrate.md) |
| Package blueprint | [Graph acquisition, component/module/plugin build and runtime](../../packages/workflows/validate-and-integrate.md) |
| Author a package in the GUI and publish its source | [Author and export](../../packages/workflows/author-in-playground.md) |
| Connect through the user's native Joomla/JCB MCP | [MCP workflow](../../workflows/mcp.md) |
| Return compiled ZIPs, source or a complete site | [Delivery and restore](../../workflows/delivery.md) |

Use the [repository network workflow](../../standards/repository-network.md#configure-jcb-and-playground) when selecting a monitored core mirror or recovering source access. Configure the correct repository target/provider/read branch and effective precedence. Choose Init, Pull or Reset according to the model's actual semantics. Reopen saved records and compare the intended change before compilation. Distinguish JCB repository Push from compiling/downloading an installable extension ZIP.

For a new application request, follow the [request-to-extension route](../../workflows/request-to-extension.md): use a supplied capable MCP environment or the Playground GUI by default when none is supplied. No local/server JCB deployment is needed for this browser route. Prefer stable application GUID relationships, create an Admin View for each separately persisted child table, and keep custom behaviour in maintained Powers/JCB records. Deliver the requested runtime installers and complete-site archive, and verify independent Upload before claiming the site was restored.

Use Code to inspect actual generated/installed files and diagnose requests; use DB to inspect the same site's saved data. Return durable fixes to maintained source, reacquire/recompile/reinstall and retest. Database-held JCB definitions are not updated by editing generated PHP. Optional in-Playground AI and MCP have separate capabilities; consult the [source and capability ledger](sources.md) and [MCP gate](../../workflows/mcp.md#use-mcp-with-playground) rather than assuming external-agent access or browser MCP content-writing support.

Preserve a receipt with source/runtime identities, selected repositories, actions, expected and observed values, artifacts and limits. Report static, import/refresh, export/read-back, compile, install and runtime outcomes separately. A blocked browser, credential or unsupported target is a named gap, not a pass. Use the [bounded historical receipt](verification.md) as an example and the [human issue handoff](../reporting-issues.md) for a reproducible upstream defect.
