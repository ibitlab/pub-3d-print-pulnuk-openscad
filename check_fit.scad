// Fit test for the casting mould: pieces that have to come apart must share no
// material, and the cavity must be exactly the part plus the core. Each case
// renders what should not exist, so every export must measure ~0 mm3 (empty
// STLs are normal; OpenSCAD may also emit a few zero-volume triangles where
// two surfaces touch, which is why the answer is a volume and not a file size).
//
//   for t in 1 2 3 4 5 6 7; do
//       rm -f /tmp/fit.stl                       # an empty result writes no
//       openscad -o /tmp/fit.stl --export-format binstl -D t=$t \
//                -D 'bellows="v019"' check_fit.scad
//       python3 stl_volume.py /tmp/fit.stl       # file at all, so clear it or
//   done                                         # the last one gets measured twice
//
// This file has to stay next to ky023_boot.scad: include resolves relative to
// *the including file*, not to the working directory (so any cwd is fine, but a
// copy of this file somewhere else is not, unless OPENSCADPATH points here).
// A failed include leaves every module undefined and renders an empty STL -
// which passes all seven tests without a word. The assert below turns that
// silent pass into a loud failure.
//
// The model is used as a library: include pulls in every module, and assigning
// part afterwards overrides the selector inside it so nothing is drawn twice.
// Everything is in model coordinates (the mould assembled), not in the print
// placement the mould_* STLs are exported in.
include <ky023_boot.scad>
part = "none";

assert(!is_undef(cast_wall), "ky023_boot.scad was not included - keep this file next to it");
assert(!is_undef(t), "run with -D t=1..7");

if (t == 1) intersection() { mould_shell(); mould_core(true); }         // shell vs upper core
else if (t == 2) intersection() { mould_shell(); mould_core(false); }   // shell vs lower core
else if (t == 3) intersection() { mould_shell(); boot(cast_wall); }     // shell vs the casting
else if (t == 4) intersection() { mould_core(true); mould_core(false); } // the two core halves
else if (t == 5) intersection() { mould_core(true); boot(cast_wall); }
else if (t == 6) intersection() { mould_core(false); boot(cast_wall); }
// What the cavity holds over and above the part and the core. Not zero by
// design: the core is welded mould_weld into the wall (filled2d) and the clip
// runs eps into the riser, so this is a thin film plus a 0.01 mm disc - check
// the mean thickness, not the volume.
else if (t == 7) difference() { mould_cavity(); boot(cast_wall); mould_core_raw(); }
