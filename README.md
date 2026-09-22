**English** · [Українська](README.uk.md)

# Sealed enclosure for the KY-023 joystick

The KY-023 / HW-504 module costs a dollar and is open on every side: dust, dirt
and moisture go straight into the potentiometers. Here it lives in a closed box.
The only thing sticking out is the cap, and the motion is carried through a
printed TPU bellows boot that plugs the opening and re-centres the joystick at
the same time — the stock bell-shaped knob is no longer needed and comes off.

Fully parametric, a single OpenSCAD file, not one part needs supports.

![Assembled enclosure](docs/img/hero.png)

Box with lid: 62.4 × 39.1 × 23 mm, ≈53 mm tall including the cap.

```
./render.sh     # every STL + PNG + the automatic checks, into versions/vNNN-.../
```

Next: **[PRINTING.md](PRINTING.md)** — printing, assembly, silicone casting ·
**[MODEL.md](MODEL.md)** — how it works and which parameters to turn.

---

## What's inside

![Section through the assembly](docs/img/section.png)

The PCB is screwed to standoffs on the **bottom** lid — lid and board go into the
box from below, so there is not a single screw and not a single joint on top.
Between the box rim and the lid sits a flat TPU gasket. The boot sits in the top
panel by its grommet, and is clamped at the top onto the groove of the cap stem.

Three joints, three different answers:

| Joint | What holds it |
|---|---|
| boot ↔ cap | a Ø1.6 bead stretched onto the stem groove with 6 % interference, covered by the glued-on head |
| boot ↔ box | the grommet cone seats into the panel countersink **flush** with it, the lip presses from below, and a rigid ring inside stops the grommet from pulling itself inward |
| box ↔ lid | a 0.8 × 0.5 rib on the box rim presses into the gasket groove; around each screw the rib is interrupted and the gasket is solid there |

Here is that grommet up close — the corrugation on the left, the expander ring in
yellow underneath, the box wall on the right:

![Grommet in the panel](docs/img/seal.png)

Nothing protrudes above the panel for anything to catch on.

## Why it re-centres

The boot is printed in exactly the shape it takes once installed, so its only
equilibrium is the centre. No spring required.

The whole trick is making it soft enough. The wall is printed in a **single nozzle
pass** — 0.46 mm, physically as thin as it gets — and stiffness grows as the cube
of thickness. The rest is down to the geometry of the folds: fold stiffness is
∝ 1/depth³, so one deep fold is softer than several shallow ones.

| `bellows = "v019"` — two folds | `bellows = "deep"` — one deep fold |
|---|---|
| ![](docs/img/bellows-v019.png) | ![](docs/img/bellows-deep.png) |
| compliance index 0.46 · printed and verified on the module | index 0.91 — twice as soft on paper, not printed yet |

Both fit the same grommet, the same ring and the same stem groove — you can print
both and compare them on one module.

The model works this out itself and prints it to `ECHO` on every render:

```
ECHO: "Bellows "v019": meridian 27.9676 mm, rest chord 21.4529, last leg 33.4078 deg
       from vertical (keep <= 50), … compliance index 0.461043 (x 1/wall^3, higher = softer)"
ECHO: "At 25 deg: bead shifts 13.08 mm, … far-side stretch 3.95858 % (no stretch up to 21 deg)"
```

Up to 21° of tilt the far side of the boot only bends; stretch starts later and
reaches ~4 % at 25°. That is exactly why the bead is attached at the top of the
stem and not at the bottom, where the travel is half as long: those 13 mm of wall
length would cost 32 % stretch instead of 4, and stretch is no longer bending —
it is stiffness.

## Seven parts

| | | |
|---|---|---|
| ![](docs/img/part-boot.png) **Boot with grommet** — TPU, single-pass wall | ![](docs/img/part-ring.png) **Expander ring** — goes into the grommet from inside | ![](docs/img/part-cap.png) **Cap** — head + stem, glued together |
| ![](docs/img/part-box.png) **Box** — sealing rib on the rim, 4 bosses | ![](docs/img/part-lid.png) **Lid** — PCB standoffs, enters from below | ![](docs/img/part-gasket.png) **Gasket** — TPU, groove for the rib |

Plus a mock-up of the board — not for printing, it is there to check the joystick
and hole positions against your own module on screen:

![PCB mock-up](docs/img/pcb.png)

## Silicone instead of TPU

A printed boot runs into a 0.46 mm minimum wall. Silicone gets around that with
the material instead: A20 is roughly 50 times softer than TPU 95A, so even a
1.2 mm wall gives a boot about three times softer. The geometry stays the same.

