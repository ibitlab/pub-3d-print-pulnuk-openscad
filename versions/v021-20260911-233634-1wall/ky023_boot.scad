// =====================================================================
//  KY-023 thumb-joystick sealed (IP68) enclosure:
//  TPU bellows boot + expander ring + rigid cap + hermetic box + lid
// =====================================================================
//
//  Parts (all printed):
//    boot    TPU      grommet that sits in the countersunk hole of the box
//                     top panel (flush), conical bellows, top sealing bead
//    ring    PLA/PETG expander pushed into the grommet bore from inside the
//                     box (before the lid goes on): it squeezes the TPU
//                     against the hole, its flange presses the grommet lip
//                     against the panel underside, and it stops the grommet
//                     from collapsing inwards when the bellows pulls
//    cap     PLA/PETG replaces the stock 26.8 mm bell knob; two prints:
//                     cap_stem (socket for the post, neck, flange with the
//                     bead lip + groove core, plug) and cap_head (disc glued
//                     onto the plug; its flat underside closes the groove).
//                     The boot bead is pushed onto the groove core (~6 %
//                     stretch) before the head is glued on, so it never has
//                     to pass over the full head diameter
//    box     PETG/ASA one piece: top panel with the boot hole, walls, four
//                     corner screw bosses; open at the bottom
//    lid     PETG/ASA bottom plate with the PCB standoffs and a sealing rib
//    gasket  TPU      flat frame between the box rim and the lid, with a
//                     groove that locates the lid rib (exported groove up)
//
//  Sealing path: water -> head-rim groove (bead) -> bellows wall -> grommet
//                cone in the panel countersink + body squeezed between the
//                expander ring and the hole (ridge) + lip under the panel
//                -> box walls -> gasket under the lid rib.
//  No cable hole by default (gland_d = 0): pot the cable or drill on site.
//
//  Return-to-centre: the bellows is symmetric and printed in the exact
//  shape it has when installed, so the only equilibrium is the centre.
//  Two deep convolutions give ~25 mm of wall; the ECHO output reports up to
//  which tilt the far side only bends and how much it stretches at
//  tilt_deg (stretch pulls towards the centre, never away).
//
//  Printability (no supports anywhere):
//    boot   grommet down: lip chamfer, ridge and cone at 45 deg, inner
//           retaining lip 45 deg, bellows legs <= leg_deg, bead teardrop
//    ring   flange down: straight tube, 45 deg lead-in chamfer on top
//    cap_head  underside on the bed: true round-over and finger dish on
//              top, blind plug hole bridged (8 mm)
//    cap_stem  boss (socket) on the bed, brim: socket ceiling is a small
//              bridge, flange underside is a flange_cone_deg cone
//    box    upside down (top panel on the bed): bosses rise from the panel,
//           countersink and panel edge round-over stay within 45 deg
//    lid    outer face down: standoffs and rib print upwards
//  Bed-side edges are "printable rounds": 45 deg for the first layers,
//  then a true arc into the vertical face.
//
//  Coordinates: stick axis = Z, Z = 0 is the top of the joystick's steel
//  plate; the box panel sits panel_clear above the pot tops. mm.
//
//  Check on your module with calipers: PCB size and hole grid, the stick
//  offset from the PCB centre (pcb_dx), pot tops (pot_top_z, must stay
//  below the panel) and above all the centre post (post_type, post_d,
//  post_flat, post_h) - clones differ from the P3/SparkFun drawing.
// =====================================================================

/* [Part] */
// What to render / export
part = "boot"; // [boot, ring, cap_head, cap_stem, cap, cap_section, box, lid, gasket, section, assembly, assembly_section, mock]

/* [Printing] */
// Nozzle / line width
nozzle_d = 0.4; // [0.3:0.1:0.6]
// Bellows wall thickness in perimeters (passes) of the nozzle
wall_lines = 1; // [1:1:4]
// Segments per revolution
fn_round = 144; // [48:12:240]

