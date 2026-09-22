**English** · [Українська](MODEL.uk.md)

# The model: how it is built and what drives it

A reference for `ky023_boot.scad` — for whoever is going to edit the geometry. A
user who just prints needs only [PRINTING.md](PRINTING.md); for an overview of
the project — [README.md](README.md).

The whole model is one file: Customizer parameters in `/* [Name] */` groups,
derived geometry with `echo()` and WARNINGs, the part modules, and the `part`
selection at the end. The boot wall is `wall_lines` passes of the `nozzle_d` (0.4)
nozzle; at a single pass it is modelled as the slicer line width `line_w` (0.42)
+ 0.04 = 0.46 mm, because a cross-section thinner than a line gets dropped by the
slicer and empty layers appear at the bends (where the wall passes through
vertical).

## How it is sealed

| Joint | Solution |
|---|---|
| cap ↔ boot | a Ø18.5 × 1.7 groove on the cap stem flange: below it a flat Ø19.9 lip, above it the flat bottom of the glued-on head; the Ø1.6 bead at the top of the boot simply stretches onto the core of the groove (~6 %) before the head is glued on, so it never has to be pulled over the full head |
| boot ↔ box | the grommet: a lip under the panel (flat on top, 45° chamfer below), the body in a Ø29.4 opening with a rib, a 45° cone that seats into the panel countersink flush with it; from inside the box a rigid expander ring is inserted into the grommet from below. Its tube, Ø26.6, is 0.3 mm **narrower** than the printed grommet opening (which pulls inward anyway when the body is pressed into the panel opening) and only props the TPU up so the grommet cannot contract when the boot pulls; the only thing that presses is the Ø27.2 × 1.2 mm band with 45° chamfers, which sits in the panel opening under the grommet rib: there the 1.4 mm TPU wall is squeezed to 1.1 mm (21 %) over a height of just 1.2 mm, and that same band is what keeps the ring from falling out. The flange presses the grommet lip up against the panel. Nothing protrudes above the panel |
| box ↔ lid | the box is one piece (panel + walls + 4 corner bosses), open at the bottom; between the rim and the bottom lid is a flat 1.5 mm TPU gasket, flush with the body. The 0.8 × 0.5 mm sealing rib is on the **box rim**, not on the lid: the gasket goes onto it by its 1.0 × 0.3 mm groove and holds itself on the rim while you bring the lid in; the rib then presses a further 0.2 mm into the TPU. Around each screw the rib and the groove are interrupted over Ø7 — there the gasket is solid (the screws press hardest exactly there anyway, and a groove would leave webs thinner than a line) |
| cable | no hole (`gland_d = 0`): pot it with compound or drill it in place; `gland_d = 12.5` gives a teardrop hole for a PG7 in the −X wall |

## Re-centring

- The boot is symmetric and printed in the shape it has once installed, so its
  only equilibrium is the centre.
- The corrugation is switched with the `bellows` parameter; both options fit the
  same grommet, ring and stem groove:
  - **`v019`** (the default) — two folds, `fold_rises`; this is the very geometry
    that has been printed and verified on the module (the rebuilt STL is
    byte-identical to `versions/v019-*/ky023_boot.stl`). Compliance index 0.46;
  - **`deep`** — a short step outward above the panel, one very deep fold inward
    (10 mm, to within 2 mm of the neck) and back, `fold_dr`. Index 0.91, i.e.
    twice as soft on paper, but not printed yet.

  Both give ~28 mm of wall between the grommet and the stem groove: up to ~21° of
  tilt the far side only bends, at 25° the stretch is ~4 % (pulling back to
  centre). Fold stiffness is ∝ 1/depth³ — hence the difference in the indices.
  Shared levers: leg angle `leg_deg`, bend radii `fold_r_v019` / `fold_r_deep`.
