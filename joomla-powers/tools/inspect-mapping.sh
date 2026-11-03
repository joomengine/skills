#!/usr/bin/env bash
# Inspect one Joomla Power mapping; do not execute PHP or expand placeholders.
set -euo pipefail
if [[ $# -ne 3 ]]; then
	printf 'Usage: %s REPOSITORY GUID JOOMLA_MAJOR\n' "$0" >&2
	exit 2
fi
command -v jq >/dev/null || { printf 'jq is required\n' >&2; exit 2; }
command -v realpath >/dev/null || { printf 'GNU realpath is required\n' >&2; exit 2; }
root=$(realpath -e -- "$1")
guid=$2
target=$3
[[ -d "$root" && "$guid" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ && "$target" =~ ^[1-9][0-9]*$ ]] || {
	printf 'Expected an existing repository, lowercase GUID and positive Joomla major\n' >&2
	exit 2
}
confined_file() {
	local path
	path=$(realpath -e -- "$root/$1") || return 1
	[[ -f "$path" && "$path" == "$root/"* ]] || {
		printf 'Repository file escapes its root or is not regular: %s\n' "$1" >&2
		return 1
	}
	printf '%s\n' "$path"
}
index=$(confined_file index.json)
jq -e -s 'length == 1 and (.[0] | type == "object")' "$index" >/dev/null
entry=$(jq -ce --arg guid "$guid" '
	.[$guid] | select(type == "object") |
	select(.guid == $guid and (.name | type == "string") and
		.path == ("src/" + $guid) and
		.settings == ("src/" + $guid + "/item.json") and
		.jpk == ("Joomla---" + ($guid | gsub("-"; "_")) + "---Power"))
' "$index") || { printf 'Missing or incoherent Joomla Power index entry\n' >&2; exit 1; }
item=$(confined_file "$(jq -r '.settings' <<< "$entry")")
jq -e -s 'length == 1 and (.[0] | type == "object")' "$item" >/dev/null
jq -e --arg guid "$guid" --argjson entry "$entry" --argjson target "$target" '
	def version:
		if type == "number" then select(. >= 0 and floor == .)
		elif type == "string" and test("^(0|[1-9][0-9]*)$") then tonumber
		else empty end;
	if .guid != $guid or .system_name != $entry.name or
		(.description | type) != "string" or
		([.settings | type] | any(. != "object" and . != "array")) or
		(.settings | length) == 0
	then error("Invalid mapping fields or non-native/empty settings") else . end |
	[.settings[]] as $rows |
	if any($rows[]; type != "object" or (.namespace | type) != "string" or
		(.namespace | length) == 0 or ([.joomla_version | version] | length) != 1)
	then error("Invalid namespace/version row") else . end |
	[$rows[] | .joomla_version | version] as $versions |
	if ($versions | unique | length) != ($versions | length)
	then error("Duplicate version rows require an explicit authoring decision") else . end |
	([$rows[] | select((.joomla_version | version) == $target)][0] //
	 [$rows[] | select((.joomla_version | version) == 0)][0]) as $selected |
	if $selected == null then error("No exact or fallback mapping for target") else
	{
		guid: $guid,
		target: $target,
		mapping_version: ($selected.joomla_version | version),
		namespace: $selected.namespace,
		php_token: ("Joomla___" + ($guid | gsub("-"; "_")) + "___Power"),
		placeholders_pending: ($selected.namespace | contains("[[["))
	} end
' "$item"
