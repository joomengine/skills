# Application-scenario verification

## Evidence boundary

The three [application scenarios](../../examples/README.md) define concrete user requests, JCB implementation paths, expected deliverables and observable runtime cases. They are acceptance briefs, not completed application implementations. This record must be updated from actual execution receipts; the procedures and case tables are not themselves passing evidence.

| Scenario | Source implementation | JCB acquisition/compile | Installed application cases | Fresh-source rebuild | Requested export/restore |
| --- | --- | --- | --- | --- | --- |
| Note Desk | Not run | Not run | Not run | Not run | Not run |
| Equipment Loans | Not run | Not run | Not run | Not run | Not run |
| Clothing Store | Not run | Not run | Not run | Not run | Not run |

The existing [minimal Package fixture verification](../../packages/verification.md) and [Super Power verification](../../super-powers/verification.md) cover only their recorded artifacts and stages. They do not establish these scenarios' correctness. In particular, a statically valid package graph does not prove a compiled Note Desk, and an isolated PHP rule test does not prove a concurrent reservation or checkout path.

## Documentation review on 3 November 2026

All 39 local Markdown file destinations across the six new scenario/procedure files resolved, and the whitespace check passed. An independent read-only source review confirmed the linked normalized-subform specimens at Packages `4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9` and the API-generation pointers at JCB `408703a857ad937479b1e28de7f693af178dcc83`.

A second read-only review found three actionable acceptance problems: fixture changes leaking between cases, missing returned-loan coverage, and remote shipping/payment cases applying to an explicitly narrower integration scope. The briefs now isolate fixtures, seed the last-stock concurrency case explicitly, test the returned-loan transition, and distinguish agreed fixed-rate/link-only scope from blocked promised integration. This is documentation/source review evidence, not a fresh-agent application build or any of the runtime passes above.

## Distribution checks on 3 November 2026

The assembled distribution passed its offline documentation/registry checks, Bash syntax checks and ShellCheck 0.11.0. Executed regression groups were 45 transport, 22 network selection, 13 Joomla Power mapping, 37 Super Power, 41 Field Type/Snippet and 33 Package checks, plus 10 composed-service behaviour cases: 201 checks in total. PHP execution used 8.3.6. These are source/tooling checks; they do not change the application-runtime status table above.

An independent review found that running the composed-service preview alone would not protect its authoritative `code.power` source or dependency metadata. The Super Power suite now validates that complete fixture and explicitly rejects source/preview drift and an unresolved injected-interface GUID. The existing validator performs those checks; no second format implementation was introduced.

## Independent PHP authoring exercise on 3 November 2026

A fresh agent received the skills checkout and a task to create a PHP 8.3 stock-availability service with an injected stock interface, deterministic available/unavailable results and invalid-quantity rejection. It received no implementation hints or catalogue. It followed the root/module routes, inspected reuse candidates, discovered advertised mirrors, fetched all seven required Power catalogues and allocated two new identities through the shipped tool. The final catalogue had 366 occurrences and no shadows; both new identities had zero known collisions.

The agent produced a complete local repository containing `StockProvider` and `Availability`, authoritative bodies/settings, matching previews/index, documentation, tests and an executable caller. The repository validator passed for two Powers with two PHP syntax checks and zero deferred body comparisons. All 64 behavioural assertions, six PHP-file lints, JSON/link checks and the local caller passed on PHP 8.3.6. Cases included weak-caller scalar inputs, exact/insufficient/zero stock, invalid quantities, provider failure, negative stock and fresh reads without mutation. Independent review reported no concrete defect.

The exercise used the evolving working distribution rather than a frozen checkout; its initial recorded Git HEAD alone does not attest every document read. The resulting local-only source commit was `cfb68d4aa5e81ca4be66c7b2197ecb614148490e`; it is an execution identifier, not a public repository URL. No remote publication was performed. This demonstrates repository authoring and local PHP behaviour, not JCB import, generated class placement, installed Joomla behaviour, stock reservation or the Clothing Store scenario. Those integration stages remain unrun for this candidate. The maintained [composition fixture](../../super-powers/examples/composed-service/README.md) is a separate reproducible source example with its own CI checks.

## Record future execution

Follow the [fresh-agent procedure](README.md), retain one receipt per candidate, and link it here with the distribution/source revisions and tested runtime. Report documentation navigation, offline source validation, JCB execution, provider integration, remote source publication and site restoration separately. Add named blockers or failures as soon as they are observed instead of waiting for an overall pass.

No PayPal/carrier sandbox transaction, live business update, remote blueprint publication, component installation or site restoration is implied by the publication of these briefs.