- Why the bead is attached at the top and not at the bottom of the stem (where
  the travel is half as long): without supports the meridian has to keep rising
  at ≥45°, so the available wall length is ≈ height × 1.41, and a radial pattern
  adds nothing to it. Attaching at z 14 instead of 24 saves 4.3 mm of travel but
  costs 13 mm of wall: the stretch at 25° grows from ~4 % to 32 %, and stretch is
  no longer bending — it is stiffness. For the same reason many small waves are
  stiffer than one deep fold.
- The boot moves together with the head: the button simply compresses it by
  1.5 mm.
- What else reduces the resistance (strongest first): wall thickness (∝ t³:
  `wall_lines = 1` — 8 times softer, a 0.3 nozzle at 2 passes — 2.4 times); a
  softer filament (Elastan D160 is ~40–50 Shore D ≈ 95–98A, the hardest class of
  TPU; 85A would give another ~3 times); `leg_deg` 50 at a 0.15 layer — a slightly
  longer meridian and deeper folds for the same height. Beyond that — casting in
  silicone (see PRINTING.md).

## Parameters for your own module

The joystick position on the board and the hole grid are absent from the KY-023
datasheets, and the community mock-up (Printables 498437) contradicts itself
(text: holes 26.7 × 20.3; STL: 26.5 × 19.0 and the axis at the centre of the
board). So the model carries measured values, and the rest has to be measured:

| What | Parameter |
|---|---|
| board length × width | `pcb_l` 34.4, `pcb_w` 26.07 (measured) |
| axis position: centred lengthwise; 14.05 crosswise from the long edge with the button | `pcb_dx` 0, `pcb_dy = pcb_w/2 − 14.05` = −1.0 (measured) |
| hole pitch along and across the board, and their diameter | `pcb_hole_dx`, `pcb_hole_dy`, `pcb_hole_d` (26.7 × 20.3, Ø3.2 — **not measured**, for M3 standoffs a 1 mm difference is critical) |
| B — from the connector end to the centres of the nearest holes | `hole_dx = B + pcb_hole_dx/2 − pcb_l/2` (0 = grid centred on the board) |
| top of the potentiometers above the joystick's steel plate | `pot_top_z` (−1); the panel sits `panel_clear` higher, the grommet lip runs outside it (r ≥ 13.6) |
| the stem under the knob | `post_type` `dd`/`d`/`rect`, `post_d` 4.08, `post_flat` 3.12 (measured), `post_h` (7.2 per P3) |

Orientation in the model (from photos of the HW-504): the connector on the −X
end, the button on the −Y long edge, a potentiometer opposite it (+Y), the second
potentiometer facing the +X end. The gland hole is on −X. On render, `ECHO`
prints the distances to the ends and the standoff coordinates for checking. The
cap socket = stem + `socket_clear` 0.15 per side (a light interference fit; 0.2
if it will not go on, 0.1 if it wobbles), with a 0.4 chamfer at the entry.

## Box dimensions

Crosswise the box is centred on the joystick axis (the opening in the middle of
the panel, the board inside offset by 1 mm); lengthwise there is `cav_end` = 20 mm
of free length past the connector end, `cav_far` = 3 mm past the opposite one, and
`cav_side` = 3 mm at the sides. The cavity corner radius is derived from the box
corner (`cav_r = box_r − wall_t`), so the 2.5 mm wall — and with it the gasket on
top of it — is the same width everywhere, in the corners too.

The panel edges (R2.5) and the lid edges (R1.5) are rounded with an arc; both
edges lie on the bed while printing, so the arc starts at the angle
`edge_start_deg` (30°: the first ~0.8 mm are steeper than 45°, PETG holds that;
45 = safest, 0 = a full circle).

## Files and checks

