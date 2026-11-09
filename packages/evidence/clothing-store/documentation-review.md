# Clothing Store contribution review — 9 November 2026

## Scope and evidence authority

This review evaluated two supplied documents against Skills `main@b5633813fafd6a88226fe2a12b9f38d53619a41c`. It improves the reusable instructions; it does not publish or certify a Clothing Store implementation. The documents were read directly and their SHA-256 values calculated during this review:

| Input document | SHA-256 |
| --- | --- |
| `SKILLS-PR-HANDOVER.md` | `4373950d0aace295643e7b5b38120c6107a785c0e98deadf897107e90b24c672` |
| `JCB Skills Documentation annotation.md` | `5392968e0497cc42c47afb01d0a75b7732de68cd62ec794b0358ca10b6cf6225` |

The handover describes a supplied JCB **6.2.1-alpha2** distribution and reports later store-specific corrections. The annotation separately pins public JCB `6.x@037752c7e6599aa4cec900138dfb61af7ee4ba8f`. These are different provenance claims: the annotation's public commit does not by itself prove that the supplied distribution or generated store used exactly those bytes. Each operational guide identifies the source inspected for its implementation claims.

The following companion archives were **not supplied for this review**. Their names and hashes are copied as reported identifiers, not independently verified bytes or public download links:

| Reported archive | Reported SHA-256 | Reported contents |
| --- | --- | --- |
| `clothing-store-guid-source-checkpoint-2026-11-09-r3.zip` | `139b64cd7a497f354e76004cf5ecd6cb34a2eaefbde5abe2785701b09fcd6873` | Text-only maintained-source checkpoint; incomplete external build inputs |
| `clothing-store-build25-installed-acceptance-2026-11-09.zip` | `8ef940e52a0cb78354cb2c017628b38b86803aa44a9cc2d3eb8237d1617ec258` | Artifact-specific generated/installed acceptance receipts |

Do not imply this PR ran their harnesses, restored their site or inspected their installers. Obtain the exact archives when reproducing that candidate, verify their manifests, and keep their chronological receipts intact. A reported hash alone establishes no runtime result.

## Evaluation and canonical destinations

The useful contribution is an operational route through existing models, not another top-level skill family. The original skills already explain graph acquisition, entity reuse, source precedence, compile/install validation and delivery. The revision makes the consequential choices and failure boundaries reachable from those routes.

| Recommendation | Decision and canonical instructions |
| --- | --- |
| Prefer portable GUID relationships | Adopt for new portable application entities while retaining Joomla numeric keys and deliberate ID alternatives. Distinguish definition GUID, application GUID, numeric key and business key in [application identities](../../workflows/application-identities.md). GUIDs do not implement replication or conflict resolution. |
| Store subform rows in their own table | Require the child entity's actual Admin View/component association and explicit expert load/save services; document normal/Multi semantics and application adapters in [normalized subforms](../../workflows/normalized-subforms.md). |
| Make GUID selectors work end to end | Trace selected value, title, filtering, controller edit lookup, linked defaults and permissions in [modal relationships](../../workflows/modal-relationships.md). A GUID column alone is insufficient. |
| Select the right import operation | Route authoring acquisition, Extrusion, generic data import, synchronous import and queues separately in [imports](../../workflows/imports.md). |
| Use immediate application import for this store | Reuse shared Transient services with validation/collection and an application commit in [immediate import](../../workflows/immediate-import.md); keep [translation](../../workflows/translation-import.md) and [staging](../../workflows/staged-import.md) reference semantics distinct. |
| Explain native schema harvest | Document actual input/identity contracts and schema comparison in [Extrusion](../../workflows/extrusion.md); a harvested scaffold is not a completed application. |
| Migrate existing relationships carefully | Preserve identity, historical/replay payloads and durable retry state through [GUID migration](../../workflows/guid-migration.md). Do not apply the store's historical SQL to unrelated databases. |
| Preserve build corrections and dependencies | Follow [compiler plugins](../../workflows/compiler-plugins.md) and [libraries/assets](../../models/libraries-and-assets.md); repeated same-site compilation and clean-source rebuild remain distinct. |
| Clarify API selection and identity adapters | Use [API selection](../../models/api-selection.md); generated route presence does not establish authenticated/restricted behaviour or domain permission. |
| Clarify Init/Pull/Reset/Push | Adopt the annotation's plain-language distinction in [repository operations](../../../standards/repository-operations.md), retaining each model's dependency scope. Reset may replace local definitions. |
| Bound publication destinations | Audit effective package/Power write targets and separate exports through [publication preflight](../../workflows/publication-preflight.md). Read-source selection does not restrict Push. |
| Support one-prompt authoring and useful handoff | Route through [request to extension](../../../workflows/request-to-extension.md), actual [MCP capabilities](../../../workflows/mcp.md) or [Playground](../../../testing/playground/README.md), then [delivery](../../../workflows/delivery.md). |

