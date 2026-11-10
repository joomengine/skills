# Hash automation: exceptional generated-code overrides

**Project policy: discouraged, last resort only.** Manual [Custom Code reuse](custom-code.md) is the preferred reusable-block feature. Hash automation is available for a concrete requirement that cannot be met through normal JCB configuration, supported code fields, Powers or maintained compiler extension points. Record the alternatives considered and the reason for the exception. It shifts maintenance back to the developer and must not become the normal way to build a component.

Read the [model's identity and export/import limits](../models/code-and-placeholders.md#hash-based-automation-is-a-distinct-path) and the [source evidence](../evidence/custom-code.md). This workflow does not claim an arbitrary automation record is portable or that an override will always survive compiler changes.

## Mechanism and inputs

`target=1` (**Hash (automation)**) differs from manual `target=2`. It carries Joomla version, component, target file path, insertion/replacement type, comment style, zero-based line positions and surrounding-code hashes. The extractor discovers marked edits in installed component source and stores the block and surrounding location evidence. On subsequent compilation JCB tries to locate the corresponding generated region and insert/replace the block there.

Use an authorized disposable component installed on the **same Joomla instance as JCB**, and back up its blueprint, installer and installed source. The extractor scans local installed paths; editing a separate deployment or an uninstalled ZIP does not supply that local source. Record the exact JCB/Joomla/PHP target, file, current surrounding lines and intended behaviour. Do not fabricate hashes or line offsets, edit unrelated files or silently convert a manual block into automation. `HASHSTRING`/`HASHFILE` substitution is a different feature; `Compiler/Customcode/Hash.php` is not the automation insertion engine.

## Controlled authoring and recovery

1. First attempt the normal JCB authoring path. If an exception remains justified, inspect the current Custom Codes IDE help and extractor/reinjection source for this target. Treat the following syntax as source/UI-supported, not an independently runtime-tested example.
2. For PHP/JS comment contexts, JCB's help shows new insertion or replacement blocks:

```text
/***[INSERT<>$$$$]***/
<YOUR CODE HERE>
/***[/INSERT<>$$$$]***/

/***[REPLACE<>$$$$]***/
<YOUR CODE HERE>
/***[/REPLACE<>$$$$]***/
```

Use only the appropriate operation and valid code in its actual receiving scope. For HTML use the current UI's HTML-comment variant, not PHP comments pasted blindly into markup. Do not put manual `[CUSTOMCODE=...]` invocations inside IDE automation blocks.

3. In **Component Builder → Compiler**, select that component and compile it again after the marked installed-file edits. In the inspected source, `Initializer::init()` calls `extractCustomCode()` before building the component; it invokes `Extractor::run()` over existing local paths from `Extractor\Paths`. This is the extraction trigger, not a separate Custom Codes Save action. Recheck this lifecycle for the installed release; do not invent a separate enable flag or confuse **Add Custom Code Placeholders** (output tracing/markers) with the scan trigger. Inspect the resulting Custom Code record before relying on it: target, component, Joomla version, path, operation, extracted body and boundary metadata must match the intended edit. If no record is captured, stop and diagnose the scan location/configuration; a surviving editor change is not proof of extraction.
4. JCB writes tracking markers back using `INSERTED`/`REPLACED` and the Custom Code record ID. For subsequent updates preserve that ID and use the current UI's existing-block syntax. Never invent or change the ID outside JCB. The exact marker lifecycle must be checked on the target before claiming reverse synchronisation works.
5. Compile again from the maintained state and inspect the **new installer**, not the old installed edit. Verify exactly one intended insertion/replacement, correct surrounding code, valid syntax, no unintended duplicate block and no compiler warnings. Install on a clean consumer and exercise the behaviour.
6. If the start/end hash no longer matches, the inspected compiler preserves code in a commented/escaped fallback and warns; a missing target file also causes a warning. Do not call that a successful override. Retain the warning and artifacts, compare old/new generated context, then re-establish the override through the supported workflow or return to native authoring. Never silence the warning by guessing hash values.
7. Before delivery, export/import into a separate site and verify record identity, target and a fresh rebuild. The inspected path-derived automation index identity versus `function_name` bucket/import identity remains a specific round-trip gap. If that cannot be demonstrated, disclose the limitation and do not claim portable delivery.

## Acceptance and maintenance

Test insertion and replacement separately, on a disposable consumer. Retain pre/post source and installer evidence, then perform a second compilation and verify persistence and no duplication. Test a controlled surrounding-context change and missing-target case to confirm actual warnings/recovery, without corrupting the maintained application. Test export/import independently of local regeneration. Record all unrun stages.

Recheck overrides whenever JCB/compiler output or the target Joomla version changes. Keep the smallest justified override, a clear owner and regression case. Prefer retiring it in favour of a normal JCB mechanism when one becomes available. The live inspection recorded in [evidence](../evidence/custom-code.md) observed UI fields and help only; it did not execute this automation workflow.
