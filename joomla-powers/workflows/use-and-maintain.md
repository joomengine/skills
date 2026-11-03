# Use and maintain Joomla Power mappings

Start with the requested target versions, a known JCB instance or the [Playground setup](../../testing/playground/README.md), and the code location that needs Joomla functionality. Preserve credentials outside source and evidence.

1. **Choose an API.** Inspect the relevant Joomla capability and actual methods for the target. Prefer Joomla's supported services. Use dependency injection for stateful services; a JPK type hint is not an instance or container registration. Put application algorithms in a [Super Power](../../super-powers/SKILL.md).
2. **Discover existing mappings.** Use the [network workflow](../../standards/repository-network.md), then inspect `index.json` in `joomengine/joomla-powers` and additional authorized catalogues in their effective order. Search names and inspect the indexed `item.json`, description and target rows. Do not fetch hundreds of payloads when one index and a few candidates suffice. Record the actual host, branch and commit. Do not access `git.vdm.dev`.
3. **Acquire the needed records.** Configure repository target `2`. Use Init for missing mappings, Pull to intentionally refresh from a chosen source, or Reset for selected local mappings that must match remote source. Check the actual saved GUID, settings and namespace; Init is not a candidate refresh when the mapping already exists.
4. **Reference the mapping in maintained PHP.** Use the PHP JPK token, not the display spelling or an invented GUID. For the existing JText mapping, a JCB PHP code field can contain:

   ```php
   $label = Joomla___ba6326ef_cb79_4348_80f4_ab086082e3c5___Power::_('COM_CATALOG_AVAILABLE');
   ```

   Add `COM_CATALOG_AVAILABLE` to that component's maintained language source. In the generated consumer, expect the appropriate `use Joomla\CMS\Language\Text;` (or an alias) and a call through that identifier. Keep output escaping appropriate to the HTML, JavaScript or JSON context where the label is used.
5. **Author a missing mapping only when needed.** Reuse an existing GUID when the logical mapping is unchanged. For a distinct mapping, generate a system UUIDv4 and check every current core/additional index plus local unpublished mappings before accepting it. The Super Power/Field Type allocators do not scan the Joomla Power domain; do not use their success as this collision check. Create `src/<guid>/item.json` with the four contract fields, add the matching index entry and explain its mapping and target evidence in the READMEs. JCB GUI authoring followed by Push can generate this representation.
6. **Validate and integrate.** Inspect each mapping using the helper in [the example](../examples/README.md), then follow [acceptance](validate-and-integrate.md). Compile a real caller, confirm that the mapped symbol is available and exercise its behavior. Persist any fix in the item or source caller and recompile.
7. **Export only to an authorized destination.** For GUI export, configure the Joomla Power target, intended write branch and temporary host-specific token; inspect all effective writable destinations before Push. Verify the remote item and index, then reacquire from a fresh JCB installation. Keep Joomla Power mappings separate from the package and Super Power source formats; a component ZIP is not their editable source backup.

For same-item maintenance, retain the GUID and inspect all consumers affected by version-row changes. For a project-specific mapping that represents a different symbol or meaning, allocate a new GUID and update each referring JPK consistently. Do not update unrelated core mappings merely to satisfy one consumer.

If a mapping is missing, check local state, repository target/enabled state, branch, index path and effective source order. If a compiled class is missing, distinguish an unresolved token from an unavailable PHP implementation or autoloading problem. If a method fails, inspect API compatibility and calling context; changing the namespace map cannot fix every API change. Retain the exact failure and return to the authoritative layer.
