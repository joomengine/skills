#!/usr/bin/env bash
# Select read candidates from one saved discovery response; never opens a socket.
set -euo pipefail
usage() {
	printf 'Usage: %s PROJECT_JSON TARGET [--include-offline]\n' "${0##*/}" >&2
	printf 'Outputs eligible nodes as JSON, online first; exits 2 when none remain.\n' >&2
}
[[ $# == 2 || ( $# == 3 && $3 == --include-offline ) ]] || { usage; exit 1; }
command -v jq >/dev/null 2>&1 || { printf 'ERROR: jq is required\n' >&2; exit 1; }
snapshot=$1
target=$2
include_offline=false
[[ $# == 2 ]] || include_offline=true
[[ -n $target && -f $snapshot ]] || { usage; exit 1; }

# Do not couple discovery to today's target names. Validate the envelope but
# leave new node metadata intact. Invalid/unusable URLs never become candidates.
if ! candidates=$(jq -s --arg target "$target" --argjson offline "$include_offline" '
	def nonempty: type == "string" and length > 0;
	def repository_url:
		type == "string"
		and test("^https://([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z][A-Za-z0-9-]*(:[0-9]{1,5})?/[A-Za-z0-9._~/-]+$")
		and (test("(^|/)\\.\\.?(/|$)") | not)
		and (capture("^https://[^/:]+(?::(?<port>[0-9]+))?/") |
			if .port == null then true else (.port | tonumber) > 0 and (.port | tonumber) <= 65535 end);
	def host: capture("^https://(?<host>[^/:]+)").host | ascii_downcase;
	if length != 1 then error("Expected exactly one discovery JSON document") else .[0] end
	| if .project != "jcb" or (.targets | type) != "array"
		then error("Expected the JCB project discovery response") else . end
	| if (all(.targets[]; (.target | nonempty) and (.network | type == "array")
		and all(.network[]; (.name | nonempty) and (.url | nonempty) and (.status == 0 or .status == 1))) | not)
		then error("Invalid target, node or status") else . end
	| if ([.targets[].target] | length != (unique | length))
		then error("Duplicate target names") else . end
	| [.targets[] | select(.target == $target) | .network | to_entries[]
		| .key as $order | .value
		| select(.status == 1 or $offline)
		| select(.url | repository_url)
		| (.url | host) as $host
		| select($host != "git.vdm.dev" and ($host | endswith(".git.vdm.dev") | not))
		| {node: ., order: $order, priority: (if $host == "codefloe.com" then 0 elif $host == "codeberg.org" then 1 else 2 end)}]
	| sort_by(-.node.status, .priority, .order)
	| unique_by(.node.url)
	| sort_by(-.node.status, .priority, .order)
	| map(.node)
' -- "$snapshot"); then
	printf 'ERROR: Cannot read a valid discovery snapshot\n' >&2
	exit 1
fi
printf '%s\n' "$candidates"
if [[ $(jq 'length' <<<"$candidates") == 0 ]]; then
	printf 'No eligible candidate for target %s; refresh discovery or use the documented recovery path.\n' "$target" >&2
	exit 2
fi
