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

## Record future execution

Follow the [fresh-agent procedure](README.md), retain one receipt per candidate, and link it here with the distribution/source revisions and tested runtime. Report documentation navigation, offline source validation, JCB execution, provider integration, remote source publication and site restoration separately. Add named blockers or failures as soon as they are observed instead of waiting for an overall pass.

No PayPal/carrier sandbox transaction, live business update, remote blueprint publication, component installation or site restoration is implied by the publication of these briefs.