/* [Joystick module (measure with calipers)] */
// Square steel frame width (mock-up only)
frame_w = 16.0;
// Top plate height above the PCB
plate_h = 12.2;
// Round opening in the top plate (mock-up only)
opening_d = 11.0;
// Gimbal centre relative to the plate top
pivot_z = -6.7;
// Centre post the cap presses onto. MEASURE IT: "dd" = round with two flats
// (typical KY-023 clone, ~4.0 mm, 3.0 across flats), "d" = round with one
// flat (Alps RKJXV: 4.0 / 3.0), "rect" = 1.15 x 1.85 (P3 America 802 /
// SparkFun COM-09032 drawing, Detail A-A')
post_type = "dd"; // [dd, d, rect]
// Round post: diameter and across-flats (d: flat-to-round distance)
post_d = 4.08;
post_flat = 3.12;
// Rectangular post: width x length
post_w = 1.15;
post_l = 1.85;
// Exposed post height above the plate
post_h = 7.2;
// Pot tops relative to the plate top (must stay under the panel hole)
pot_top_z = -1.0;
// PCB size and thickness (measured 34.4 x 26.07)
pcb_l = 34.4;
pcb_w = 26.07;
pcb_t = 1.6;
// Layout (from the HW-504 / KY-023 photo): the header sits on the -X short
// edge; the tact switch is on the -Y long edge with one pot opposite it on
// +Y; the other pot faces the +X short edge.
// PCB centre relative to the stick axis. Measured: along the 34.4 mm length
// the stick is centred (pcb_dx = 0); across the width it is 14.05 mm from
// the switch-side long edge -> pcb_dy = 14.05 - pcb_w / 2 = ... negative
// because the switch edge is on -Y: pcb_dy = pcb_w / 2 - 14.05
pcb_dx = 0;
pcb_dy = 26.07 / 2 - 14.05;
// PCB mounting hole grid (along / across the PCB) and hole diameter. NOT
// measured yet: the mock-up's text says 26.7 x 20.3, its STL 26.5 x 19.0
pcb_hole_dx = 26.7;
pcb_hole_dy = 20.3;
pcb_hole_d = 3.2;
// Hole grid centre relative to the PCB centre along the length (+ = away
// from the header): B = header-end edge to the nearest hole centres, then
// hole_dx = B + pcb_hole_dx / 2 - pcb_l / 2
hole_dx = 0;
// Working tilt of the stick
tilt_deg = 25; // [15:35]
// Stick push-down (button) travel
push_travel = 1.5;

/* [Boot and expander ring] */
// Grommet bore diameter (= expander ring bottom diameter)
grommet_in_d = 27.2; // [26:0.2:29]
// Radial interference of the grommet body in the panel hole (before expansion)
grommet_squeeze = 0.3; // [0:0.1:1]
// Sealing ridge on the grommet body (45 deg triangle)
grommet_ridge = 0.3;
// Lip under the panel: radial protrusion and height (45 deg entry chamfer)
lip_out = 1.0;
lip_h = 1.2;
// Small inward lip at the top of the bore that snaps over the ring (45 deg)
ring_lip = 0.5;
// Expander ring: inner diameter, radial expansion of the bore, lead-in
// chamfer at its top, flange under the grommet lip: thickness and outer radius
ring_in_d = 24.0;
ring_expand = 0.4; // [0.2:0.1:0.8]
ring_chamfer = 0.5;
ring_flange_t = 1.0;
ring_flange_r = 15.5;
// Bellows foot radius (wall centreline), must sit on the grommet top face
base_r = 14.6; // [14:0.2:16]
// Vertical lift of the wall above the grommet before the first fold
lift = 0.6;
// Fold legs angle from vertical (45 = safe TPU overhang, 50 with 0.15 mm layers)
leg_deg = 45; // [40:55]
// Radial travel of each fold leg from the grommet upwards (+ outward,
// - inward); every leg climbs at leg_deg, the last leg runs from the end of
// this list to the bead. Soft default: one short outward step over the
// panel, then one very deep inward fold, then out again. Depth is the
// softness lever (stiffness ~ 1/depth^3); the neck (r 4 + 2 mm) limits the
// inward travel, the box width and the cap-head sweep limit the outward one.
fold_dr = [2.0, -10.2, 5.3];
// Corner rounding of the folds (centreline radius); bigger = gentler hinges
fold_r = 1.2; // [0.8:0.1:2.5]
// Sealing bead at the top: diameter and radial interference in the head groove
bead_d = 1.6; // [1.2:0.1:2.4]
bead_squeeze = 0.5; // [0:0.05:1]
// Vertical wall under the bead (the bead teardrop runs down it, so the bead
// prints without overhang whatever the last leg angle) and teardrop length
bead_stub = 1.0; // [0.5:0.1:3]
bead_run = 1.0; // [0.5:0.1:3]

/* [Cap (rigid, PLA/PETG)] */
// Neck diameter
neck_d = 8.0; // [6:0.5:12]
// Cap head underside height above the plate
cap_under_z = 22.8; // [14:0.5:26]
// Bead groove on the stem flange: flat lip under it, width, depth; the glued
// head closes it from above
groove_lip = 0.6;
groove_w = 1.7;
groove_depth = 0.7;
// Overhang angle (from vertical) of the cone under the flange, stem printed boss-down
flange_cone_deg = 60; // [45:5:65]
// Head diameter / body height above the groove / top fillet
head_d = 19.9;
head_body_h = 5.5;
head_fillet = 1.5;
// Plug of the stem into the head: height, diametral clearance of the hole
plug_h = 3.0;
plug_clear = 0.2;
// Socket boss around the post: wall around the socket, start height, height
boss_wall = 1.2;
cap_boss_z0 = 2.5;
cap_boss_h = 3.0;
// Entry chamfer of the socket (kept small: it is the first layer when printed boss-down)
socket_chamfer = 0.3;
// Socket clearance per side (FDM holes print ~0.1 mm small per side, so
// 0.15 gives a light press fit; 0.1 if loose, 0.2 if it will not go on),
// extra depth beyond the post tip, entry chamfer at the socket mouth
socket_clear = 0.15; // [0:0.05:0.4]
socket_extra = 0.3;
// Finger dish on the head top: sphere radius and depth (0 = flat)
dish_r = 30;
dish_depth = 0.8; // [0:0.2:2]

