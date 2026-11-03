# Complete Joomla Power reference example

The [reference repository](reference-repository/README.md) contains the existing official JText item and matching index. Its GUID belongs to that canonical mapping; it is not a newly allocated identity.

From the skills distribution root, with Bash, jq and GNU realpath available:

```bash
bash joomla-powers/tools/inspect-mapping.sh \
  joomla-powers/examples/reference-repository \
  ba6326ef-cb79-4348-80f4-ab086082e3c5 6
bash joomla-powers/tests/run-mapping-tests.sh
```

The first command reports `Joomla\CMS\Language\Text`, selected fallback version `0`, the PHP token and `placeholders_pending: false`. It reads index/item JSON without running PHP, contacting a server or changing the repository. It checks only the selected entry and mapping, not every catalogue record or global identity uniqueness. It rejects malformed JSON, incoherent identity/paths/display key, encoded settings, empty namespaces, duplicate numeric version rows and a missing matching/default row. Exit `0` means inspection succeeded; nonzero means invalid input or no mapping. It retains placeholders verbatim and reports them as pending; actual values belong to compiler context.

Use the inspected token in the [caller example](../workflows/use-and-maintain.md), then complete [integration acceptance](../workflows/validate-and-integrate.md). The expected generated PHP import is an acceptance assertion, not a recorded compilation result.
