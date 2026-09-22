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
# Output is named vNNN_part.stl / vNNN_view.png - a file that leaves its folder
# has to keep saying which render it is; see the note above the STL section.
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
    cp "$HERE/check_mesh.py" "$OUT/check_mesh.py"
    chmod +x "$OUT/render.sh"
fi

cd "$OUT"
: > render.log
run() { "$@" 2>&1 | tee -a render.log; }
echo "== rendering in $(basename "$OUT")"

# Every STL and PNG is named vNNN_... . The version folder tells you where a
# file came from only while the file is still in it: dropped into a slicer,
# mailed, or sitting next to three other prints, ky023_boot.stl from v019 and
# from v026 are the same name for two different parts. The number goes in front
# because that is the end that survives a truncated column. The number alone,
# not the whole folder name - dates make it unreadable, and a folder may still
# be renamed later (-printed) without invalidating what is inside it.
VER=$(basename "$OUT"); VER=${VER%%-*}
if [[ $VER =~ ^v[0-9]{3}$ ]]; then P="${VER}_"; else P=""; fi

# ---- STL -------------------------------------------------------------------
run "$OS" -o ${P}ky023_boot.stl   --export-format binstl -D 'part="boot"'   "$SCAD"   # bellows = default
run "$OS" -o ${P}ky023_boot_deep.stl --export-format binstl -D 'part="boot"' -D 'bellows="deep"' "$SCAD"
run "$OS" -o ${P}ky023_cap_head.stl --export-format binstl -D 'part="cap_head"' "$SCAD"
run "$OS" -o ${P}ky023_cap_stem.stl --export-format binstl -D 'part="cap_stem"' "$SCAD"
run "$OS" -o ${P}ky023_box.stl    --export-format binstl -D 'part="box"'    "$SCAD"
run "$OS" -o ${P}ky023_lid.stl    --export-format binstl -D 'part="lid"'    "$SCAD"
run "$OS" -o ${P}ky023_gasket.stl --export-format binstl -D 'part="gasket"' "$SCAD"
run "$OS" -o ${P}ky023_ring.stl   --export-format binstl -D 'part="ring"'   "$SCAD"
run "$OS" -o ${P}ky023_mock.stl   --export-format binstl -D 'part="mock"'   "$SCAD"   # PCB mock-up, reference only

# ---- silicone casting mould, per bellows pattern ---------------------------
# shell x2 + two core halves + 2 dowels (per mould) + 1 pin (same for both)
# (plain word, not an array: an empty "${a[@]}" trips set -u on bash 3.2)
for b in "" _deep; do
    if [[ -n $b ]]; then BOPT='-D bellows="deep"'; else BOPT=''; fi
    run "$OS" -o ${P}ky023_mould_shell$b.stl      --export-format binstl -D 'part="mould_shell"'      $BOPT "$SCAD"
    run "$OS" -o ${P}ky023_mould_core_lower$b.stl --export-format binstl -D 'part="mould_core_lower"' $BOPT "$SCAD"
    run "$OS" -o ${P}ky023_mould_core_upper$b.stl --export-format binstl -D 'part="mould_core_upper"' $BOPT "$SCAD"
    run "$OS" -o ${P}ky023_mould_dowel$b.stl      --export-format binstl -D 'part="mould_dowel"'      $BOPT "$SCAD"
done
run "$OS" -o ${P}ky023_mould_pin.stl -D 'part="mould_pin"' --export-format binstl "$SCAD"
run "$OS" -o ${P}ky023_boot_cast.stl --export-format binstl -D 'part="boot_cast"' "$SCAD"   # what the mould yields

