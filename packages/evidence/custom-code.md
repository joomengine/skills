# Custom Code evidence and verification boundaries

Inspected **2026-11-10**. Supports [manual Custom Code](../workflows/custom-code.md) and [Hash automation](../workflows/custom-code-automation.md). These focused additions do not regenerate the existing package field inventory.

## Authority

- **Project policy:** the maintainer's November 10 direction prefers manual reusable Custom Code and discourages Hash automation except as a last resort. Existing scenarios remain legitimate applications of the skills; Demo is a mechanism reference.
- **Implementation baseline:** `vdm-io/Joomla-Component-Builder`, `5.x`, commit `6e029bb3681379794fbe27ea299d834595d8a02f`. Source inspection is distinct from the live Joomla 6/JCB 6 UI observation below. Follow current production version policy and recheck target-specific behaviour before relying on this baseline for another release.

| Claim | Pinned source and symbols |
| --- | --- |
| Manual/automation targets, name/code/conditional location fields | [Custom Code form](https://github.com/vdm-io/Joomla-Component-Builder/blob/6e029bb3681379794fbe27ea299d834595d8a02f/admin/forms/custom_code.xml) |
| Function Name check across Custom Code table, excluding current record | [AjaxModel::checkFunctionName](https://github.com/vdm-io/Joomla-Component-Builder/blob/6e029bb3681379794fbe27ea299d834595d8a02f/admin/src/Model/AjaxModel.php#L4057-L4097) |
| Argument splitting/decoding, published/manual lookup, nesting and reversible-marker selection | [Customcode::set/get/buildPlaceholders](https://github.com/vdm-io/Joomla-Component-Builder/blob/6e029bb3681379794fbe27ea299d834595d8a02f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Customcode.php) |
| Exact usage note, arguments, restrictions and IDE markers | [CustomCode Readme Main](https://github.com/vdm-io/Joomla-Component-Builder/blob/6e029bb3681379794fbe27ea299d834595d8a02f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/CustomCode/Readme/Main.php) |
| Marker extraction, stored block and surrounding context | [Customcode Extractor](https://github.com/vdm-io/Joomla-Component-Builder/blob/6e029bb3681379794fbe27ea299d834595d8a02f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Customcode/Extractor.php) |
| Reinsertion/replacement, unmatched hashes, missing files and warning fallback | [Compiler::addCustomCode](https://github.com/vdm-io/Joomla-Component-Builder/blob/6e029bb3681379794fbe27ea299d834595d8a02f/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler.php#L1742-L1993) |

The inspected expansion path does not establish comprehensive argument-count rejection or indirect-cycle detection. Treat exact count/order and no cycles as authoring requirements, not promised compiler safeguards. `buildPlaceholders` also selects non-reversible markers for some dynamic `view`/`sview` and argument-placeholder cases; do not broaden the external-editor promise from a simple no-argument specimen.

## Live UI observation

Playground inspection on November 10 used **Joomla 6.2.0, JCB 6.2.0 and PHP 8.4.27**. No records were saved or changed. The existing `vdmUploaderConfig` record (local ID 397, not a portable identifier) showed separate System Name and Function Name, six argument placeholders `arg0`–`arg5`, context placeholders and Joomla Power references. **Used In** listed Look (demo-J6), `php_document`, and Importer Area, `php_view`.

The visible manual help matched the invocation syntax, zero-based argument/count rule, five delimiter encodings, nesting exclusions and argument-bearing reverse-update restriction. Switching unsaved target/type controls exposed the automation version/component/path, insertion/replacement, zero-based line and hash fields; the form was closed without saving. Both start/end hash controls displayed an “End Hash Target” label in this UI, so the skills use source semantics rather than treating that duplicated label as authority. The exact browser version was not recorded.

## What is and is not proven

| Stage | Result and limit |
| --- | --- |
| Source review | Relevant paths inspected; establishes the cited implementation, not all releases. |
| Live UI | Fields/help and one existing six-argument record observed; consumer call strings were not compiled in this review. |
| New paired examples | Teaching examples with expected source output, not claimed as installed runtime evidence. |
| Manual compilation/runtime matrix | **Not run** for these additions. Follow the [acceptance matrix](../workflows/custom-code.md#playground-acceptance-matrix). |
| Hash extraction, repeated compile and failure recovery | **Not run**; source-backed procedure is not a runtime pass. |
| Clean-source export/import/rebuild | **Not run** for Custom Code here; automation identity mismatch remains open evidence. |

Repository link/static regression checks establish skills consistency only. Record their actual command results in the change/PR; they cannot substitute for the unrun integration stages above.
