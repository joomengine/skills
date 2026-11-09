# Report an unsuccessful build outcome and improve the skills

**Project-owner policy, updated 9 November 2026.** These skills guide agents from a component request to a complete, stable, runnable Joomla extension ready for deployment on the agreed target, with maintainable JCB source and the requested deliverables. When following the skills does not produce that outcome, **create an issue in [joomengine/skills](https://github.com/joomengine/skills/issues)** describing the problem so maintainers can improve the instructions. This feedback loop is part of using the skills.

Report missing steps, incorrect guidance, unclear navigation, unsuitable defaults, version mismatches and practical blockers encountered during a real build. Report a guidance gap even when a workaround lets the current build finish. Identify the observed failure without waiting for certainty about its root cause; maintainers can determine whether the correction belongs in the skills, a dependency or both.

## Submit useful Skills feedback

1. Preserve the failing state and continue diagnosis using [the procedure below](#establish-what-failed). Continue independent work and supported recovery toward the requested extension; filing feedback is not a substitute for finishing the build.
2. Search the [Skills issues](https://github.com/joomengine/skills/issues) for the same failure. Add new, relevant reproduction evidence to a matching open issue; otherwise create a focused issue using [the build-outcome form](https://github.com/joomengine/skills/issues/new?template=skill-outcome.yml). Do not create duplicate reports merely because another task encountered the same known problem.
3. Include the requested outcome, Skills commit and document paths, actual environment, steps followed, expected and observed behavior, and the attempts that improved or failed to improve the result. Use a sanitized summary of a private prompt and the smallest synthetic reproduction. Name unknown values instead of inventing them.
4. Submit through available authorized GitHub tools as part of this reporting workflow; no separate routine confirmation is required for the sanitized Skills report. Verify the created issue or posted evidence and include its URL in the build handoff. If tracker write access is unavailable, provide the complete report and the issue link for submission, then continue work that can proceed.
5. Keep the build moving: repair maintained definitions or supporting source, regenerate and verify the affected behavior. Describe any remaining concrete blocker and the next action in the issue. Do not report successful deployment or restoration until the requested artifact actually works.

Keep each report actionable. Missing user credentials or an unanswered product choice alone does not call for a Skills issue; report when the guidance fails to discover, explain or handle that requirement. Feedback should improve the workflow for the next agent, not copy an entire session transcript into the tracker.

## Maintainer improvement loop

Use the issue to reproduce the failure, identify the responsible guide and correct the instructions, routing, example or supporting tool. Add a focused regression or acceptance case when it helps preserve the correction. Follow the revised path for the reported case, record the result and link the corrective PR in the issue. If a runtime dependency also needs a fix, retain the Skills issue for the agent-facing guidance and connect the upstream resolution when available. This turns real component-building experience into a progressively more complete skill set.

## Establish what failed

Use the module's acceptance procedure and the [shared Playground workflow](playground/README.md) to identify the last successful stage: repository discovery, payload fetch, persistence, refresh, compilation, installation or runtime. Distinguish a malformed candidate definition from a JCB defect, a browser/network restriction and a Playground compatibility problem. A failure in a candidate with unresolved dependencies does not by itself establish a compiler defect.

1. Preserve the exact candidate revision and relevant GUIDs; avoid resetting or overwriting the only failing specimen.
2. Reduce to the smallest component, record or action that still reproduces the failure. Record the actual selected repository, target, branch, enabled state and precedence, rather than merely the intended source.
3. Reproduce once from a known starting state. State whether the result is repeatable, intermittent, or occurred only once. Include Init versus Pull/Reset and fresh versus existing local records when relevant.
4. Record Joomla, JCB, PHP, browser and Playground build/provenance when available. A Playground failure is evidence for that WASM environment; report whether the same case was tried on native Joomla and the result. An unavailable comparison remains unrun.
5. Inspect the relevant generated files and error messages. If an editor patch helps diagnosis, retain its diff, return the fix to maintained source and reproduce after regeneration before describing it as a completed fix.
6. Search existing issues in the relevant tracker if accessible. Report an inaccessible tracker honestly; do not claim there are no duplicates without checking.

## Route upstream implementation defects separately

Skills feedback goes to `joomengine/skills`, including the instructions needed to recognize or recover from an upstream problem. **Upstream JCB issue submission remains human-led** under the 31 October 2026 policy: prepare a useful report for the [official JCB issue chooser](https://git.vdm.dev/joomla/Component-Builder/issues/new/choose); the human reviews and submits it. Do not access or probe that host from an agent. A Skills report does not authorize automatic cross-posting to another tracker.

For a defect confined to Playground's deployment, editor, persistence or WASM compatibility, identify that evidence and let the human decide whether to report it to [Playground](https://github.com/joomengine/playground/issues) instead of, or alongside, JCB. Keep the Skills issue focused on how the agent workflow should handle the problem, with clearly attributed links to any upstream reports. An upstream submission is not a prerequisite for reporting the Skills gap.

## Hand the human a complete upstream draft

Supply the actual values for the affected case, using these sections. This is a content checklist, not a request to create an issue full of unfilled placeholders.

| Section | Required information |
| --- | --- |
| Title | Concrete operation and unexpected result; avoid a guessed cause |
| Environment | Actual Joomla/JCB/PHP versions, browser/platform, Playground source/build and relevant adaptations when known; label unknown values |
| Starting state | Fresh or resumed site, relevant installed extensions, local item existence, repository type/provider/branch/order and dependencies |
| Reproduction | Numbered GUI actions or reproducible supported commands; smallest accessible candidate commit and GUIDs |
| Expected result | Exact field values, generated output or runtime behaviour and its supporting contract |
| Actual result | Observed error and incorrect state, including whether data was persisted or partially changed |
| Evidence | Sanitized error/log excerpt, relevant source/generated diff and screenshot or reproduction archive when useful |
| Verification | Passed, failed, blocked and unrun stages; affected versions and whether native comparison was attempted |
| Diagnosis or proposed fix | Separate established cause from a hypothesis; describe workaround limitations |

Never include access tokens, passwords, session-bound virtual URLs, provider keys, personal/private data or a whole database export merely to supply evidence. Deployment/share URLs describe configuration, not a copy of the current database or an authentication grant. Use public minimal fixtures or let the human decide how to supply private material. Check attached archives and screenshots before proposing them for upload.

For the upstream JCB draft, end the handoff with the official issue link and a clear request for the human to review, choose the appropriate template and submit. Keep the draft available in the user's requested channel. The human can return the issue URL for later correlation with a fix; verify it before recording the upstream issue as submitted.
