---
name: playground
description: "Build and deliver complete Joomla extensions with Joomla Component Builder in browser-hosted Joomla, PHP and MariaDB. Use for application authoring, repository setup, Init/Pull/Reset, package Push/export, compilation, installation, runtime validation, PHP debugging and portable site delivery through JoomEngine Playground."
---

# Build and deliver with JCB in Playground

Read the [canonical Playground agent guide](README.md) and select the latest compatible releases from [configuration](configuration.md) using the [version policy](../../standards/version-policy.md). Complete the requested extension through maintained source, compilation, installation, working features and final delivery. Record installed versions, candidate source and relevant repository configuration. Respect the user's environment choice; otherwise use the available browser without a routine approval pause.

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

Preserve a receipt with source/runtime identities, selected repositories, actions, expected and observed values and delivered artifacts. Keep the actual results of each stage clear. When the skills do not lead to the agreed outcome, report the reproducible problem in [Skills issues](https://github.com/joomengine/skills/issues) using the [feedback procedure](../reporting-issues.md), so maintainers can improve the instructions. Upstream JCB reports follow the separate human-led route in that procedure.