/* [Box, lid, gasket (rigid + TPU)] */
// Wall and top panel thickness
wall_t = 2.5; // [2:0.5:4]
panel_t = 2.5; // [2:0.5:4]
// Gap between the pot tops and the panel underside (the ring flange sits
// below the grommet lip, outside the pots: keep the lip above pot_top_z)
panel_clear = 1.3;
// Boot hole in the panel and its 45 deg countersink depth (grommet cone sits flush)
hole_d = 29.4;
cs_depth = 1.0;
// Across the width the box is centred on the stick axis (the PCB is off by
// pcb_dy, so the panel hole is in the middle); along the length the cavity
// follows the PCB: free length beyond the header end (connector / cable
// room), clearance beyond the far end and beside the long edges
cav_end = 20.0; // [5:5:40]
cav_far = 3.0; // [1:0.5:10]
cav_side = 3.0; // [1:0.5:6]
cav_r = 2.0;
box_r = 5.0;
// Round-over radius of the panel edge and of the lid outer edge
box_edge_r = 2.5; // [0:0.5:4]
lid_edge_r = 1.5; // [0:0.5:3]
// Tangent angle of the round-over where it meets the bed (both edges are on
// the bed when printed): 0 = full quarter circle, 45 = never steeper than
// 45 deg. 30 looks smooth and only the first ~0.3 r exceeds 45 deg.
edge_start_deg = 30; // [0:5:45]
// Corner screw bosses: diameter, self-tapping hole (M3), clearance hole
screw_boss_d = 6.0;
screw_hole_d = 2.6;
screw_clear_d = 3.4;
// PCB standoffs on the lid: diameter and height (pins need >= 3 mm)
standoff_d = 6.0;
standoff_h = 3.7;
// Lid thickness, gasket thickness, sealing rib width / height
lid_t = 2.5; // [2:0.5:4]
gasket_t = 1.5;
rib_w = 1.0;
rib_h = 0.5;
// Gasket: outline inset from the box (0 = flush), groove for the rib (width =
// rib_w + nozzle_d), how much the rib still presses into the TPU
gasket_inset = 0; // [0:0.1:0.5]
gasket_press = 0.2; // [0:0.1:0.5]
// Cable gland hole on the header (-X) wall, teardrop (0 = none; 12.5 = PG7)
gland_d = 0; // [0:0.5:16]

/* [Hidden] */
eps = 0.01;
$fn = 48;
wall = wall_lines * nozzle_d; // bellows wall thickness

// ---------------------------------------------------------------------
//  Derived geometry
// ---------------------------------------------------------------------
cav_lx = pcb_l + cav_end + cav_far;
box_cx = pcb_dx + (cav_far - cav_end) / 2; // bay on the header (-X) side
box_cy = 0; // centred on the stick across the width
cav_y = 2 * (abs(pcb_dy) + pcb_w / 2 + cav_side);
box_lx = cav_lx + 2 * wall_t;
box_ly = cav_y + 2 * wall_t;
panel_bot = pot_top_z + panel_clear;
panel_top = panel_bot + panel_t;
z_pcb_bot = -plate_h - pcb_t;
z_lid_in = z_pcb_bot - standoff_h; // lid inner face
z_rim = z_lid_in + gasket_t; // box bottom rim
z_lid_out = z_lid_in - lid_t;
boss_in = screw_boss_d / 2 + 0.8; // boss centre from the outer edge
screw_xy = [
  for (sx = [-1, 1], sy = [-1, 1]) [box_cx + sx * (box_lx / 2 - boss_in), box_cy + sy * (box_ly / 2 - boss_in)],
];
pcb_holes = [
  for (sx = [-1, 1], sy = [-1, 1]) [pcb_dx + hole_dx + sx * pcb_hole_dx / 2, pcb_dy + sy * pcb_hole_dy / 2],
];
pcb_corner = [pcb_dx + pcb_l / 2, pcb_dy + pcb_w / 2];
gland_z = (z_rim + panel_bot) / 2;

// grommet and ring
hole_r = hole_d / 2;
r_in = grommet_in_d / 2;
r_g = hole_r + grommet_squeeze; // body radius (printed)
z_g0 = panel_bot - 0.1; // lip top face
z_lip0 = z_g0 - lip_h;
z_cs = panel_top - cs_depth; // countersink starts here
z_mid = (z_g0 + z_cs) / 2; // ridge height
r_cone = r_g + cs_depth; // cone radius at the panel top
ring_r1 = r_in + ring_expand; // ring tube radius (bore expanded)
ring_z0 = z_lip0 - ring_flange_t; // flange underside

// cap and head bead
socket_max = (post_type == "rect" ? max(post_w, post_l) : post_d) + 2 * socket_clear;
cap_boss_d = socket_max + 2 * boss_wall;
socket_depth = post_h - cap_boss_z0 + socket_extra;
neck_z0 = cap_boss_z0 + cap_boss_h + (neck_d - cap_boss_d) / 2; // 45 deg cone
groove_r = head_d / 2 - groove_depth;
groove_z = cap_under_z + groove_lip + groove_w / 2; // bead centre height
bead_rc = groove_r - bead_squeeze + bead_d / 2; // bead centre radius (printed)
head_z0 = cap_under_z + groove_lip + groove_w; // head underside = groove top wall
cone_h = (head_d / 2 - neck_d / 2) / tan(flange_cone_deg); // flange underside cone