The annotation also proposes correcting the public CLI discussion's description of Reset and adding Pull to the Packaging Engine discussion. Those are separate editorial changes outside this repository; this review does not claim those discussions were changed. The repository's instructions explain the operation directly without depending on that external wording.

## Reported execution, without promotion to a full pass

The handover reports Joomla 6.2.0, JCB 6.2.1-alpha2, PHP 8.4.27 and MariaDB-embedded for its final acceptance. Every result below is **reported by the supplied handover**, not rerun or independently verified for this PR.

| Stage | Reported result | Limit that must remain visible |
| --- | --- | --- |
| Maintained-source preservation | R3 checkpoint and source map retained | Text-only checkpoint is not a complete authoring site or hermetic build input |
| Build22 | Static checks and parsing passed, then integration review failed | Superseded artifact; static success did not establish runtime correctness |
| Build24/build25 | 529 component members matched byte for byte and retained update SQL | Same authoring site; ZIP containers differ; no clean-source reconstruction |
| Installer parsing | 324 PHP files across three ZIPs parsed | Parsing is not installation or runtime acceptance |
| GUID migration and replay | Restored application graph preserved through update; same-journal replay unchanged before later application use | DDL/installer not atomic; replay after application drift and restore recovery remain separate |
| Product/child editing | Existing-child title edit/restore and identity preservation | Live new expert-child creation and Product Save as Copy uncompleted in that run |
| Linked New/modal | Product GUID preselection, new unpublished Variant, clear/select/save | Restricted accounts, alternate contexts and all negative cases not established |
| Immediate import | Stale rejection, valid update, identical replay and rejected two-row batch with unchanged snapshot | Not every format/limit or concurrent import race |
| Storefront | Browsing, unpublished/sold-out handling, bag changes and guest sign-in gate | No provider/payment or production-commerce pass |
| Installed parity | Mapped component/API files compared with named exclusions | Not a wholly clean installed tree; retained old file not proven unused dynamically |
| API | Plugin/routes inspected and no-token Forbidden body observed | HTTP status, authenticated updates and restricted-account matrix not established |
| Provider/concurrency | Uncompleted for final build | No PayPal sandbox or real concurrent checkout pass |
| Complete site | Export and required-member/CRC inspection reported | Independent restoration not established by that acceptance archive |
| Clean JCB reconstruction | Uncompleted | Requires complete graph, assets, dependencies and compiler bootstrap followed by clean consumer acceptance |
| Source publication | README bootstrap reported | Package/Power Push and remote read-back not established |

Do not sum overlapping local/synthetic/generated test counts into an application pass. Preserve per-artifact failures and exclusions. For example, a Table bind/getRules probe is not a persisted ACL edit round trip, and a no-token response is not authenticated API acceptance.

Reported final component SHA-256: `76f8b094fa694fe79d34bdc80f46b456ec3fe9fcc6755e8b8a927a5afd5a1166`. Reported final webservices plugin SHA-256: `027c42dd170981fd0879e5fb03222d91a0336539206a1f2f0d4a4591ccbd49b4`. These identify the candidate to obtain; they are not artifacts shipped with the skills.

## Acceptance for the next implementation

Use the [Clothing Store acceptance cases](../../../examples/clothing-store.md#observable-acceptance), not the reported table as a substitute for testing a new component. Keep these outputs distinct:

1. **Maintained source:** saved JCB graph, authoritative Power bodies/settings, dependencies, owned assets and build prerequisite definitions.
2. **Published source:** separately verified package and Power exports on the authorized branches, with remote read-back. A repository README is not this output.
3. **Installers:** genuine final compiler-produced component/runtime plugin/package ZIPs, with hashes and clean Joomla acceptance; build-only plugins delivered separately.
4. **Complete site:** actual Playground Complete site export containing files/database/configuration, privately delivered and independently imported into a fresh site.
5. **Reconstruction:** fresh JCB acquisition and build from the complete maintained source, followed by applicable installed tests. A site restore and two repeated builds do not prove this stage.

After each failure, correct the authoritative definition or supporting source, regenerate and retest the affected consumer. Record versions, input hashes, exact operations, observed results, remaining blockers and scope. Keep credentials, private site archives, migration journals, account exports and customer data out of public evidence; use synthetic fixtures.
