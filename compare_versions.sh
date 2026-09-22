#!/usr/bin/env bash
# Which parts changed between two renders?
#
#   ./compare_versions.sh v025 v027     # prefixes, matched against versions/*
#   ./compare_versions.sh dirA dirB     # or two explicit directories
#
# STLs are compared by content, ignoring the vNNN_ prefix in the file name.
# This is the only honest way to tell "I rewrote the code" from "I moved the
# geometry": a part that was not supposed to change has to come out
# byte-identical, and eyes, triangle counts and volumes all fail to prove that.
# Run it against the last -printed version before printing anything again.
set -euo pipefail

resolve() {
    local d
    if [[ -d $1 ]]; then (cd "$1" && pwd); return 0; fi
    for d in versions/"$1"*/; do
        [[ -d $d ]] || continue
        (cd "$d" && pwd); return 0
    done
    echo "compare_versions: no such version or directory: $1" >&2
    return 1
}

sum() {
    if command -v md5 >/dev/null 2>&1; then md5 -q "$1"; else md5sum "$1" | cut -d' ' -f1; fi
}

# "<part name> <checksum>" per STL, sorted; the version prefix is stripped so
# v003_base.stl and v007_base.stl compare as the same part
list() {
    local f n
    for f in "$1"/*.stl; do
        [[ -e $f ]] || continue
        n=$(basename "$f"); n=${n#v[0-9][0-9][0-9]_}
        echo "${n%.stl} $(sum "$f")"
    done | sort
}

[[ $# -eq 2 ]] || { sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

A=$(resolve "$1"); B=$(resolve "$2")
ta=$(mktemp); tb=$(mktemp)
trap 'rm -f "$ta" "$tb"' EXIT
list "$A" > "$ta"; list "$B" > "$tb"

echo "== $(basename "$A")  ->  $(basename "$B")"
same=0; changed=0
while read -r name ma mb; do
    if [[ $ma == "$mb" ]]; then
        same=$((same + 1))
    else
        changed=$((changed + 1)); echo "  CHANGED      $name"
    fi
done < <(join -j 1 "$ta" "$tb")

comm -23 <(cut -d' ' -f1 "$ta") <(cut -d' ' -f1 "$tb") | sed 's/^/  only in old  /'
comm -13 <(cut -d' ' -f1 "$ta") <(cut -d' ' -f1 "$tb") | sed 's/^/  only in new  /'
echo "  $same identical, $changed changed"
