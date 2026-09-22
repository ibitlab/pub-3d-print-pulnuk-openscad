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
VERSION_RE='^v[0-9]{3}-[0-9]{8}'   # vNNN-YYYYMMDD..., anything may follow the date

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
    cp "$HERE/check_overhang.py" "$OUT/check_overhang.py"
    chmod +x "$OUT/render.sh"
fi

cd "$OUT"
: > render.log
run() { "$@" 2>&1 | tee -a render.log; }
echo "== rendering in $(basename "$OUT")"

# ---- STL -------------------------------------------------------------------
run "$OS" -o ky023_boot.stl   --export-format binstl -D 'part="boot"'   "$SCAD"
run "$OS" -o ky023_cap_head.stl --export-format binstl -D 'part="cap_head"' "$SCAD"
run "$OS" -o ky023_cap_stem.stl --export-format binstl -D 'part="cap_stem"' "$SCAD"
run "$OS" -o ky023_box.stl    --export-format binstl -D 'part="box"'    "$SCAD"
run "$OS" -o ky023_lid.stl    --export-format binstl -D 'part="lid"'    "$SCAD"
run "$OS" -o ky023_gasket.stl --export-format binstl -D 'part="gasket"' "$SCAD"
run "$OS" -o ky023_ring.stl   --export-format binstl -D 'part="ring"'   "$SCAD"
run "$OS" -o ky023_mock.stl   --export-format binstl -D 'part="mock"'   "$SCAD"   # PCB mock-up, reference only

# ---- PNG (camera = tx,ty,tz, rotx,roty,rotz, distance) ---------------------
run "$OS" -o iso.png      --render --imgsize=$IMG --camera=0,0,10,55,0,25,130  -D 'part="boot"' "$SCAD"
run "$OS" -o side.png     --render --imgsize=$IMG --projection=o --camera=0,0,10,90,0,0,95 -D 'part="boot"' "$SCAD"
run "$OS" -o top.png      --render --imgsize=$IMG --projection=o --camera=0,0,10,0,0,0,95  -D 'part="boot"' "$SCAD"
run "$OS" -o section.png  --render --imgsize=$IMG --projection=o --camera=0,0,10,90,0,0,75 -D 'part="section"' "$SCAD"
run "$OS" -o cap.png      --render --imgsize=$IMG --camera=0,0,16,55,0,25,95 -D 'part="cap"' "$SCAD"
run "$OS" -o cap_section.png --render --imgsize=$IMG --projection=o --camera=0,0,17,90,0,0,80 -D 'part="cap_section"' "$SCAD"
run "$OS" -o box.png      --render --imgsize=$IMG --camera=-10,-1,-8,55,0,25,190 -D 'part="box"' "$SCAD"
run "$OS" -o box_inside.png --render --imgsize=$IMG --camera=-10,-1,-8,235,0,25,190 -D 'part="box"' "$SCAD"
run "$OS" -o lid.png      --render --imgsize=$IMG --camera=-10,-1,-17,55,0,25,170 -D 'part="lid"' "$SCAD"
run "$OS" -o gasket.png   --render --imgsize=$IMG --camera=-10,-1,0,55,0,25,170 -D 'part="gasket"' "$SCAD"
run "$OS" -o ring.png     --render --imgsize=$IMG --camera=0,0,1,55,0,25,90 -D 'part="ring"' "$SCAD"
run "$OS" -o mock.png     --render --imgsize=$IMG --camera=0,-1,-4,55,0,25,110 -D 'part="mock"' "$SCAD"
run "$OS" -o mock_top.png --render --imgsize=$IMG --projection=o --camera=0,-1,0,0,0,0,115 -D 'part="mock"' "$SCAD"
run "$OS" -o base_section.png --render --imgsize=$IMG --projection=o --camera=-3,0,0,90,0,0,60 -D 'part="assembly_section"' "$SCAD"
run "$OS" -o assembly.png --render --imgsize=$IMG --camera=-10,-1,4,60,0,35,230 -D 'part="assembly"' "$SCAD"
run "$OS" -o assembly_section.png --render --imgsize=$IMG --projection=o --camera=-10,-1,4,90,0,0,140 -D 'part="assembly_section"' "$SCAD"

# ---- printability check (axisymmetric parts, section y = 0) ---------------
echo "== overhang check" | tee -a render.log
CHK="$HERE/check_overhang.py"; [[ -f check_overhang.py ]] && CHK=./check_overhang.py
python3 "$CHK" ky023_boot.stl 45      2>&1 | tee -a render.log || true
python3 "$CHK" ky023_ring.stl 45      2>&1 | tee -a render.log || true
python3 "$CHK" ky023_cap_head.stl 50 2>&1 | tee -a render.log || true
python3 "$CHK" ky023_cap_stem.stl 62 2>&1 | tee -a render.log || true
python3 "$CHK" ky023_box.stl  62 flip 2>&1 | tee -a render.log || true
python3 "$CHK" ky023_lid.stl  62      2>&1 | tee -a render.log || true

echo "== done: $(basename "$OUT")"
ls -la
