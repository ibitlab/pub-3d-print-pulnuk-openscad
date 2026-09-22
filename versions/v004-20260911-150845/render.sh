#!/usr/bin/env bash
# Render STL + PNG previews for ky023_boot.scad.
#
#   ./render.sh          from the project root: creates a new version folder
#                        versions/vNNN-YYYYMMDD-HHMMSS/, copies ky023_boot.scad
#                        and this script into it, renders there
#   ./render.sh          from inside a version folder (the copied script):
#                        re-renders that version in place, nothing is copied
#   ./render.sh DIR      renders the sources next to this script into DIR
#                        (created if missing; sources are copied there too)
#
# Git: only the copied .scad/.sh in a version folder are tracked, the
# STL/PNG/log output is ignored (see .gitignore).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD=ky023_boot.scad
OS=${OPENSCAD:-openscad}
IMG=${IMG:-1600,1200}
VERSION_RE='^v[0-9]{3}-[0-9]{8}-[0-9]{6}$'

# ---- where to render -------------------------------------------------------
if [[ $# -ge 1 ]]; then
    OUT="$(mkdir -p "$1" && cd "$1" && pwd)"
elif [[ $(basename "$HERE") =~ $VERSION_RE ]]; then
    OUT="$HERE"                                 # re-render this version
else
    mkdir -p "$HERE/versions"
    last=0
    for d in "$HERE"/versions/v[0-9][0-9][0-9]-*/; do
        [[ -d $d ]] || continue
        n=$(basename "$d"); n=$((10#${n:1:3}))
        if (( n > last )); then last=$n; fi
    done
    OUT="$HERE/versions/v$(printf '%03d' $((last + 1)))-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$OUT"
fi

if [[ "$OUT" != "$HERE" ]]; then
    cp "$HERE/$SCAD" "$OUT/$SCAD"
    cp "${BASH_SOURCE[0]}" "$OUT/render.sh"
    chmod +x "$OUT/render.sh"
fi

cd "$OUT"
: > render.log
run() { "$@" 2>&1 | tee -a render.log; }
echo "== rendering in $(basename "$OUT")"

# ---- STL -------------------------------------------------------------------
run "$OS" -o ky023_boot.stl --export-format binstl -D 'part="boot"' "$SCAD"
run "$OS" -o ky023_cap.stl  --export-format binstl -D 'part="cap"'  "$SCAD"
run "$OS" -o ky023_lid.stl  --export-format binstl -D 'part="lid"'  "$SCAD"
run "$OS" -o ky023_box.stl  --export-format binstl -D 'part="box"'  "$SCAD"

# ---- PNG (camera = tx,ty,tz, rotx,roty,rotz, distance) ---------------------
run "$OS" -o iso.png      --render --imgsize=$IMG --camera=-6,0,10,55,0,25,160 -D 'part="boot"' "$SCAD"
run "$OS" -o side.png     --render --imgsize=$IMG --projection=o --camera=-6,0,11,90,0,0,100 -D 'part="boot"' "$SCAD"
run "$OS" -o top.png      --render --imgsize=$IMG --projection=o --camera=-6,0,11,0,0,0,100 -D 'part="boot"' "$SCAD"
run "$OS" -o section.png  --render --imgsize=$IMG --projection=o --camera=0,0,12,90,0,0,70 -D 'part="section"' "$SCAD"
run "$OS" -o cap.png      --render --imgsize=$IMG --camera=0,0,14,55,0,25,90 -D 'part="cap"' "$SCAD"
run "$OS" -o lid.png      --render --imgsize=$IMG --camera=-6,0,3,55,0,25,150 -D 'part="lid"' "$SCAD"
run "$OS" -o box.png      --render --imgsize=$IMG --camera=-6,0,-10,55,0,25,160 -D 'part="box"' "$SCAD"
run "$OS" -o assembly.png --render --imgsize=$IMG --camera=-6,0,4,60,0,35,200 -D 'part="assembly"' "$SCAD"
run "$OS" -o assembly_section.png --render --imgsize=$IMG --projection=o --camera=-6,0,4,90,0,0,130 -D 'part="assembly_section"' "$SCAD"

echo "== done: $(basename "$OUT")"
ls -la
