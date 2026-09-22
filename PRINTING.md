**English** · [Українська](PRINTING.uk.md)

# Printing, assembly, casting

A working document for whoever prints this. What it is and how it works —
[README.md](README.md); parameters and internal mechanics — [MODEL.md](MODEL.md).

## What you need

| | |
|---|---|
| OpenSCAD | 2021+ (tested on 2026.09), Manifold backend |
| Python 3 | the automatic checks during a render |
| Printer | 0.4 nozzle, bed from 70 × 50 mm |
| Filament | TPU — boot and gasket; PETG or ASA — box and lid; PLA or PETG — ring and cap |
| Fasteners | 4 × M3×6 (board to standoffs), 4 × M3×10 (lid to box) |
| Glue | cyanoacrylate or epoxy — to glue the cap head onto the stem |

## Before the first print, check your module

The KY-023 mounting hole grid is not in any datasheet, and the community mock-up
contradicts itself. The model uses values measured on a real HW-504, but **the
board hole pitch is unverified** — for M3 standoffs a 1 mm miss is already
critical. Measure the hole pitch and the stem height under the knob on your own
board; if they differ, it is fixed with parameters: [MODEL.md](MODEL.md).

`ky023_mock.stl` helps you check the joystick position on the board — it is a
mock-up, not for printing.

## Getting the STLs

```
./render.sh
```

Creates `versions/vNNN-date-time/` and puts every STL, PNG and `render.log`
there. File names start with the version number (`v027_ky023_box.stl`) so that
the slicer shows which render a part came from. Nothing in the code needs editing
for this.

At the end of `render.log` are the automatic checks: every STL must be one closed
body and must print without supports. If there is a `FAIL` there, better not take
it to the slicer.

## What to print

One of each:

| Part | File `vNNN_…` | Filament | How it sits on the bed |
|---|---|---|---|
| Boot with grommet | `ky023_boot.stl` | TPU | grommet down, corrugation up |
| Lid gasket | `ky023_gasket.stl` | TPU | flat, groove up |
| Expander ring | `ky023_ring.stl` | PLA/PETG | flange on the bed |
| Cap: head | `ky023_cap_head.stl` | PLA/PETG | disc on the bed |
| Cap: stem | `ky023_cap_stem.stl` | PLA/PETG | boss on the bed, **with a brim** |
| Box | `ky023_box.stl` | PETG/ASA | upside down, panel on the bed |
| Lid | `ky023_lid.stl` | PETG/ASA | outer face on the bed |

Every STL is already rotated the way it prints — just drop it into the slicer.

Also in the folder, but **not for printing**: `ky023_mock.stl` — the board mock-up;
`ky023_boot_cast.stl` — what the silicone casting should look like. And
`ky023_boot_deep.stl` is the second bellows option (one deep fold instead of two
shallow ones): softer on paper, not yet verified in plastic. You can print both
and compare them on the same module — every other part is identical.

## Print settings

**TPU (boot, gasket).** Line width 0.42, layer 0.15–0.2, 15–20 mm/s, fan 40–60 %,
brim 3 mm. Infill 0 % for the boot and 100 % for the gasket, turn `gap fill` off,
turn "detect thin walls" / Arachne on. The corrugation wall is a single nozzle
pass (0.46 mm), so after slicing look through the layers at the bend heights:
there must be no empty layers (`render.log` catches this as `thin wall`).

**Box and lid (PETG/ASA).** For sealing: 4 perimeters, 6 solid panel layers, flow
102–105 %. The sealing rib on the box rim is printed by the last layers as two
0.4 mm lines.

**Cap and ring (PLA/PETG).** 3 perimeters. The stem must have a brim — it is a
Ø6.8 × 26 mm column. No supports anywhere: every bridge is ≤ 8 mm, chamfers 45°.

## Assembly

1. Solder the cable, screw the board to the lid standoffs with 4 × M3×6. Take the
   cable out through a hole potted with compound (there is no gland hole by
   default).
2. Remove the stock bell knob from the joystick.
3. Fit the gasket onto the rib on the box rim by its groove — it holds itself
   there. Bring the lid with the board in from below (the joystick goes under the
   panel opening) and tighten 4 × M3×10 crosswise.
4. Push the cap stem, boss down, through the top opening of the boot and stretch
   the boot bead onto the stem groove (Ø18.5, ~6 % interference) so it seats on
   the flange lip.
5. Lower the boot with the stem onto the module: the stem seats on the joystick
   shaft (a socket with flats, 2 orientations), the grommet enters the panel
   opening until the lip clicks under the panel, and the cone comes flush with the
   panel.
6. From inside the box, insert the expander ring nose-up into the grommet opening
   and push until the flange seats under the lip. It passes the lip easily; you
   only need to push the last ~0.7 mm, until the band sits under the grommet rib.
   If it is too tight or, conversely, loose — that is a parameter, see
   [MODEL.md](MODEL.md).
7. Glue the cap head onto the stem plug (Ø8, 0.2 mm clearance). Its flat bottom
   covers the groove with the bead.

## Casting the boot in silicone (optional)

A printed boot runs into a minimum wall: 0.46 mm is one nozzle pass, it does not
get thinner, and stiffness grows as the cube of thickness. Silicone gets around
that with the material — A20 is roughly 50 times softer than TPU 95A, so even a
1.2 mm wall gives a boot about three times softer (with A10, about five times).
The geometry is the same: the same grommet, bead, ring and stem, both bellows
profiles.

The mould is calculated and verified by boolean tests (`check_fit.scad`), but not
yet printed and not yet poured.

To print (PLA or PETG, 3 perimeters, 20–30 % infill):

| Part | File `vNNN_…` | Qty |
|---|---|---|
| Shell half | `ky023_mould_shell.stl` | **2** (identical) |
| Core, lower half | `ky023_mould_core_lower.stl` | 1 |
| Core, upper half | `ky023_mould_core_upper.stl` | 1 |
| Shell dowels | `ky023_mould_dowel.stl` | **2** |
| Core pin | `ky023_mould_pin.stl` | 1 |

For the deep bellows, the same files with `_deep` (the core pin is shared).
The shell prints parting-plane up, no supports needed.
You will also need: 4 × M4×50 with nuts (40 mm clamp), a 10 ml syringe, and
release agent or thin petroleum jelly.

**How much silicone.** The part itself is 2.85 cm³ (standard bellows) or 3.02
(`deep`); together with the riser and the ports, the mould takes 3.6 / 3.8 ml.
Mix 5–6 ml: the rest stays in the syringe and the cup.

Procedure:

1. **Check compatibility first.** Platinum silicone is inhibited by some plastics
   — put a smear on an offcut of the same filament and see whether it cures within
   a day. Finding this out on a full mould is an expensive lesson. Then release
   agent on every surface.
2. Lower core half into the bottom of the shell, then the pin, then the upper half
   on top; its boss comes out through the roof of the shell.
3. Clamp the halves with 4 × M4 through the ears; the dowels centre them.
4. Degas the silicone and syringe it into the lower port until it comes out of the
   second port and the vent holes at the top.
5. After curing: bolts off, split the shell, pull the upper core half up by its
   boss and the lower one down.
6. Trim the flash along the parting line (carefully on the grommet — that is a
   sealing surface) and the riser ring on top.

You can check the result against `ky023_boot_cast.stl` — that is what the mould
should produce.
