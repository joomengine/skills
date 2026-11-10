# Build and translate every user-facing language string

Use this workflow for multilingual Site Views, Templates, Layouts, Custom Code and other JCB code areas. It covers **authoring → compilation and collection → language setup → filtering and export → translation → import → recompilation and installed verification**. None of these stages substitutes for another. For reusing the importer's implementation in another application, follow [translation importer internals](translation-import.md) separately.

**Project policy:** make every authored interface string translatable, including headings, paragraphs, button/link text, prompts, validation messages, tooltips and accessible labels. Wrap source text in Joomla's `Text::_()` or its Text Joomla Power reference. Do not postpone this until someone requests a second language. This translates extension interface strings, not arbitrary user-entered database content, and it does not supply machine translations automatically.

## Inputs and evidence

Start with an authorized component/source graph, its actual consuming views/layouts, source language, target language tags and a disposable [Playground](../../testing/playground/README.md). Record current JCB/Joomla/PHP versions under the [version policy](../../standards/version-policy.md), component identity and source revision. Preserve the existing blueprint and a current translation export before changing shared strings or importing translations. Use synthetic text for a first exercise.

The [evidence receipt](../evidence/language-strings.md) identifies pinned compiler/UI sources, observations and unrun cases. Source evidence is not a guarantee that all quoted-text forms or every installed release behaves identically. Follow the acceptance sequence below on the actual target.

## 1. Author the source text in JCB

In HTML, keep markup outside the language string and echo translated text **inside** the markup:

```php
<button type="submit">
	<?php echo htmlspecialchars(Joomla___ba6326ef_cb79_4348_80f4_ab086082e3c5___Power::_('Save changes'), ENT_QUOTES, 'UTF-8'); ?>
</button>
<p><?php echo htmlspecialchars(Text::_('Your changes are ready'), ENT_QUOTES, 'UTF-8'); ?></p>
```

The Text JPK is `Joomla___ba6326ef_cb79_4348_80f4_ab086082e3c5___Power`. Use the installed mapping; its catalogue display spelling is not PHP syntax. In a PHP-only code field, do not insert another `<?php ... ?>` pair:

```php
$message = Joomla___ba6326ef_cb79_4348_80f4_ab086082e3c5___Power::_('Your changes are ready');
```

Keep `'<button>Save changes</button>'` out of the translation call. HTML structure belongs to the view/template/layout, while translators receive plain wording. For an HTML attribute such as `title` or `aria-label`, translate its value and escape it for the attribute context. The examples use `htmlspecialchars` for HTML output; translating text is not output escaping. PHP-only values need escaping at their eventual output boundary, not an unconditional HTML transformation.

Ensure the Text class is imported **in each generated PHP file**. A JPK occurrence makes JCB acquire/resolve that mapping and add the import; subsequent calls in that file may use `Text::_()`. Some compiler templates already supply the import, so reuse it when confirmed. One token elsewhere in the component does not establish imports in all separately generated files. Inspect the final class name/alias if the file has a naming conflict.

A PHP comment can provide the JPK reference without an unnecessary runtime call:

```php
// Resolve Joomla's Text class for this generated PHP file.
// Joomla___ba6326ef_cb79_4348_80f4_ab086082e3c5___Power
$label = Text::_('Save changes');
```

The inspected Power scanner searches raw source, including comments. Preserve the full token until compilation, then verify its replacement and the generated import. In an HTML field this must be a PHP comment inside an existing or appropriate PHP block, not visible page text. Use an active JPK call when the comment route has not been verified in the target slot.

### Literals, quotes and dynamic values

Use complete literal source strings, not runtime variables or concatenated sentence fragments that the compiler cannot collect as a sentence. Prefer an uncomplicated quote delimiter:

```php
$message = Text::_("Don't close this page");
$instruction = Text::_('Choose "Save" to continue');
```

Escape quotes/backslashes as PHP requires, but do not equate valid PHP with successful JCB extraction. **Known source limitation:** the inspected extractor splits on the closing quote without recognizing backslash-escaped quotes. Consequently `Text::_('Don\'t close this page')` can be valid PHP yet be collected incorrectly. Prefer the opposite delimiter for the examples above; for mixed quotes, backslashes or other special characters, compile a probe and check the complete generated value before adopting the form. Do not silently change the intended wording or claim every escaped form is supported.

For variable data, use a supported complete format string such as `Text::sprintf('Saved %s items', $count)`, preserving formatting placeholders in translations. Check this form on the target separately from the basic `_()` case. JavaScript language registration/lookup is another context; follow the actual `Text::script`/`Joomla.Text._` support rather than emitting PHP calls into a static JavaScript file. Existing Joomla language keys remain legitimate when intentionally reusing a defined key; manually inventing `COM_...` keys is not the default route for new plain-text strings.