![Section through the mould](docs/img/mould.png)

The mould is generated from the same model: two **identical** shell halves
(everything on the parting plane comes in ±X pairs, so one half rotated 180° is
the other), a core split at the waist of the corrugation — it cannot be pulled out
in one piece, being a barrel between two narrower openings — and pins. It is cast
bottom-up with a syringe: gravity will not fill a 1.2 mm annular gap over 28 mm of
height.

Procedure and quantities for silicone are in [PRINTING.md](PRINTING.md). So far
the mould is calculated and verified by boolean tests, but not printed.

## How it grew

Same camera throughout, sources from `versions/` — a copy of the `.scad` for every
render lives there.

| v001 | v005 | v006 |
|---|---|---|
| ![](docs/img/progress-v001.png) | ![](docs/img/progress-v005.png) | ![](docs/img/progress-v006.png) |
| Just an open boot over the joystick frame. No box yet, and no sealing either. | A grommet in the panel instead of a clamped sheet, lid moved to the bottom — no more screws on top. | **Printed.** The grommet cone seats into the countersink flush with the panel; the expander ring and the rounded edges appear. |

| v019 | now |
|---|---|
| ![](docs/img/progress-v019.png) | ![](docs/img/progress-now.png) |
| **Printed.** Measured joystick position on the board, two-part cap, bead moved onto the stem flange. | Two bellows profiles to choose from, a mould for casting, mesh checking on every render. |

The full history with the reasoning is at the end of [MODEL.md](MODEL.md).

## How this is verified

A render that looks right in a PNG proves nothing. So every `./render.sh` ends
with checks, and three more are run by hand:

| | |
|---|---|
| `check_mesh.py` | every STL must be **one closed body**: each edge in exactly two triangles, one body |
| `check_overhang.py` | slices the profile in 0.1 mm layers: islands, overhangs > 45°, cross-sections thinner than a slicer line |
| `check_fit.scad` | seven boolean tests of the mould — each exports what should not exist; ~0 mm³ should be left |
| `stl_volume.py` | volume, area and mean thickness 2·V/A — for a remainder that should have been zero, it is the thickness that matters, not the volume |
| `compare_versions.sh` | compares the STLs of two renders byte for byte: a part you did not touch must stay byte-identical |

This is not a formality. Two examples that brought these checks into being:

- **v021.** The boot wall was made a single 0.40 mm pass. The slicer silently
  dropped it at the bends, where the cross-section turns vertical, and empty
  layers appeared in the part. The cure is to model a single-pass wall as the
  slicer line width + 0.04 = 0.46 — and the `minw` check in `check_overhang.py`.
- **v026.** The mould shell would not slice, the slicer complained about
  non-manifold edges. The cause: the surface shared by the part and the core is
  drawn by different code — the wall by 24-gons, the core by true `offset()` arcs
  — and on the fold radii the two drifted apart by ~5 µm. Those slivers got
  pinched inside the cavity and left free 5 µm-thick rings in the shell. Invisible
  in a PNG, invisible in the volume. Hence `check_mesh.py` on every render.

And `compare_versions.sh` is the only honest way to tell "I rewrote the code" from
"I moved the geometry": neither a PNG nor a triangle count will tell you that.

## Status, honestly

- **Printed and assembled:** `v006` and `v019`. The default bellows profile is the
  one that is on the real module.
- **Not verified in plastic:** the `deep` bellows, the silicone mould.
- **Not measured:** the mounting hole pitch of the board. The KY-023 grid is not in
  any datasheet, and the community mock-up contradicts itself (text 26.7 × 20.3,
  STL 26.5 × 19.0). The model uses 26.7 × 20.3 — for M3 standoffs a 1 mm miss is
  already critical, so **measure your own board before the first print**. It is two
  parameters.
- IP68 here means designed for IP68, not certified: nobody has put it under
  pressure and measured.

## What you need

OpenSCAD 2021+ (Manifold backend), Python 3 for the checks, a printer with a 0.4
nozzle and a bed from 70 × 50 mm. Filaments: TPU for the boot and the gasket,
PETG/ASA for the box and the lid, PLA/PETG for the ring and the cap. Fasteners:
4 × M3×6 and 4 × M3×10.

The full list, slicer settings, assembly order and silicone casting are in
[PRINTING.md](PRINTING.md).

## License

MIT — [LICENSE](LICENSE). Print it, measure your own board, change the parameters,
sell what you print; the only condition is keeping the copyright line. No
warranty of any kind: see "Status, honestly" above.
