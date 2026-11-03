# Fresh-agent Notes administrator exercise

**Observed 3 November 2026.** A fresh agent received the skills checkout and a request for a small Joomla 6 Notes component built through JCB: administrator list/edit, a required title limited to 120 characters, and create/edit/delete. This was a narrower request than [Note Desk](../../examples/note-desk.md): no public pages, body Field, published/access filtering or SEF routes were requested. The full Note Desk acceptance table remains unrun.

## Inputs and maintained source

The agent followed the root/model/Playground guides and used a separate disposable site. The site displayed Joomla **6.2.0** and JCB **6.2.0**; deployment reported PHP **8.4.27**. The distribution evolved during the exercise, so its initial Git HEAD alone does not attest every document read. This is a development exercise, not certification against a frozen distribution.

Dynamic discovery selected advertised online Codeberg mirrors. The inspected Packages revision was `4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9`; Field Types was `3be64d59378b5650825b97b44dbd58f2cdb82fcb`. No Codefloe node was advertised in that response. The excluded internal host was not accessed. Existing concrete Name Fields and larger demo views differed from the request, so the agent reused the core Text type unchanged and authored the needed concrete records through JCB.

| Record | Saved identity and relevant values |
| --- | --- |
| Text Field Type, unchanged | `201327fe-3067-4316-a155-3fe2a52e05c0` |
| Notes Title Field | `d4b53ad4-5609-4fb6-a176-04ffe034088b`; `title`, required, `maxlength=120`, `filter=STRING`, `validate=notetitle`, `VARCHAR(120)` |
| Validation Rule | Natural key `notetitle`; inherited regex members shown in the [Field guide](../../packages/models/fields-and-relationships.md#enforce-length-on-the-server-as-well-as-the-form) |
| Note/Notes Admin View | `1b7ea6ba-4552-4c6a-8ff3-79467a3338e6`; saved Admin Fields association supplies title/list/search/sort/link roles |
| Component | `399f308c-8ec6-444d-9002-a5891d211cf2`; visible name Notes, final code name `notesdesk`, version `1.0.0`, namespace prefix `NotesProject` |

The first `com_notes` build compiled and installed, but its `notes` list route opened the standard dashboard: the component and list-view names collided. The agent corrected the maintained component code name to `notesdesk`, recompiled and installed. The final tests below apply to that corrected build. No generated application file was patched to repair the route.

## Observed results

| Stage or case | Result |
| --- | --- |
| Saved JCB records and associations | Passed; records reopened and relationship values read back |
| Corrected component compilation and installation | Passed; installed Notes list and edit form rendered |
| Create and reopen | Passed with a 120-character ASCII title; reopened value retained all 120 characters |
| Edit and persistence | Passed after saving the changed title `Notes edit verified` |
| Delete | Passed through trash and permanent deletion; success notice and empty list observed |
| Empty title through ordinary form | Rejected by required-field UI validation |
| Oversized ordinary input | A 121-character fill was clipped to 120 before save; this is browser behaviour, not a server rejection |
| Invalid input sent beyond browser validation | **Blocked**: the Code file chooser hung while uploading a separate diagnostic PHP probe; no upload or probe execution result was confirmed |
| Generated package inspection | Passed ZIP integrity, five XML parses, manifest references, title XML/rule/schema, namespace declarations, distinct dashboard/list routes and unresolved-token checks |
| Generated PHP lint | All **101 PHP files passed** on local PHP **8.3.6**, separately from the installed browser runtime |

The package contains the intended `validate="notetitle"`, rule class/namespace, regex members and `VARCHAR(120)` schema. That inspection does not replace the blocked server-request boundary test. The file-chooser operation was stopped after hanging; it must not be represented as successful server validation.

## Retained output and limits

The actual compiler ZIP was downloaded through the Code file-download dialog after the embedded compiler link failed to yield a browser download:

- File: `com_notesdesk_v1_0_0__J6.zip`
- Size: **255,452 bytes**, 179 archive entries
- SHA-256: `d5ca76262261ce2488b44855538c5dc8cc7819a3d53dbeca003fd2d9b7b60d60`

The ZIP and local inspection logs were retained for this execution; they are not a published blueprint or a community-ready application release. No source Push, repository reimport, fresh-site rebuild, complete-site restoration, public/API behaviour or lower-privilege acceptance was performed. The task proves the named administrator authoring/compile/install/CRUD slice and identifies a remaining validation gap; it does not certify all application scenarios.