Save/reopen the owning JCB records. For a [reusable Custom Code block](custom-code.md), retain the Text calls in its maintained source: expansion is followed by language extraction. Do not replace source literals with one build's generated keys merely to make the source look compiled.

## 2. Compile, inspect and collect

1. Compile the component that actually consumes the changed Site View, Template, Layout or Custom Code. A disconnected record is not an extraction test. Retain the exact installer ZIP and compiler messages.
2. Inspect each generated PHP file: confirm the import, resolved class reference, component-prefixed language key and absence of unresolved JPK tokens. Lint PHP containing the quote-sensitive examples.
3. Inspect the matching generated language entry. For source `Save changes` and prefix `COM_DEMO`, the expected normal-case pair is:

   ```php
   Text::_('COM_DEMO_SAVE_CHANGES');
   ```

   ```ini
   COM_DEMO_SAVE_CHANGES="Save changes"
   ```

   Check the actual generated key rather than guessing it for punctuation, collisions or nontrivial text. Verify the **whole** wording, especially quotes and special characters, not merely that an INI file exists.
4. Open **Component Builder → Language Translations** and find that exact source. Compilation collects source records and associates them with the relevant extension; the same source can be reused across extensions. Confirm that the correct component can find the row and that site/administrator language placement matches the consumer.
5. If a row or generated entry is absent, first check that the record is connected and enabled, the literal call syntax is recognized, and the compile completed. Correct JCB source and recompile; do not patch the installer as the maintained solution.

## 3. Prepare the destination languages

Open **Component Builder → Languages**. Check the exact tags needed, such as `af-ZA`, `fr-FR` or `zh-CN`; a language name alone is not an import mapping. The **Build** action synchronizes installed Joomla languages into JCB. Publish the desired JCB language records, then verify they appear as destination columns in the export. The columns are based on **published JCB language records**, not simply every installed Joomla language pack.

The source is normally English but is configurable. Keep the spreadsheet's `Source` column as the unchanged source identity, not a place to overwrite English with a translation. Installing a language on the consumer site and selecting that language for runtime testing are separate from preparing JCB's translation columns.

## 4. Select the translation set with filters

In **Language Translations**, clear stale filters, then choose the intended extension and language scope. Check the visible source rows before exporting. The relevant controls have distinct jobs:

- **Extension:** choose the component, module or plugin whose collected strings you need. Component associations come from compilation, not a guessed `COM_...` prefix search. For a multi-component solution, identify each extension explicitly.
- **Translated in:** select a language to inspect already translated strings, or **Every Language** to request those translated in all published JCB languages. This is useful for review or revision work.
- **Not translated in:** select a language for its untranslated work, or **Any Language** for strings with no translations. It does not mean “missing at least one language.” Clear a conflicting Translated/Not translated selection when the result becomes empty.
- **Search:** find source or stored translation text; `id:<number>` selects a local record ID in the inspected list model. It is a list diagnostic, not a portable string identity.
- **Status** and **Access:** constrain the administrative list by publication/access. If a known row disappears, clear these deliberately and check permissions instead of making a duplicate source row.
- **Ordering**, direction and page limit control list presentation. A page of 25 rows is not proof that the export contains only those rows. Checked rows are not established as the export scope either.

**Export scope is version-sensitive.** In the pinned implementation the export action forwards only Extension, Translated in and Not translated in; it loads published translation records. Search, list status/access, ordering, pagination and row selection are not sent as export selectors. Moreover, that exporter combines nonempty filter ID sets by union, while the list applies separate conditions. Do not promise that a combined filter exports exactly the visible intersection. Inspect the workbook's source rows before translating or sharing it; for a strict component-only batch, export with only that Extension selected and verify/narrow the workbook to the intended source set. If the target release differs, record the observed behaviour rather than copying this caveat as a universal implementation claim.

## 5. Export and translate the workbook

1. Use **Export** in Language Translations with the intended scope. This exports actual stored strings; the importer's **Example** download supplies a template and is not a substitute for exporting the component's collected text.
2. Open the downloaded workbook. Verify the Source header, language-tag columns, row count and representative included/excluded strings against your task. If scope is broader than expected, stop before sharing it and correct the batch. Keep an unchanged original for comparison/recovery.
3. Translate only the intended destination cells. Preserve Source values exactly, including punctuation and whitespace, and retain the header/tag spelling. Source is the import matching key; changing it can create or target a different record.
4. Preserve `%s`, `%d`, numbered format placeholders and other deliberate tokens with their required meaning. Translate complete phrases rather than rearranging code or injecting HTML. Use literal text cells, not formulas. Retain Unicode correctly for languages such as Chinese or Russian; do not replace characters with language-file escape sequences merely because the eventual output is INI.
5. Keep existing language columns and values in the current export when updating translations. Do not assume that removing columns or leaving blanks means “preserve everything”; inspect the target importer's semantics and saved records. Use the latest export to reduce overwriting newer work. Keep the source and mapping sheet unambiguous; active-sheet and first-sheet differences are a known importer check.