# ---- PNG (camera = tx,ty,tz, rotx,roty,rotz, distance) ---------------------
run "$OS" -o ${P}iso.png      --render --imgsize=$IMG --camera=0,0,10,55,0,25,130  -D 'part="boot"' "$SCAD"
run "$OS" -o ${P}side.png     --render --imgsize=$IMG --projection=o --camera=0,0,10,90,0,0,95 -D 'part="boot"' "$SCAD"
run "$OS" -o ${P}top.png      --render --imgsize=$IMG --projection=o --camera=0,0,10,0,0,0,95  -D 'part="boot"' "$SCAD"
run "$OS" -o ${P}section.png  --render --imgsize=$IMG --projection=o --camera=0,0,10,90,0,0,75 -D 'part="section"' "$SCAD"
run "$OS" -o ${P}section_deep.png --render --imgsize=$IMG --projection=o --camera=0,0,10,90,0,0,75 -D 'part="section"' -D 'bellows="deep"' "$SCAD"
run "$OS" -o ${P}cap.png      --render --imgsize=$IMG --camera=0,0,16,55,0,25,95 -D 'part="cap"' "$SCAD"
run "$OS" -o ${P}cap_section.png --render --imgsize=$IMG --projection=o --camera=0,0,17,90,0,0,80 -D 'part="cap_section"' "$SCAD"
run "$OS" -o ${P}box.png      --render --imgsize=$IMG --camera=-8,0,-8,55,0,25,190 -D 'part="box"' "$SCAD"
run "$OS" -o ${P}box_inside.png --render --imgsize=$IMG --camera=-8,0,-8,235,0,25,190 -D 'part="box"' "$SCAD"
run "$OS" -o ${P}lid.png      --render --imgsize=$IMG --camera=-8,0,-17,55,0,25,170 -D 'part="lid"' "$SCAD"
run "$OS" -o ${P}gasket.png   --render --imgsize=$IMG --camera=-8,0,0,55,0,25,170 -D 'part="gasket"' "$SCAD"
run "$OS" -o ${P}ring.png     --render --imgsize=$IMG --camera=0,0,1,55,0,25,90 -D 'part="ring"' "$SCAD"
run "$OS" -o ${P}mock.png     --render --imgsize=$IMG --camera=0,-1,-4,55,0,25,110 -D 'part="mock"' "$SCAD"
run "$OS" -o ${P}mock_top.png --render --imgsize=$IMG --projection=o --camera=0,-1,0,0,0,0,115 -D 'part="mock"' "$SCAD"
run "$OS" -o ${P}base_section.png --render --imgsize=$IMG --projection=o --camera=-3,0,0,90,0,0,60 -D 'part="assembly_section"' "$SCAD"
run "$OS" -o ${P}assembly.png --render --imgsize=$IMG --camera=-8,0,4,60,0,35,225 -D 'part="assembly"' "$SCAD"
run "$OS" -o ${P}assembly_section.png --render --imgsize=$IMG --projection=o --camera=-8,0,4,90,0,0,135 -D 'part="assembly_section"' "$SCAD"

# ---- mesh check (every part must be one closed manifold solid) ------------
echo "== mesh check" | tee -a render.log
MCHK="$HERE/check_mesh.py"; [[ -f check_mesh.py ]] && MCHK=./check_mesh.py
for f in ${P}ky023_*.stl; do
    # the PCB mock-up is a pile of reference bodies, not a printable part
    [[ $f == ${P}ky023_mock.stl ]] && continue
    python3 "$MCHK" "$f" 2>&1 | tee -a render.log
done

# ---- printability check (axisymmetric parts, section y = 0) ---------------
echo "== overhang check" | tee -a render.log
CHK="$HERE/check_overhang.py"; [[ -f check_overhang.py ]] && CHK=./check_overhang.py
LINE_W=$(sed -n 's/^line_w *= *\([0-9.]*\).*/\1/p' "$SCAD"); LINE_W=${LINE_W:-0.42}
python3 "$CHK" ${P}ky023_boot.stl 45 minw=$LINE_W 2>&1 | tee -a render.log || true
python3 "$CHK" ${P}ky023_boot_deep.stl 45 minw=$LINE_W 2>&1 | tee -a render.log || true
python3 "$CHK" ${P}ky023_ring.stl 45      2>&1 | tee -a render.log || true
python3 "$CHK" ${P}ky023_cap_head.stl 50 2>&1 | tee -a render.log || true
python3 "$CHK" ${P}ky023_cap_stem.stl 62 2>&1 | tee -a render.log || true
python3 "$CHK" ${P}ky023_box.stl  62 flip 2>&1 | tee -a render.log || true
python3 "$CHK" ${P}ky023_lid.stl  62      2>&1 | tee -a render.log || true

echo "== done: $(basename "$OUT")"
ls -la