| File | What it is |
|---|---|
| `ky023_boot.scad` | the parametric model of every part and of the assembly |
| `render.sh` | renders STLs and PNGs into a version folder, and at the end checks the mesh and the overhangs |
| `render_docs.sh` | the pictures for the README into `docs/img/` — the only generated thing kept in git (everything in `versions/` is ignored, and a GitHub visitor would otherwise never see the model). The progress gallery is rendered from the `.scad` copies in `versions/` with one camera |
| `check_mesh.py` | an STL must be one closed body: it welds vertices on a 0.1 µm grid and requires every edge to belong to exactly two triangles (fewer — a hole, more — two surfaces along a line) and the body to be single (`parts=N` if there are legitimately several) |
| `check_overhang.py` | printing without supports: it slices the profile (the y = 0 section) in 0.1 mm layers and checks that each layer rests on the previous one (islands, overhang angle); `flip` for parts printed upside down; `minw=W` catches cross-sections thinner than a slicer line |
| `check_fit.scad` | seven boolean tests of the mould (shell vs cores vs casting, the core halves against each other, cavity minus part and core) — each must come out ~0 mm³; run by hand, not from `render.sh` |
| `compare_versions.sh vNNN vMMM` | what exactly changed between two renders: it compares the STLs byte for byte, ignoring the version prefix in the name. The only honest way to tell "I rewrote the code" from "I moved the geometry" — a part you did not touch must stay byte-identical. Run it against the last `-printed` before printing anything again |
| `stl_volume.py` | volume (signed), area and mean thickness 2·V/A. For a boolean difference that should have come out empty, look at the thickness, not the volume: 2 µm is boolean-operation noise, 0.4 mm is a real part that will print as a loose fragment |
| `versions/vNNN-YYYYMMDD-HHMMSS/` | a copy of `.scad` + `.sh` + `.py`, the STLs and PNGs with the version number in front, and `render.log` |

`part` switches between: `boot`, `ring`, `cap_head`, `cap_stem`, `cap`
(assembled), `cap_section`, `box`, `lid`, `gasket`, `section`, `assembly`,
`assembly_section`, `mock`, `boot_cast`, `mould_shell`, `mould_core_lower`,
`mould_core_upper`, `mould_dowel`, `mould_pin`, `mould_section`, `mould_cavity`,
`mould_core_raw`. PNGs: `iso`, `side`, `top`, `section`, `section_deep`, `cap`,
`cap_section`, `box`, `box_inside`, `lid`, `gasket`, `ring`, `mock`, `mock_top`,
`assembly`, `assembly_section`, `base_section`.

### Version folders

`./render.sh` from the root creates a new `versions/vNNN-date-time/`; inside such
a folder the copy of the script re-renders it in place, next to its own copy of
the `.scad` — so an old version is reproducible even after incompatible changes
in the root. A folder is recognised by `vNNN-` and the date, and the rest of the
name can be anything; the `-printed` suffix is appended to the one that was
actually printed — that is the only marker that the geometry was verified in
plastic.

STLs and PNGs are named `vNNN_name`: the folder tells you where a file came from
only while the file is still in it, and the slicer shows nothing but the name.
The number goes in front because it is the start of the name that shows in a
narrow column; the number alone, without the date — with the date it is
unreadable, and the folder may be renamed later. The copied sources keep their
names: the folder and git identify them.

`.gitignore` ignores everything generated in `versions/*/` except the copied
`.scad`, `.sh` and `.py`. So in a fresh clone the version folders have no STLs,
and `compare_versions.sh` will not work there until you re-render both versions
yourself: go into the folder in question and run the copy of `render.sh` that
lives there — it reproduces its own version in place.

## The mould: why it is like that

- **The shell is a clamshell** of two halves: annular folds come out of them (at
  the parting plane the draft is zero, but there is no undercut — this is how
  bellows are cast).
- **The core is split at the waist** (the narrowest fold): it cannot be pulled out
  in one piece, because it is a barrel between two narrower openings. The upper
  half comes out upward through the bead (27 % stretch in `deep`, 20 % in `v019`),
  the lower one downward through the grommet (18 % / 3 %); silicone stretches
  400 %+, so this is nothing. The joint falls on an internal surface, so its flash
  touches no sealing surface.
- **The shell halves are identical**: every feature on the parting plane comes in
  ±X pairs, so one half rotated 180° is the other.
- **It is cast bottom-up.** Two Ø6 ports in the floor open onto the bottom face of
  the grommet lip: the syringe goes in one, and the other shows when the silicone
  has arrived. Air goes up and out through 4 Ø1.2 holes from the riser ring above
  the bead. Gravity will not fill a 1.2 mm annular gap over 28 mm of height — which
  is exactly why it goes in from below.
