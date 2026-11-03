# Execute and assess application scenarios

Use this procedure to demonstrate that the community skills support the [application examples](../../examples/README.md). It is an acceptance procedure, not a declaration that the examples have passed. Use the [verification record](verification.md) for observed results.

## Prepare a fresh-agent exercise

1. Freeze the skill distribution commit and select one example prompt. Supply a fresh agent with that prompt and the complete distribution's path or published URL. Provide the same environment/tools a real user would have, plus only task-local information such as target versions and previously supplied credentials or repositories.
2. Do not supply the author's chat history, a completed blueprint, hidden repair hints or an earlier successful agent transcript. The maintained examples and their acceptance criteria may be read as normal published documentation. They express requirements, not a precomputed implementation.
3. Let the agent discover the relevant workflow and model references. Answer material questions as the user would and preserve the answers. Do not coach it around a documentation gap without recording the intervention and rerunning the affected task with another fresh agent after a fix.
4. Use a separate disposable application workspace and JCB site. Keep prior candidate artifacts out of the new agent's starting directory. Record any baseline fixture deliberately supplied by the task; a fixture must not be silently presented as the agent's original work.
5. Run the stages below for the actual candidate. An environment/tool blocker is a result to preserve, not permission to fabricate success or to substitute a different target silently.

Start with Note Desk to exercise the basic lifecycle, then Equipment Loans for custom PHP and relational behaviour, then Clothing Store for integration complexity. Successful execution of one does not certify the others. Later tests should vary the request, target or reuse choice enough to demonstrate transferable use of the instructions.

## Required execution stages

| Stage | Inspect | Passing evidence |
| --- | --- | --- |
| Requirement routing | Questions, chosen route and loaded references | The agent resolves consequential ambiguity and chooses an available, authorised route without requiring private prior knowledge. |
| Reuse and identity | Retrieved indexes/source, selected records and adaptations | Actual source/revision and configured precedence are recorded; identities and related references are coherent; unavailable candidates are not invented. |
| Source structure | Blueprint and supporting Power/Field Type/Snippet artifacts | Appropriate validators pass and their coverage limits are retained; algorithms have maintained source and actual consumers. |
| Authoring/acquisition | Saved JCB records and relationships | The intended values persist after save/reopen or import; Init/Pull/Reset is used with the actual documented effect. |
| Compilation | Selected root, messages and downloaded artifact | The real candidate compiles; emitted PHP/XML/SQL/assets, class placement, services and API/router output match its requirements. |
| Installation and behaviour | The installed candidate on the declared runtime | The scenario's applicable case IDs pass through actual user/API paths, including its meaningful failure cases. |
| Reproduction | Clean-instance acquisition and build | The retained source reproduces the tested result without relying on undeclared records or generated-file patches. |
| Requested delivery | ZIP, remote source and/or complete site archive | The exact requested artifacts exist; remote read-back and complete-site restore are demonstrated separately when applicable. |

Use the [package acceptance procedure](../../packages/workflows/validate-and-integrate.md), [custom PHP workflow](../../super-powers/workflows/customize-extension.md) and each affected model's acceptance instructions. These stages organise their evidence; they do not replace model-specific checks. Keep browser/WASM and native Joomla results separate where database concurrency, inbound callbacks, mail or network behaviour differs.

## Record one receipt per candidate run

Preserve a concise Markdown receipt with the following concrete information. Use real values from execution; do not prefill expected passes.

- **Task:** exact input prompt, scenario/case IDs, agreed user answers and accepted scope changes.
- **Inputs:** skill commit, candidate source commits and content hashes where needed, component/root identities, dependency sources and order, JCB/Joomla/PHP versions and environment/build identity. Distinguish local modified bytes from committed source.
- **Route:** MCP tools actually available, GUI/repository steps actually used, documentation paths loaded, and relevant fallbacks or user interventions.
- **Results:** for each stage and applicable case, status, observed result and evidence path/reference. Record commands and exit codes for static checks, actual response/storage observations for API tests, and generated/installed artifact checks rather than screenshots alone.
- **Outputs:** component ZIP hash, blueprint/supporting repository commits or local source artifacts, complete-site archive hash and restoration result when requested. Keep credentials, customer data and private source out of public evidence.
- **Gaps and changes:** exact failure/blocker, whether it belongs to documentation, implementation or environment, durable source changes made, and which cases were rerun against the corrected candidate.

Use statuses consistently: **passed**, **failed**, **blocked**, **not run**, or **not applicable**. A blocked stage names the missing capability/input and attempted operation. Not applicable names the scope reason; missing credentials or tools are blockers, not exclusions. A documentation/read-through or pure-PHP smoke pass must not become a compilation, provider-integration or full-application pass.

## Improve and rerun

When the agent encounters a gap, capture its exact stopping point and the missing concept, operation or source. Correct the canonical guide, route the new information from the concise entry point, and rerun the affected scenario with a fresh agent. Do not solve a navigation problem by requiring every agent to read the entire repository.

Classify external problems accurately: an unavailable browser connection, service token or source mirror is not automatically a JCB defect. For an apparent runtime defect, preserve a minimal reproduction under the [reporting procedure](../reporting-issues.md). Continue independent work where possible without weakening the user's requirement.

A scenario is complete for a named target only when its required stages and cases pass against the same delivered candidate. A change after the receipt requires revalidation of the affected evidence. Community documentation can be published with explicit incomplete integration evidence; it must not advertise those incomplete workflows as proven. Update [verification](verification.md) with actual receipt links and limits, and keep historical failures distinguishable from later successful runs.