## 6. Import, map and verify persisted translations

1. Open **Language Translations → Import**. Review the target's help and supported formats. The inspected UI advertises CSV, XLSX, XLS, ODS and Gnumeric; validate the format actually used rather than claiming all have been tested.
2. Select/drop the reviewed workbook. This uploads immediately and opens column mapping; it is not yet proof that translations were saved. Use the intended site/session and inspect the returned file/mapping preview.
3. Map Source to the source identity and every intended language column to its matching language tag. Check missing, duplicate or automatically misidentified mappings. Do not map an English source column as a destination translation or rely solely on matching header capitalization.
4. Run the mapping form's **Import/Apply** action (label depends on the target). This importer applies immediately, not through the Demo queue. Capture the result, warnings and failed rows; a success message alone does not establish that every row succeeded.
5. Return to Language Translations. Search for representative source rows, open them and verify exact saved destination values. Check both a newly supplied translation and an update, plus an unrelated existing language to establish preservation. Re-export the relevant scope and compare values if useful. Do not infer deletion/preservation behaviour from blank or omitted cells without this check; the deeper [importer skill](translation-import.md#source-specific-troubleshooting) records the implementation questions.
6. If mapping, row results or saved data disagree, stop before recompilation/publication. Correct the workbook/mapping and retry only understood failed work, or restore affected values from the retained export. Match by Source, not spreadsheet row number or JCB local ID. Repeating an import is a data change, so inspect its effect instead of assuming every retry is harmless.

## 7. Recompile and verify the multilingual component

Recompile the same maintained component after the translations are saved. Review messages for each language's inclusion/exclusion. JCB has a configurable **translation percentage threshold**: a partly translated language may be intentionally omitted. Inspect the current setting and completeness, rather than assuming a default percentage or changing it merely to hide an incomplete translation.

Inspect the exact new ZIP's source and translated INI files, paths and manifest, including relevant site/administrator clients. Compare the emitted values with the imported text and confirm the source language still works. Install that ZIP in a clean consumer, enable/select the destination language, and exercise the actual pages, buttons, prompts and validation paths. Confirm no raw keys, hard-coded source-language leftovers, missing imports, broken quotes or HTML appear. Test at least the source language and one non-source language; test additional scripts/layout directions where the task requires them.

A correct import does not update an already installed component by itself. Compilation and installation are distinct stages. Make all lasting corrections in JCB authoring/translation records, regenerate, and retain the blueprint, workbook and installer identities with the [delivery evidence](../../workflows/delivery.md).

## Acceptance and troubleshooting

Use a bounded Demo consumer or another authorized scenario, without treating the scenario as a universal business model. Include one Site View, Template, Layout and reusable Custom Code block; cover a button, plain PHP message, active JPK and comment-only JPK where imports are not already supplied. Use an apostrophe and a double-quoted phrase, and inspect complete extracted values. Then execute every stage above with two target-language columns: export actual collected strings, verify filter scope, update one translation, preserve another, import, recompile and test the installed result.

- **Text class unavailable:** inspect that generated file's import/alias and whether the JPK survived into compiler processing; a token in another file is not enough.
- **Plain English never collected:** inspect literal wrapping, supported slot, enabled consumer and compiler outcome; translation does not discover arbitrary HTML or runtime variables.
- **Truncated or broken quotes:** fix the source literal form and inspect PHP plus INI; PHP lint alone does not test extraction.
- **Export contains unexpected rows:** distinguish list filters from the export selectors and check combined-filter behaviour before sharing or translating.
- **Destination column missing:** inspect published JCB Languages and tag spelling, not only installed Joomla language packs.
- **Import reports success but text is wrong:** inspect mapping, sheet, per-row results and persisted values before retrying.
- **Translation saved but omitted from ZIP:** inspect threshold/completeness, extension association, client and compiler messages.
- **ZIP correct but interface untranslated:** verify the installed artifact, active consumer language, relevant client language file and every authored UI string.

Record the exact evidence and unrun stages in the [receipt](../evidence/language-strings.md). An observed screen or static check is not a completed spreadsheet round trip or runtime pass.