// Bellows meridian knots (wall centreline): flange -> zigzag legs -> bead
K0 = [base_r, panel_top - 1.0];
K1 = [base_r, panel_top + lift];
function knots(i, p) =
  i >= len(fold_dr) ? [p]
  : concat([p], knots(i + 1, p + [fold_dr[i], abs(fold_dr[i]) / tan(leg_deg)]));
K_legs = knots(0, K1);
K_last = K_legs[len(K_legs) - 1];
K5 = [bead_rc, groove_z]; // bead
K_stub = [bead_rc, groove_z - bead_stub]; // start of the vertical wall under the bead
last_leg = K_stub - K_last;
last_leg_deg = atan2(abs(last_leg[0]), last_leg[1]); // from vertical
inner_r = min([for (k = K_legs) k[0]]) - wall / 2; // closest the wall gets to the axis
// Relative compliance of the fold stack (EJMA-style, legs in series): each leg
// of radial depth w at mean radius rm contributes w^3 / rm^3; wall^3 is a
// common factor. Higher = softer. Only for comparing fold patterns.
K_all = concat(K_legs, [K_stub]);
compliance = [
  for (i = [1:len(K_all) - 1]) let (w = abs(K_all[i][0] - K_all[i - 1][0]), rm = (K_all[i][0] + K_all[i - 1][0]) / 2) pow(w, 3) / pow(rm, 3),
] * [for (i = [1:len(K_all) - 1]) 1];

function unit(v) = v / norm(v);
function arc(c, r, a0, a1, n) = [for (i = [0:n]) c + r * [cos(a0 + (a1 - a0) * i / n), sin(a0 + (a1 - a0) * i / n)]];
// Replace corner p1 by a tangent arc of radius r (clamped to the segments)
function fillet(p0, p1, p2, r, n = 6) =
  let (
    d1 = unit(p0 - p1),
    d2 = unit(p2 - p1),
    half = acos(max(-1, min(1, d1 * d2))) / 2,
    rr = min(r, 0.45 * min(norm(p0 - p1), norm(p2 - p1)) * tan(half)),
    dist = rr / tan(half),
    t1 = p1 + d1 * dist,
    t2 = p1 + d2 * dist,
    c = p1 + unit(d1 + d2) * rr / sin(half),
    a1 = atan2(t1[1] - c[1], t1[0] - c[0]),
    a2 = atan2(t2[1] - c[1], t2[0] - c[0]),
    da = ( (a2 - a1 + 540) % 360) - 180
  ) arc(c, rr, a1, a1 + da, n);
function rounded_path(k, r) =
  concat(
    [k[0]],
    [for (i = [1:len(k) - 2]) each fillet(k[i - 1], k[i], k[i + 1], r)], [k[len(k) - 1]]
  );
function path_len(p) = len(p) < 2 ? 0 : norm(p[1] - p[0]) + path_len([for (i = [1:len(p) - 1]) p[i]]);

// fillets on the fold knots only; the stub corner stays sharp so the bead
// teardrop sits on an exactly vertical wall
meridian = concat(rounded_path(concat([K0], K_legs, [K_stub]), fold_r), [K5]);
meridian_len = path_len(meridian) - 1.0; // minus the buried stub
rest_chord = norm(K5 - K1);
// Point (r, z) fixed to the stick after tilting by ang about the pivot (r may be negative)
function tilt_pt(p, ang) =
  [
    p[0] * cos(ang) + (p[1] - pivot_z) * sin(ang),
    -p[0] * sin(ang) + (p[1] - pivot_z) * cos(ang) + pivot_z,
  ];
function chord_at(ang) =
  let (far = tilt_pt([-bead_rc, groove_z], ang), near = tilt_pt([bead_rc, groove_z], ang)) [norm(far - [-base_r, K1[1]]), norm(near - [base_r, K1[1]])];
function stretch_at(ang) = max(0, (chord_at(ang)[0] / meridian_len - 1) * 100);
lat = (groove_z - pivot_z) * sin(tilt_deg); // bead shift at tilt
no_stretch_deg = [for (a = [5:1:40]) if (stretch_at(a) == 0) a][len([for (a = [5:1:40]) if (stretch_at(a) == 0) a]) - 1];
head_edge = tilt_pt([head_d / 2, cap_under_z], tilt_deg);
// Tilt at which the boss bottom corner would reach the plate outside its opening
function boss_ok(a) = let (p = tilt_pt([cap_boss_d / 2, cap_boss_z0], a)) p[1] >= 0 || p[0] <= opening_d / 2;
boss_tilt_max = [for (a = [0:1:45]) if (boss_ok(a)) a][len([for (a = [0:1:45]) if (boss_ok(a)) a]) - 1];