- **The riser**: the cavity runs 1.5 mm above the part, which is where the first
  dirty silicone and the remaining air collect; it is trimmed off afterwards.
- **No supports**: the shell prints parting-plane up — the cavity cross-section at
  print height is √(R(z)²−y²), i.e. it only widens going up while the body only
  narrows.
- **The casting wall** `cast_wall` = 1.2 mm: any thinner and the silicone simply
  will not flow through an annular gap 28 mm tall, and it tears on removal.

## History

`v001` — an open boot over the joystick frame; `v002`–`v003` — a sealed variant
with a clamped sheet (the bead loop would not print without supports, the sheet
sagged over the cavity); `v004` — the bead on the rim of the head; `v005` — a
grommet in the panel, the lid at the bottom, no gland hole; `v006` — the grommet
cone in a countersink instead of a flange, the expander ring, rounded edges;
`v007` — fixed the island under the bead (the teardrop runs along the leg), flat
cap top, automatic overhang checking in `render.sh`; `v008` — stem type as a
parameter (`dd`/`d`/`rect`), the default being round with two flats instead of the
P3 rectangle; `v009` — measured stem 4.08 / 3.12, 0.15 clearance, a chamfer at the
socket entry; `v010` — a two-part cap: the head prints top-up, the stem is glued
in; `v011` — measured joystick position on the board (34.4 × 26.07, axis 14.05
from the end with the button), connector and gland on +X, a parameter for the hole
grid offset; `v012` — a 20 mm compartment for the connector; `v013` — correct
orientation: button on the long edge (−Y), axis centred lengthwise and 14.05 from
the button edge crosswise, connector and compartment on −X; `v014` — a groove for
the rib in the gasket, the gasket flush with the body, wall thickness expressed in
nozzle passes; `v015` — smooth rounding of the box and lid edges (24 segments,
start angle as a parameter); `v016` — the expander ring is inserted from below,
from inside the box (a tube with a flange under the lip), the panel 1.3 mm above
the potentiometers; `v017` — the lip and the bead groove moved onto the stem
flange, the head is glued on top and covers the groove: the bead only stretches
6 %; `v018` — the box centred on the opening; `v019` — centring crosswise only
(where the board is offset), lengthwise the `cav_end` compartment only on the
connector side; `v020` — a softer corrugation: one deep fold (`fold_dr`), R1.2
chamfers, a vertical section under the bead (`bead_stub`), the compliance index in
`ECHO`; `v021` — an attempt at 1 pass (0.40 mm): the slicer dropped the wall at
the bends; `v022` — a single-pass wall = `line_w` + 0.04, thin cross-section
checking in `check_overhang.py`; `v023` — the expander ring no longer expands the
grommet over its whole length (the tube is 0.3 mm narrower than the printed
opening and only the 1.2 mm band under the grommet rib presses — in v022 it could
not be pushed in at all), the sealing rib moved from the lid to the box rim with
the gasket going onto it by its groove, the cavity corner derived from the box
corner, narrower rib/groove — 0.75 mm is left in the gasket corners instead of
0.34 (the slicer was dropping them); `v024` — the v019 corrugation returned to the
code as the `bellows = "v019"` option (the default) alongside the deep one, both
exported as separate STLs; `v025` — a mould for silicone casting for both
corrugations; `v026` — the v025 mould shell would not slice (the slicer complained
about non-manifold edges): the cavity was made of the part and the core, and their
shared internal surface is drawn by different code — the wall by `stroke2d` from
24-gons, the core by `offset()` with true arcs — and on the fold radii the two
drifted apart by ~5 µm; those slivers got pinched inside the cavity and left free
5 µm-thick rings in the shell. On top of that the closing rib `under2d` ran
diagonally and, at a negative `offset()`, cut off a 0.4 mm ring under the bead.
`check_mesh.py` was added to every render; `v027` — the version number in front of
the names of every STL and PNG.
