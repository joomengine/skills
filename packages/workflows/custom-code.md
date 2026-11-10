# Author and reuse manual Custom Code

Use this workflow to maintain a source block once and insert it into multiple JCB code areas, optionally substituting different values at each use. This is **compile-time source expansion**, not a PHP function call. For a reusable class/API use a Power; for presentation composition consider a Template/Layout. Read the [model and dependency boundaries](../models/code-and-placeholders.md) first. Hash automation is a separate [discouraged last-resort workflow](custom-code-automation.md).

## Inputs and authority

Use the current supported target under the [version policy](../../standards/version-policy.md), and the [Playground guide](../../testing/playground/README.md) for browser authoring. Record the JCB/Joomla/PHP versions, consumer component, source/read branch, insertion slots, expected output and all dependencies. Work in an authorized disposable site or preserve existing source before editing. Follow the [source/evidence receipt](../evidence/custom-code.md); its pinned implementation baseline is not an installation requirement.

## Create, use and maintain the block

1. Open **Component Builder → Custom Codes**. Search existing blocks before creating another; reuse unchanged source deliberately, or give an independent adaptation a new name. Inspect **Used In** and the actual consumer records before changing a shared block.
2. Choose **JCB (manual)** (`target=2`). Set **System Name**, a human-facing label used in the system, and **Function Name**, the unique reusable-block key across this JCB installation, not merely within one component. Check the current instance and intended package sources for collisions. Keep an established Function Name for the same block; rename only with an inventory and coordinated update of callers. Local numeric record IDs are not portable identities.
3. Put the source in **Custom Code**, without a PHP opening tag when the receiving slot is already PHP. The slot determines scope, available variables and services. A method-body fragment is not automatically valid as class members, JavaScript or markup. Keep the record published; the inspected manual lookup loads published manual records.
4. Save and reopen. Verify the name, target, state and source survived. Copy the invocation into the intended JCB code field, enabling that field's code option where required. Save/reopen each consumer. Do not substitute an edit to the generated component for this authoring step.
5. Compile the actual consumer, retain the exact ZIP and inspect the generated location. Confirm the intended expansion and absence of unresolved `CUSTOMCODE` or `[[[argN]]]` tokens. Check surrounding syntax, escaping and dependencies, then install and exercise the affected behaviour. Use [GUI tracing](debug.md#trace-a-gui-code-field) when the receiving location is unclear; tracing markers are not invocation placeholders.
6. To maintain the feature, edit the source block in JCB and recompile. Previously generated/installed copies do not update themselves. Check every affected caller, especially when changing an argument's meaning/order. Publish/export only within the task's authorized destination and verify the exported dependency graph and clean consumer, following [delivery](../../workflows/delivery.md).

## Exact argument contract

```text
[CUSTOMCODE=customCode]
[CUSTOMCODE=customCode+value1,value2]
```

Values replace `[[[arg0]]]`, `[[[arg1]]]`, and so on in the code body. Number arguments consecutively from zero; five expected values end at `[[[arg4]]]`. Every invocation must supply the full expected count in the correct order. Do not assume the compiler reliably rejects missing or surplus values: inspect the generated result and validate the caller contract yourself. For complex structured data prefer a real class/function API rather than a fragile string protocol.

The following names are teaching examples, not reserved identities. Check uniqueness before creating them.

### No arguments

Code for `exampleAuditComment`:

```php
// Audited by the component's maintained JCB source.
```

Place `[CUSTOMCODE=exampleAuditComment]` in two suitable PHP code slots. Each generated location should contain that comment. Change the comment once, recompile, and verify both locations changed.

### One argument

Code for `exampleAreaComment`:

```php
// Area: [[[arg0]]]
```

`[CUSTOMCODE=exampleAreaComment+administrator]` expands to:

```php
// Area: administrator
```

### Two arguments and different consumers

Code for `exampleLabel` in a PHP method-body context:

```php
$label = '[[[arg0]]]';
$limit = [[[arg1]]];
```

Calls and expected emitted source:

```text
[CUSTOMCODE=exampleLabel+Orders,10]
[CUSTOMCODE=exampleLabel+Invoices,25]
```

```php
// First consumer:
$label = 'Orders';
$limit = 10;
// Second consumer:
$label = 'Invoices';
$limit = 25;
```

These deliberately use trusted, simple literal inputs. The block's contract requires a PHP-string-safe first value and an integer literal second value. Substitution does not quote, validate or sanitize the values. Never put untrusted input into generated source. Adapt the block to the receiving language and avoid variable collisions in real consumers.

### Reserved argument characters

Encode these characters in the **argument value**, not the invocation's structural delimiters:

| Literal | Encoding |
| --- | --- |
| `[` | `&#91;` |
| `]` | `&#93;` |
| `,` | `&#44;` |
| `+` | `&#43;` |
| `=` | `&#61;` |

Each encoding has one terminating semicolon. For the one-argument comment block above:

```text
[CUSTOMCODE=exampleAreaComment+&#91;a&#44;b&#93;&#43;c&#61;d]
```

Expected output:

```php
// Area: [a,b]+c=d
```

The parser separates arguments before decoding these reserved sequences. PHP quotes or JavaScript string syntax do not protect a literal comma from that parser. This encoding is **not** PHP/HTML/SQL/JavaScript escaping; both the placeholder protocol and the final receiving context must be correct.

## Nested blocks and reverse updates

A manual Custom Code may reference another manual Custom Code. For example, the source of `exampleOuterComment` can contain `[CUSTOMCODE=exampleAuditComment]` followed by another comment. Preserve both records and their dependencies, and inspect the final expansion. Do not reference the block inside itself. As authoring policy, prohibit indirect cycles too; comprehensive indirect-cycle rejection has not been established by the evidence.

Do not use manual Custom Code invocation placeholders inside IDE Hash automation blocks. Argument-bearing code must be maintained in the **JCB UI**, not reverse-updated from changes made to generated code in an external editor: substituted values cannot recover the original argument placeholders. The inspected compiler also selects non-reversible markers for certain dynamic `view`/`sview` placeholder cases. Do not infer reverse-update support merely because a generated block has comments. Read the [evidence](../evidence/custom-code.md) before relying on editor synchronisation.

## Existing Demo-backed reference

The [Files and images recipe](media-files.md#connect-the-owning-entity-and-uploader) supplies a real six-argument `vdmUploaderConfig` invocation. The November 10 UI inspection found that record using `[[[arg0]]]` through `[[[arg5]]]`, context placeholders and Joomla Power references; **Used In** listed **Look (demo-J6)** (`php_document`) and **Importer Area** (`php_view`). Inspect the actual current caller strings and acquire the complete feature, not merely this one record. The UI observation is not a compilation proof. Existing application scenarios remain legitimate exercises of the skills; Demo is a mechanism reference, not an exclusive permitted application.

## Troubleshooting

| Symptom | Check and recovery |
| --- | --- |
| Missing or unresolved block | Check exact Function Name, published state, manual target, acquired record and repository precedence; reopen persisted values. |
| Unexpanded arguments or wrong generated value | Count expected positions and supplied values; inspect ordering, encoded delimiters and final emitted text. Do not patch output as the fix. |
| Generated syntax error | Inspect receiving scope, quotes, variable names and delimiters; fix the authoritative block/caller and regenerate. |
| One consumer changed, another did not | Confirm both call the same block, both belong to the compiled artifact, and the new installer was actually installed. |
| Rename breaks consumers | Restore the old key or update every caller and dependency together, then recompile and test. |
| Export works locally but fails on clean import | Inspect nested Custom Code, placeholder and Power dependency acquisition. The component direct-child export does not automatically include every Custom Code record. |
| External editor changes do not reverse-update | Check argument/dynamic-placeholder restrictions; return the intended change to JCB UI without replacing argument tokens with one consumer's values. |

## Playground acceptance matrix

Run these checks on a disposable consumer through the workflow above and retain source records, caller locations, exact ZIP, emitted-code excerpts and installed results. Record each stage as passed, failed, blocked or not run; a plan or success toast is not a result.

| Case | Required proof |
| --- | --- |
| Zero, one and multiple arguments | Expanded code matches the paired examples in real consuming slots. |
| Shared change | Two callers change after editing one block and recompiling. |
| Different values | Two callers emit their respective values without leaking values between uses. |
| Reserved characters | All five characters decode as shown and generated syntax stays valid. |
| Nested reuse | Outer and inner blocks expand; both are retained in acquired source. |
| Invalid caller, isolated negative test | Wrong count/order and raw delimiters are identified; record actual compiler behaviour, restore valid source and recompile. |
| Self/cyclic reference | Review rejects it before production use; do not promise automatic cycle handling. |
| Rename and delivery | All references are updated, dependency graph retained and a clean imported consumer compiles. |
| Editor limitation | Argument tokens remain authoritative in JCB UI; no claim of unsupported reverse update. |

Hash automation has separate tests and is not a prerequisite for ordinary manual reuse. For actual results and outstanding stages see the [verification receipt](../evidence/custom-code.md).