echo(
  str(
    "Box ", box_lx, " x ", box_ly, " x ", panel_top - z_lid_out, " mm (with lid), hole centred across; free length beyond the PCB ends ",
    (pcb_dx - pcb_l / 2) - (box_cx - cav_lx / 2), " / ", (box_cx + cav_lx / 2) - (pcb_dx + pcb_l / 2), " mm, panel hole d ", hole_d,
    ", PCB corner to boss axis ", norm(pcb_corner - screw_xy[3]), " mm (boss r ", screw_boss_d / 2, ")"
  )
);
echo(
  str(
    "PCB: stick ", pcb_w / 2 - pcb_dy, " mm from the switch-side long edge, ", pcb_l / 2 - pcb_dx,
    " from the header edge, ", pcb_l / 2 + pcb_dx, " from the far edge; holes ",
    pcb_l / 2 - pcb_hole_dx / 2 + hole_dx, " from the header edge (B) and ", (pcb_w - pcb_hole_dy) / 2,
    " from the long edges; standoffs at ", pcb_holes
  )
);
echo(
  str(
    "Grommet: body r ", r_in, "..", r_g, " in hole r ", hole_r, ": squeeze ", (r_g / hole_r - 1) * 100,
    " % printed, ", ( (r_g + ring_expand) / hole_r - 1) * 100, " % with the ring; lip passes the hole with ",
    ( (r_g + lip_out) / hole_r - 1) * 100, " % stretch; panel ", panel_bot, "..", panel_top, ", pots top ", pot_top_z
  )
);
echo(
  str(
    "Bellows: meridian ", meridian_len, " mm, rest chord ", rest_chord, ", last leg ", last_leg_deg,
    " deg from vertical (keep <= 50), innermost wall r ", inner_r, " (neck r ", neck_d / 2,
    "), compliance index ", compliance, " (x 1/wall^3)"
  )
);
echo(
  str(
    "At ", tilt_deg, " deg: bead shifts ", lat, " mm, far/near chords ", chord_at(tilt_deg),
    " -> far-side stretch ", stretch_at(tilt_deg), " % (no stretch up to ", no_stretch_deg,
    " deg, ", stretch_at(20), " % at 20 deg); head edge at r ", head_edge[0], " z ", head_edge[1]
  )
);
echo(
  str(
    "Cap socket: post_type ", post_type, ", socket ", post_type == "rect" ? str(post_w + 2 * socket_clear, " x ", post_l + 2 * socket_clear)
    : str("d ", post_d + 2 * socket_clear, " flats ", post_flat + 2 * socket_clear), ", depth ", socket_depth,
    " from z ", cap_boss_z0, "; boss d ", cap_boss_d, " clears the plate opening up to ", boss_tilt_max, " deg"
  )
);
echo(
  str(
    "Bead: ID ", 2 * (bead_rc - bead_d / 2), " pushed onto the groove core d ", 2 * groove_r,
    " (", (groove_r / (bead_rc - bead_d / 2) - 1) * 100, " % stretch = squeeze in the groove); flange cone ",
    cone_h, " mm tall, bellows top knot at ", K_last
  )
);
if (K_last[1] > cap_under_z - cone_h + (K_last[0] - neck_d / 2) * tan(flange_cone_deg) && K_last[0] < head_d / 2)
  echo("WARNING: bellows top knot inside the flange cone - shorten fold_dr or raise cap_under_z");
if (last_leg_deg > 50) echo("WARNING: last bellows leg too flat to print - raise cap_under_z or change fold_dr");
if (last_leg[1] < 0) echo("WARNING: fold legs taller than the bead height - shorten fold_dr or raise cap_under_z");
if (inner_r < neck_d / 2 + 2) echo("WARNING: bellows too close to the neck - reduce the inward travel in fold_dr");
if (max([for (k = K_legs) k[0]]) + wall / 2 > box_ly / 2 - box_edge_r) echo("WARNING: bellows reaches over the box edge round-over - reduce the outward travel in fold_dr");
if (base_r - wall / 2 < r_in + ring_lip || base_r + wall / 2 > r_cone) echo("WARNING: bellows foot is off the grommet top face");
if (cs_depth >= panel_t - 0.8) echo("WARNING: countersink too deep for the panel");
if (lip_out > lip_h) echo("WARNING: lip_out must not exceed lip_h (45 deg chamfer)");
if (z_lip0 < pot_top_z) echo("WARNING: grommet lip below the pot tops - raise panel_clear");
if (ring_flange_r > r_g + lip_out) echo("WARNING: ring flange wider than the grommet lip");
if (hole_r >= cav_y / 2) echo("WARNING: panel hole wider than the cavity");
if (pot_top_z > 0) echo("WARNING: pots above the panel top");
if (pcb_dx - pcb_l / 2 < box_cx - cav_lx / 2 + 1 || pcb_dx + pcb_l / 2 > box_cx + cav_lx / 2 - 1 || pcb_w / 2 + 1 > cav_y / 2)
  echo("WARNING: PCB too close to the cavity walls");
