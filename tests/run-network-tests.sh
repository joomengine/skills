#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
passed=0
expect() {
	local expected=$1 label=$2 status=0; shift 2
	("$@") > "$work/output" 2> "$work/error" || status=$?
	if [[ $status != "$expected" ]]; then
		printf 'FAIL: %s (expected %s; got %s)\n' "$label" "$expected" "$status" >&2
		cat "$work/output" "$work/error" >&2; exit 1
	fi
	passed=$((passed + 1)); printf 'PASS: %s\n' "$label"
}
edit() { jq "$2" "$1" > "$work/edit.json"; mv "$work/edit.json" "$1"; }
# Deliberately synthetic data; these hosts and statuses are never probed.
jq -n '{project:"jcb", targets:[{target:"future-model", network:[
	{id:1,name:"other online",url:"https://other.example/team/repo",status:1},
	{id:2,name:"blocked online",url:"https://git.vdm.dev/joomla/repo",status:1},
	{id:3,name:"preferred offline",url:"https://codefloe.com/joomla/old",status:0},
	{id:4,name:"codeberg online",url:"https://codeberg.org/joomla/repo",status:1},
	{id:5,name:"codefloe online",url:"https://codefloe.com/joomla/repo",status:1},
	{id:6,name:"blocked normalized",url:"https://GIT.VDM.DEV:443/joomla/repo",status:1},
	{id:7,name:"blocked subdomain",url:"https://backup.git.vdm.dev/joomla/repo",status:0},
	{id:8,name:"other offline",url:"https://other.example/team/old",status:0}
]}]}' > "$work/project.json"
expect 0 'New target names work without a registry update' bash "$root/tools/network-candidates.sh" "$work/project.json" future-model
cp "$work/output" "$work/online.json"
expect 0 'Online selection excludes blocked hosts and prefers advertised Codefloe then Codeberg' jq -e 'map(.id)==[5,4,1]' "$work/online.json"
expect 0 'Recovery selection accepts offline nodes explicitly' bash "$root/tools/network-candidates.sh" "$work/project.json" future-model --include-offline
cp "$work/output" "$work/recovery.json"
expect 0 'Healthy alternative precedes preferred offline host and blocked hosts remain excluded' jq -e 'map(.id)==[5,4,1,3,8]' "$work/recovery.json"
cp "$work/project.json" "$work/duplicates.json"
edit "$work/duplicates.json" '.targets[0].network += [{id:9,name:"same source stale status",url:"https://codeberg.org/joomla/repo",status:0}]'
expect 0 'Duplicate URLs produce one candidate even during recovery' bash "$root/tools/network-candidates.sh" "$work/duplicates.json" future-model --include-offline
cp "$work/output" "$work/deduplicated.json"
expect 0 'Online observation wins over duplicate offline URL and retains its node metadata' jq -e 'map(.id)==[5,4,1,3,8] and ([.[]|select(.url=="https://codeberg.org/joomla/repo")]|length==1)' "$work/deduplicated.json"
expect 2 'Absent target returns no fabricated URL' bash "$root/tools/network-candidates.sh" "$work/project.json" missing-model
cp "$work/output" "$work/absent.json"
expect 0 'Absent target output is an empty array' jq -e 'length==0' "$work/absent.json"
cp "$work/project.json" "$work/without-codefloe.json"
edit "$work/without-codefloe.json" '.targets[0].network |= map(select(.id!=5))'
expect 0 'Missing preferred host does not block the next live host' bash "$root/tools/network-candidates.sh" "$work/without-codefloe.json" future-model
cp "$work/output" "$work/fallback.json"
expect 0 'An undiscovered preferred URL is never synthesized' jq -e 'map(.id)==[4,1]' "$work/fallback.json"
cp "$work/project.json" "$work/blocked-only.json"
edit "$work/blocked-only.json" '.targets[0].network |= map(select(.id==2 or .id==6 or .id==7))'
expect 2 'Blocked-only response remains unusable during offline recovery' bash "$root/tools/network-candidates.sh" "$work/blocked-only.json" future-model --include-offline
for url in 'https://git.vdm.dev./joomla/repo' 'https://user:secret@codeberg.org/joomla/repo' 'https://codeberg.org/joomla/repo?token=secret' 'https://codeberg.org/../repo' 'https://codeberg.org:99999/joomla/repo' 'http://codeberg.org/joomla/repo'; do
	jq -n --arg url "$url" '{project:"jcb",targets:[{target:"test",network:[{name:"invalid URL",url:$url,status:1}]}]}' > "$work/invalid-url.json"
	expect 2 'Unusable URL never becomes a read candidate' bash "$root/tools/network-candidates.sh" "$work/invalid-url.json" test
done
cp "$work/project.json" "$work/bad.json"; edit "$work/bad.json" '.targets[0].network[0].status="1"'
expect 1 'String status is rejected rather than silently treated as online' bash "$root/tools/network-candidates.sh" "$work/bad.json" future-model
cp "$work/project.json" "$work/bad.json"; edit "$work/bad.json" '.targets += [.targets[0]]'
expect 1 'Duplicate target names are rejected' bash "$root/tools/network-candidates.sh" "$work/bad.json" future-model
printf '{}\n{}\n' > "$work/bad.json"
expect 1 'Multiple JSON documents are rejected' bash "$root/tools/network-candidates.sh" "$work/bad.json" future-model
printf '<html>unavailable</html>\n' > "$work/bad.json"
expect 1 'An HTML error response is rejected' bash "$root/tools/network-candidates.sh" "$work/bad.json" future-model
expect 1 'Unknown command option is rejected' bash "$root/tools/network-candidates.sh" "$work/project.json" future-model --offline
printf 'Passed %s network discovery regression checks.\n' "$passed"
