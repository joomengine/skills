#!/usr/bin/env bash
# Offline acceptance for the mapping inspector, not JCB runtime certification.
set -euo pipefail
module=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d "${TMPDIR:-/tmp}/jcb-jpk-tests.XXXXXX")
trap 'rm -rf -- "$work"' EXIT
repo="$work/repository"
guid=ba6326ef-cb79-4348-80f4-ab086082e3c5
item="$repo/src/$guid/item.json"
count=0
reset_fixture() {
	rm -rf -- "$repo"
	cp -R -- "$module/examples/reference-repository" "$repo"
}
change_item() {
	jq "$1" "$item" > "$work/changed.json"
	mv -- "$work/changed.json" "$item"
}
inspect() {
	bash "$module/tools/inspect-mapping.sh" "$repo" "$guid" "$1"
}
pass() { count=$((count + 1)); printf 'PASS %s\n' "$1"; }
reject() {
	if inspect "$1" > "$work/result.json" 2> "$work/error.txt"; then
		printf 'FAIL accepted %s\n' "$2" >&2
		exit 1
	fi
	pass "$2"
}
reset_fixture
inspect 6 | jq -e '.mapping_version == 0 and .namespace == "Joomla\\CMS\\Language\\Text" and .placeholders_pending == false' >/dev/null
pass 'canonical fallback'
change_item '.settings.settings1 = {namespace: "Example\\Target\\Text", joomla_version: 6}'
inspect 6 | jq -e '.mapping_version == 6 and .namespace == "Example\\Target\\Text"' >/dev/null
pass 'exact target precedes fallback'
inspect 5 | jq -e '.mapping_version == 0' >/dev/null
pass 'other target retains fallback'
change_item '.settings |= [.[]]'
inspect 6 | jq -e '.mapping_version == 6' >/dev/null
pass 'native array rows'
reset_fixture
change_item '.settings.settings1 = {namespace: "Example\\Other\\Text", joomla_version: 0}'
reject 6 'numeric/string duplicate versions'
reset_fixture
change_item '.settings.settings0.joomla_version = "5"'
reject 6 'missing exact and fallback'
reset_fixture
change_item '.settings |= tojson'
reject 6 'encoded settings'
reset_fixture
change_item '.settings.settings0.namespace = ""'
reject 6 'empty namespace'
reset_fixture
change_item '.guid = "39403062-84fb-46e0-bac4-0023f766e827"'
reject 6 'item identity mismatch'
reset_fixture
printf '\n{}\n' >> "$item"
reject 6 'multiple JSON documents'
reset_fixture
change_item '.settings.settings0.namespace = "[[[NamespacePrefix]]]\\Component\\[[[ComponentNamespace]]]\\Site\\Helper\\[[[Component]]]Helper"'
inspect 6 | jq -e '.placeholders_pending and (.namespace | contains("[[[NamespacePrefix]]]"))' >/dev/null
pass 'compiler placeholders preserved'
reset_fixture
cp -- "$item" "$work/outside.json"
rm -- "$item"
ln -s -- "$work/outside.json" "$item"
reject 6 'item symlink escaping repository'
reset_fixture
jq --arg guid "$guid" '.[$guid].jpk = "Joomla___incorrect___Power"' "$repo/index.json" > "$work/index.json"
mv -- "$work/index.json" "$repo/index.json"
reject 6 'incorrect display key'
printf '%s mapping inspector checks passed; JCB integration not run.\n' "$count"