// Standoffs vs the joystick footprint blocks [x0, y0, x1, y1] (mock-up geometry)
footprint = [[-8, -8, 8, 8], [-6, 8, 6, 11.6], [8, -6, 11, 6], [-3.25, -14.5, 3.25, -8.5]];
function box_dist(p, b) = norm([max(b[0] - p[0], 0, p[0] - b[2]), max(b[1] - p[1], 0, p[1] - b[3])]);
for (p = pcb_holes)
  for (b = footprint)
    if (box_dist(p, b) < standoff_d / 2)
      echo(str("WARNING: standoff at ", p, " collides with a joystick component block ", b));
if (boss_tilt_max < tilt_deg) echo("WARNING: cap boss hits the plate opening before tilt_deg - raise cap_boss_z0");

// ---------------------------------------------------------------------
//  2D helpers
// ---------------------------------------------------------------------
module rr(x, y, r) { offset(r=r) square([x - 2 * r, y - 2 * r], center=true); }
module box_outline() { translate([box_cx, box_cy]) rr(box_lx, box_ly, box_r); }
module cav_outline() { translate([box_cx, box_cy]) rr(cav_lx, cav_y, cav_r); }
module stroke2d(pts, w) {
  for (i = [0:len(pts) - 2])
    hull() {
      translate(pts[i]) circle(d=w, $fn=24);
      translate(pts[i + 1]) circle(d=w, $fn=24);
    }
}
// Post cross-section with clearance c per side (socket) or c = 0 (mock post)
module post2d(c = 0) {
  if (post_type == "rect")
    square([post_w + 2 * c, post_l + 2 * c], center=true);
  else
    intersection() {
      circle(d=post_d + 2 * c, $fn=48);
      if (post_type == "dd")
        square([post_d + 2 * c + 1, post_flat + 2 * c], center=true);
      else // one flat, flat-to-round = post_flat
      translate([-(post_d + 2 * c + 1) / 2, -post_d / 2 - c]) square([post_d + 2 * c + 1, post_flat + 2 * c]);
    }
}
// Teardrop for a horizontal hole; peak towards 2D +X = world -Z after
// rotate([0, 90, 0]) (the box prints upside down)
module teardrop2d(d) { circle(d=d); rotate(-45) square(d / 2); }
// Extrude a convex 2D child by h with a round-over of radius r on the bed
// side at the bottom (rb) and/or the top (rt) - "top" means the face that
// lies on the bed when the part is printed upside down. The arc runs from
// edge_start_deg (tangent angle from horizontal at the bed) to vertical; the
// remaining height down to the bed is a straight run-out at that angle.
module bed_round_slabs(r, h, flip) {
  n = 24;
  a0 = edge_start_deg;
  for (i = [0:n])
    let (a = a0 + (90 - a0) * i / n, dz = r * (1 - cos(a)), dr = r * (1 - sin(a)))
    translate([0, 0, flip ? h - dz - eps : dz]) linear_extrude(eps) offset(r=-dr) children();
  // straight run-out from the arc start down to the bed plane
  dz0 = r * (1 - cos(a0));
  translate([0, 0, flip ? h - eps : 0]) linear_extrude(eps)
      offset(r=-(r * (1 - sin(a0)) + (a0 > 0 ? dz0 / tan(a0) : 0))) children();
}
module rounded_extrude(h, rb = 0, rt = 0) {
  hull() {
    if (rb > 0) bed_round_slabs(rb, h, false) children();
    translate([0, 0, rb]) linear_extrude(max(eps, h - rb - rt)) children();
    if (rt > 0) bed_round_slabs(rt, h, true) children();
  }
}

// ---------------------------------------------------------------------
//  Boot (TPU) - print grommet down, bellows up, no supports
// ---------------------------------------------------------------------
module grommet2d() {
  polygon(
    [
      [r_in, z_lip0],
      [r_g, z_lip0],
      [r_g + lip_out, z_lip0 + lip_out], // 45 deg entry chamfer
      [r_g + lip_out, z_g0], // lip outer face
      [r_g, z_g0], // flat lip top (holds under the panel)
      [r_g, z_mid - grommet_ridge],
      [r_g + grommet_ridge, z_mid], // sealing ridge
      [r_g, z_mid + grommet_ridge],
      [r_g, z_cs],
      [r_cone, panel_top], // 45 deg cone into the countersink, flush top
      [r_in + ring_lip, panel_top],
      [r_in, panel_top - ring_lip], // inward lip that snaps over the ring
    ]
  );
}

// Expander ring (rigid): pushed up into the grommet bore from inside the box
// until the flange seats under the grommet lip and the top snaps under the
// inner lip of the bore
module ring() {
  rotate_extrude($fn=fn_round) polygon(
      [
        [ring_in_d / 2, ring_z0],
        [ring_flange_r, ring_z0],
        [ring_flange_r, z_lip0], // flange under the grommet lip
        [ring_r1, z_lip0],
        [ring_r1, panel_top - ring_chamfer], // straight tube
        [ring_r1 - ring_chamfer, panel_top], // lead-in / snap chamfer
        [ring_in_d / 2, panel_top],
      ]
    );
}

module boot() {
  rotate_extrude($fn=fn_round) {
    grommet2d();
    stroke2d(meridian, wall);
    hull() {
      // bead as a teardrop down the vertical stub
      translate(K5) circle(d=bead_d, $fn=32);
      translate(K5 - [0, min(bead_run, bead_stub)]) circle(d=wall, $fn=24);
    }
  }
}

// ---------------------------------------------------------------------
//  Cap (rigid) - print head down, neck up
// ---------------------------------------------------------------------
// Head: a disc glued onto the stem plug; printed underside down.
module cap_head() {
  r = head_d / 2;
  f = head_fillet;
  difference() {
    translate([0, 0, head_z0]) rotate_extrude($fn=fn_round) polygon(
          concat(
            [[0, 0], [r, 0], [r, head_body_h - f]],
            [for (i = [0:8]) let (a = 90 * i / 8) [r - f + f * cos(a), head_body_h - f + f * sin(a)]],
            [[0, head_body_h]]
          )
        );
    // blind hole for the stem plug (its ceiling is an 8 mm bridge)
    translate([0, 0, head_z0 - 1]) cylinder(d=neck_d + plug_clear, h=plug_h + 1, $fn=fn_round);
    // finger dish
    if (dish_depth > 0)
      translate([0, 0, head_z0 + head_body_h + dish_r - dish_depth]) sphere(r=dish_r, $fn=fn_round);
  }
}

// Stem: socket boss, neck, flange (cone, bead lip, groove core), plug.
// Printed boss-down.
module cap_stem() {
  difference() {
    union() {
      translate([0, 0, cap_boss_z0]) cylinder(d=cap_boss_d, h=cap_boss_h + eps, $fn=fn_round);
      translate([0, 0, cap_boss_z0 + cap_boss_h - eps])
        cylinder(d1=cap_boss_d, d2=neck_d, h=(neck_d - cap_boss_d) / 2 + eps, $fn=fn_round);
      translate([0, 0, neck_z0 - eps])
        cylinder(d=neck_d, h=cap_under_z - cone_h - neck_z0 + 2 * eps, $fn=fn_round);
      translate([0, 0, cap_under_z - cone_h])
        cylinder(d1=neck_d, d2=head_d, h=cone_h + eps, $fn=fn_round);
      // flange cone
      translate([0, 0, cap_under_z]) cylinder(d=head_d, h=groove_lip + eps, $fn=fn_round); // bead lip
      translate([0, 0, cap_under_z + groove_lip]) cylinder(r=groove_r, h=groove_w + eps, $fn=fn_round); // groove core
      translate([0, 0, head_z0 - eps]) cylinder(d=neck_d, h=plug_h - 0.5 + 2 * eps, $fn=fn_round);
      translate([0, 0, head_z0 + plug_h - 0.5])
        cylinder(d1=neck_d, d2=neck_d - 1, h=0.5, $fn=fn_round);
      // plug chamfer
    }
    // keyed socket for the centre post, with an entry chamfer at its mouth
    translate([0, 0, cap_boss_z0 - eps]) linear_extrude(socket_depth + eps) post2d(socket_clear);
    translate([0, 0, cap_boss_z0 - eps]) hull() {
        linear_extrude(eps) post2d(socket_clear + socket_chamfer);
        translate([0, 0, socket_chamfer]) linear_extrude(eps) post2d(socket_clear);
      }
  }
}

module cap() { cap_head(); cap_stem(); }

// ---------------------------------------------------------------------
//  Box (rigid) - one piece, open bottom; print upside down (panel on bed)
// ---------------------------------------------------------------------
module box() {
  difference() {
    union() {
      difference() {
        translate([0, 0, z_rim]) rounded_extrude(panel_top - z_rim, rt=box_edge_r) box_outline();
        translate([0, 0, z_rim - 1]) linear_extrude(panel_bot - z_rim + 1) cav_outline();
      }
      for (p = screw_xy) translate([p[0], p[1], z_rim]) cylinder(d=screw_boss_d, h=panel_bot - z_rim + eps);
    }
    // boot hole in the panel with a 45 deg countersink at the top
    translate([0, 0, panel_bot - 1]) cylinder(r=hole_r, h=panel_t + 2, $fn=fn_round);
    translate([0, 0, z_cs]) cylinder(r1=hole_r, r2=hole_r + cs_depth + 1, h=cs_depth + 1, $fn=fn_round);
    // screw holes in the bosses, from the rim
    for (p = screw_xy) translate([p[0], p[1], z_rim - 1]) cylinder(d=screw_hole_d, h=9);
    // optional cable gland on the header (-X) wall
    if (gland_d > 0)
      translate([box_cx - box_lx / 2 + wall_t / 2, box_cy, gland_z])
        rotate([0, 90, 0]) linear_extrude(wall_t * 2, center=true) teardrop2d(gland_d);
  }
}

// ---------------------------------------------------------------------
//  Lid (rigid) - bottom plate; print outer face down
// ---------------------------------------------------------------------
module lid() {
  difference() {
    translate([0, 0, z_lid_out]) rounded_extrude(lid_t, rb=lid_edge_r) box_outline();
    for (p = screw_xy) translate([p[0], p[1], z_lid_out - 1]) cylinder(d=screw_clear_d, h=lid_t + 2);
  }
  // sealing rib into the gasket, centred on the wall
  translate([0, 0, z_lid_in - eps]) linear_extrude(rib_h + eps) difference() {
        offset(r=wall_t / 2 + rib_w / 2) cav_outline();
        offset(r=wall_t / 2 - rib_w / 2) cav_outline();
      }
  // PCB standoffs
  for (p = pcb_holes)
    translate([p[0], p[1], z_lid_in - eps]) difference() {
        cylinder(d=standoff_d, h=standoff_h + eps);
        translate([0, 0, -0.8]) cylinder(d=screw_hole_d, h=standoff_h + 1);
      }
}

// ---------------------------------------------------------------------
//  Gasket (TPU) - flat frame covering the rim and the boss tops
// ---------------------------------------------------------------------
module gasket() {
  groove_d = max(0, rib_h - gasket_press);
  difference() {
    translate([0, 0, z_lid_in]) linear_extrude(gasket_t) difference() {
          offset(delta=-gasket_inset) box_outline();
          difference() {
            cav_outline();
            for (p = screw_xy) translate(p) circle(d=screw_boss_d + 0.6);
          }
          for (p = screw_xy) translate(p) circle(d=screw_clear_d);
        }
    // groove for the lid rib on the lid side (print the gasket groove up)
    if (groove_d > 0)
      translate([0, 0, z_lid_in - 1]) linear_extrude(1 + groove_d) difference() {
            offset(r=wall_t / 2 + (rib_w + nozzle_d) / 2) cav_outline();
            offset(r=wall_t / 2 - (rib_w + nozzle_d) / 2) cav_outline();
          }
  }
}

// ---------------------------------------------------------------------
//  Simplified KY-023 mock-up (visualisation only)
// ---------------------------------------------------------------------
module half() {
  intersection() {
    children();
    translate([-100, 0, -100]) cube([200, 200, 200]);
  }
}
module cpart(col, cut) { color(col) if (cut) half() children(); else children(); }

module mock(cut = false) {
  cpart("darkgreen", cut) difference() {
      translate([pcb_dx - pcb_l / 2, pcb_dy - pcb_w / 2, z_pcb_bot]) cube([pcb_l, pcb_w, pcb_t]);
      for (p = pcb_holes) translate([p[0], p[1], z_pcb_bot - 1]) cylinder(d=pcb_hole_d, h=pcb_t + 2);
    }
  cpart("white", cut) translate([-9.8, -8, -plate_h]) cube([17.8, 16, 4]);
  cpart("silver", cut) difference() {
      translate([-8, -8, -plate_h]) cube([16, 16, plate_h]);
      translate([-7.5, -7.5, -plate_h - 1]) cube([15, 15, plate_h + 0.5]);
      cylinder(d=opening_d, h=10, center=true);
    }
  cpart("dimgray", cut) {
    translate([-6, 8, -plate_h]) cube([12, 3.6, plate_h + pot_top_z]); // pot opposite the switch (+Y)
    translate([8, -6, -plate_h]) cube([3, 12, plate_h + pot_top_z]); // pot facing the far edge (+X)
  }
  cpart("black", cut) translate([-3.25, -14.5, -plate_h]) cube([6.5, 6, plate_h - 4.9]); // tact switch (-Y)
  cpart("black", cut) translate([pcb_dx - pcb_l / 2 + 0.5, pcb_dy - 6.35, -plate_h]) cube([2.5, 12.7, 2.5]); // header (-X)
  cpart("white", cut) intersection() {
      translate([0, 0, pivot_z]) sphere(r=-pivot_z + 0.5, $fn=64);
      translate([-7, -7, -3]) cube([14, 14, 3.5]);
    }
  cpart("gold", cut) translate([0, 0, 0.3]) linear_extrude(post_h - 0.3) post2d();
}

module assembly(cut = false) {
  mock(cut);
  cpart([0.55, 0.6, 0.65], cut) box();
  cpart([0.35, 0.4, 0.45], cut) lid();
  cpart([0.2, 0.35, 0.7], cut) gasket();
  cpart("orange", cut) cap();
  cpart([0.25, 0.5, 0.9], cut) boot();
  cpart([0.9, 0.8, 0.3], cut) ring();
}

// ---------------------------------------------------------------------
//  Part selector
// ---------------------------------------------------------------------
if (part == "boot")
  boot();
else if (part == "ring")
  translate([0, 0, -ring_z0]) ring();
else if (part == "cap_head")
  translate([0, 0, -head_z0]) cap_head();
else if (part == "cap_stem")
  translate([0, 0, -cap_boss_z0]) cap_stem();
else if (part == "cap")
  cap();
else if (part == "cap_section")
  cpart("orange", true) cap();
else if (part == "box")
  box();
else if (part == "lid")
  lid();
else if (part == "gasket")
  translate([0, 0, z_lid_in + gasket_t]) rotate([180, 0, 0]) gasket();
// groove up
else if (part == "section")
  cpart([0.25, 0.5, 0.9], true) boot();
else if (part == "assembly")
  assembly();
else if (part == "assembly_section")
  assembly(true);
else if (part == "mock") mock();
