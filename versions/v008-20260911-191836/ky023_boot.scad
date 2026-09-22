// =====================================================================
//  KY-023 thumb-joystick sealed (IP68) enclosure:
//  TPU bellows boot + expander ring + rigid cap + hermetic box + lid
// =====================================================================
//
//  Parts (all printed):
//    boot    TPU      grommet that sits in the countersunk hole of the box
//                     top panel (flush), conical bellows, top sealing bead
//    ring    PLA/PETG expander pressed into the grommet bore: its cone
//                     squeezes the TPU against the hole and stops the
//                     grommet from collapsing inwards when the bellows pulls
//    cap     PLA/PETG replaces the stock 26.8 mm bell knob; a groove around
//                     the head rim that the boot bead snaps into
//    box     PETG/ASA one piece: top panel with the boot hole, walls, four
//                     corner screw bosses; open at the bottom
//    lid     PETG/ASA bottom plate with the PCB standoffs and a sealing rib
//    gasket  TPU      flat frame between the box rim and the lid
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
//    ring   either face down (9 deg cone, 45 deg chamfers)
//    cap    head down: flat top with a printable round-over, groove lip is
//           a steep cone (a finger dish would need supports, so it is off)
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
part = "boot"; // [boot, ring, cap, box, lid, gasket, section, assembly, assembly_section, mock]

/* [Printing] */
// Bellows wall = 2 perimeters x 0.4 mm nozzle
wall = 0.8; // [0.6:0.1:1.2]
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
post_d = 4.0;
post_flat = 3.0;
// Rectangular post: width x length
post_w = 1.15;
post_l = 1.85;
// Exposed post height above the plate
post_h = 7.2;
// Pot tops relative to the plate top (must stay under the panel hole)
pot_top_z = -1.0;
// PCB size and thickness
pcb_l = 34.0;
pcb_w = 26.0;
pcb_t = 1.6;
// PCB centre relative to the stick axis (header end is -X)
pcb_dx = -3.0;
// PCB mounting hole grid and diameter
pcb_hole_dx = 26.7;
pcb_hole_dy = 20.3;
pcb_hole_d = 3.2;
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
ring_lip = 0.3;
// Expander ring: inner diameter, radial expansion at its top, bottom chamfer
ring_in_d = 24.0;
ring_expand = 0.4; // [0.2:0.1:0.8]
ring_chamfer = 0.5;
// Bellows foot radius (wall centreline), must sit on the grommet top face
base_r = 14.6; // [14:0.2:16]
// Vertical lift of the wall above the grommet before the first fold
lift = 0.6;
// Fold legs angle from vertical (45 = safe TPU overhang, 50 with 0.15 mm layers)
leg_deg = 45; // [40:55]
// Rises of the fold legs, alternating inward / outward, starting inward;
// the last leg runs from the end of this list up to the bead
fold_rises = [5.5, 3, 5.5, 4.5];
// Corner rounding of the folds (centreline radius)
fold_r = 1.0; // [0.8:0.1:2]
// Sealing bead at the top: diameter and radial interference in the head groove
bead_d = 1.6; // [1.2:0.1:2.4]
bead_squeeze = 0.5; // [0:0.05:1]
// Length of the teardrop that blends the bead into the last leg
bead_run = 2.0; // [1:0.2:3]

/* [Cap (rigid, PLA/PETG)] */
// Neck diameter
neck_d = 8.0; // [6:0.5:12]
// Cap head underside height above the plate
cap_under_z = 22.0; // [14:0.5:26]
// Groove around the head rim: lip under it (steep cone), width, depth
groove_lip = 0.4;
groove_w = 1.7;
groove_depth = 0.7;
// Head diameter / height (incl. lip and groove) / top fillet
head_d = 19.9;
head_h = 6.5;
head_fillet = 1.5;
// Socket boss around the post: wall around the socket, start height, height
boss_wall = 1.2;
cap_boss_z0 = 2.5;
cap_boss_h = 3.0;
// Socket clearance per side and extra depth beyond the post tip
socket_clear = 0.1;
socket_extra = 0.3;
// Finger dish: sphere radius and depth (0 = flat top; a dish cannot be
// printed head-down without supports)
dish_r = 30;
dish_depth = 0; // [0:0.5:2]

/* [Box, lid, gasket (rigid + TPU)] */
// Wall and top panel thickness
wall_t = 2.5; // [2:0.5:4]
panel_t = 2.5; // [2:0.5:4]
// Gap between the pot tops and the panel underside
panel_clear = 0.5;
// Boot hole in the panel and its 45 deg countersink depth (grommet cone sits flush)
hole_d = 29.4;
cs_depth = 1.0;
// Cavity size (PCB + clearance) and corner radii
cav_x = 45.0;
cav_y = 34.0;
cav_r = 2.0;
box_r = 5.0;
// Round-over radius of the panel edge and of the lid outer edge (printable: 45 deg start)
box_edge_r = 2.5; // [0:0.5:4]
lid_edge_r = 1.5; // [0:0.5:3]
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
// Cable gland hole on the -X wall, teardrop (0 = none; 12.5 = PG7)
gland_d = 0; // [0:0.5:16]

/* [Hidden] */
eps = 0.01;
$fn = 48;

// ---------------------------------------------------------------------
//  Derived geometry
// ---------------------------------------------------------------------
box_cx   = pcb_dx;                              // box centred on the PCB
box_lx   = cav_x + 2 * wall_t;
box_ly   = cav_y + 2 * wall_t;
panel_bot = pot_top_z + panel_clear;
panel_top = panel_bot + panel_t;
z_pcb_bot = -plate_h - pcb_t;
z_lid_in = z_pcb_bot - standoff_h;              // lid inner face
z_rim    = z_lid_in + gasket_t;                 // box bottom rim
z_lid_out = z_lid_in - lid_t;
boss_in  = screw_boss_d / 2 + 0.8;              // boss centre from the outer edge
screw_xy = [for (sx = [-1, 1], sy = [-1, 1])
            [box_cx + sx * (box_lx / 2 - boss_in), sy * (box_ly / 2 - boss_in)]];
pcb_holes = [for (sx = [-1, 1], sy = [-1, 1])
             [pcb_dx + sx * pcb_hole_dx / 2, sy * pcb_hole_dy / 2]];
pcb_corner = [pcb_dx + pcb_l / 2, pcb_w / 2];
gland_z  = (z_rim + panel_bot) / 2;

// grommet and ring
hole_r   = hole_d / 2;
r_in     = grommet_in_d / 2;
r_g      = hole_r + grommet_squeeze;            // body radius (printed)
z_g0     = panel_bot - 0.1;                     // lip top face
z_lip0   = z_g0 - lip_h;
z_cs     = panel_top - cs_depth;                // countersink starts here
z_mid    = (z_g0 + z_cs) / 2;                   // ridge height
r_cone   = r_g + cs_depth;                      // cone radius at the panel top
ring_z0  = panel_bot + 0.2;
ring_h   = panel_top - ring_z0;
ring_r0  = r_in;                                // ring bottom radius (= bore)
ring_r1  = r_in + ring_expand;                  // ring top radius

// cap and head bead
socket_max = (post_type == "rect" ? max(post_w, post_l) : post_d) + 2 * socket_clear;
cap_boss_d = socket_max + 2 * boss_wall;
socket_depth = post_h - cap_boss_z0 + socket_extra;
neck_z0  = cap_boss_z0 + cap_boss_h + (neck_d - cap_boss_d) / 2;   // 45 deg cone
groove_r = head_d / 2 - groove_depth;
groove_z = cap_under_z + groove_lip + groove_w / 2;    // bead centre height
bead_rc  = groove_r - bead_squeeze + bead_d / 2;       // bead centre radius (printed)

// Bellows meridian knots (wall centreline): flange -> zigzag legs -> bead
K0 = [base_r, panel_top - 1.0];
K1 = [base_r, panel_top + lift];
function knots(i, p) = i >= len(fold_rises) ? [p] :
    concat([p], knots(i + 1, p + [(i % 2 == 0 ? -1 : 1) * fold_rises[i] * tan(leg_deg), fold_rises[i]]));
K_legs = knots(0, K1);
K_last = K_legs[len(K_legs) - 1];
K5 = [bead_rc, groove_z];                              // bead
last_leg = K5 - K_last;
last_leg_deg = atan2(abs(last_leg[0]), last_leg[1]);   // from vertical
inner_r = min([for (k = K_legs) k[0]]) - wall / 2;     // closest the wall gets to the axis

function unit(v) = v / norm(v);
function arc(c, r, a0, a1, n) = [for (i = [0:n]) c + r * [cos(a0 + (a1 - a0) * i / n), sin(a0 + (a1 - a0) * i / n)]];
// Replace corner p1 by a tangent arc of radius r (clamped to the segments)
function fillet(p0, p1, p2, r, n = 6) =
    let(d1 = unit(p0 - p1), d2 = unit(p2 - p1),
        half = acos(max(-1, min(1, d1 * d2))) / 2,
        rr = min(r, 0.45 * min(norm(p0 - p1), norm(p2 - p1)) * tan(half)),
        dist = rr / tan(half),
        t1 = p1 + d1 * dist, t2 = p1 + d2 * dist,
        c = p1 + unit(d1 + d2) * rr / sin(half),
        a1 = atan2(t1[1] - c[1], t1[0] - c[0]),
        a2 = atan2(t2[1] - c[1], t2[0] - c[0]),
        da = ((a2 - a1 + 540) % 360) - 180)
    arc(c, rr, a1, a1 + da, n);
function rounded_path(k, r) = concat([k[0]],
    [for (i = [1:len(k) - 2]) each fillet(k[i - 1], k[i], k[i + 1], r)], [k[len(k) - 1]]);
function path_len(p) = len(p) < 2 ? 0 : norm(p[1] - p[0]) + path_len([for (i = [1:len(p) - 1]) p[i]]);

meridian = rounded_path(concat([K0], K_legs, [K5]), fold_r);
meridian_len = path_len(meridian) - 1.0;                // minus the buried stub
rest_chord = norm(K5 - K1);
// Point (r, z) fixed to the stick after tilting by ang about the pivot (r may be negative)
function tilt_pt(p, ang) = [p[0] * cos(ang) + (p[1] - pivot_z) * sin(ang),
                            -p[0] * sin(ang) + (p[1] - pivot_z) * cos(ang) + pivot_z];
function chord_at(ang) = let(far = tilt_pt([-bead_rc, groove_z], ang), near = tilt_pt([bead_rc, groove_z], ang))
    [norm(far - [-base_r, K1[1]]), norm(near - [base_r, K1[1]])];
function stretch_at(ang) = max(0, (chord_at(ang)[0] / meridian_len - 1) * 100);
lat = (groove_z - pivot_z) * sin(tilt_deg);              // bead shift at tilt
no_stretch_deg = [for (a = [5:1:40]) if (stretch_at(a) == 0) a][len([for (a = [5:1:40]) if (stretch_at(a) == 0) a]) - 1];
head_edge = tilt_pt([head_d / 2, cap_under_z], tilt_deg);
// Tilt at which the boss bottom corner would reach the plate outside its opening
function boss_ok(a) = let(p = tilt_pt([cap_boss_d / 2, cap_boss_z0], a)) p[1] >= 0 || p[0] <= opening_d / 2;
boss_tilt_max = [for (a = [0:1:45]) if (boss_ok(a)) a][len([for (a = [0:1:45]) if (boss_ok(a)) a]) - 1];

echo(str("Box ", box_lx, " x ", box_ly, " x ", -z_lid_out, " mm (with lid), panel hole d ", hole_d,
         ", PCB corner to boss axis ", norm(pcb_corner - screw_xy[3]), " mm (boss r ", screw_boss_d / 2, ")"));
echo(str("Grommet: body r ", r_in, "..", r_g, " in hole r ", hole_r, ": squeeze ", (r_g / hole_r - 1) * 100,
         " % printed, ", ((r_g + ring_expand) / hole_r - 1) * 100, " % with the ring; lip passes the hole with ",
         ((r_g + lip_out) / hole_r - 1) * 100, " % stretch; panel ", panel_bot, "..", panel_top, ", pots top ", pot_top_z));
echo(str("Bellows: meridian ", meridian_len, " mm, rest chord ", rest_chord, ", last leg ", last_leg_deg,
         " deg from vertical (keep <= 50), innermost wall r ", inner_r, " (neck r ", neck_d / 2, ")"));
echo(str("At ", tilt_deg, " deg: bead shifts ", lat, " mm, far/near chords ", chord_at(tilt_deg),
         " -> far-side stretch ", stretch_at(tilt_deg), " % (no stretch up to ", no_stretch_deg,
         " deg, ", stretch_at(20), " % at 20 deg); head edge at r ", head_edge[0], " z ", head_edge[1]));
echo(str("Cap socket: post_type ", post_type, ", socket ", post_type == "rect" ? str(post_w + 2 * socket_clear, " x ", post_l + 2 * socket_clear)
         : str("d ", post_d + 2 * socket_clear, " flats ", post_flat + 2 * socket_clear), ", depth ", socket_depth,
         " from z ", cap_boss_z0, "; boss d ", cap_boss_d, " clears the plate opening up to ", boss_tilt_max, " deg"));
echo(str("Bead: ID ", 2 * (bead_rc - bead_d / 2), " in head groove d ", 2 * groove_r,
         " (", (groove_r / (bead_rc - bead_d / 2) - 1) * 100, " % squeeze), passes head d ", head_d,
         " (", (head_d / 2 / (bead_rc - bead_d / 2) - 1) * 100, " % stretch)"));
if (last_leg_deg > 50) echo("WARNING: last bellows leg too flat to print - raise cap_under_z or change fold_rises");
if (last_leg[1] < 0) echo("WARNING: fold_rises taller than the bead height - lower them or raise cap_under_z");
if (inner_r < neck_d / 2 + 2) echo("WARNING: bellows too close to the neck - reduce the inward rises");
if (base_r - wall / 2 < r_in + ring_lip || base_r + wall / 2 > r_cone) echo("WARNING: bellows foot is off the grommet top face");
if (cs_depth >= panel_t - 0.8) echo("WARNING: countersink too deep for the panel");
if (lip_out > lip_h) echo("WARNING: lip_out must not exceed lip_h (45 deg chamfer)");
if (hole_r >= cav_y / 2) echo("WARNING: panel hole wider than the cavity");
if (pot_top_z > 0) echo("WARNING: pots above the panel top");
if (boss_tilt_max < tilt_deg) echo("WARNING: cap boss hits the plate opening before tilt_deg - raise cap_boss_z0");

// ---------------------------------------------------------------------
//  2D helpers
// ---------------------------------------------------------------------
module rr(x, y, r) { offset(r = r) square([x - 2 * r, y - 2 * r], center = true); }
module box_outline() { translate([box_cx, 0]) rr(box_lx, box_ly, box_r); }
module cav_outline() { translate([box_cx, 0]) rr(cav_x, cav_y, cav_r); }
module stroke2d(pts, w) {
    for (i = [0:len(pts) - 2])
        hull() {
            translate(pts[i])     circle(d = w, $fn = 24);
            translate(pts[i + 1]) circle(d = w, $fn = 24);
        }
}
// Post cross-section with clearance c per side (socket) or c = 0 (mock post)
module post2d(c = 0) {
    if (post_type == "rect")
        square([post_w + 2 * c, post_l + 2 * c], center = true);
    else intersection() {
        circle(d = post_d + 2 * c, $fn = 48);
        if (post_type == "dd")
            square([post_d + 2 * c + 1, post_flat + 2 * c], center = true);
        else                                        // one flat, flat-to-round = post_flat
            translate([-(post_d + 2 * c + 1) / 2, -post_d / 2 - c]) square([post_d + 2 * c + 1, post_flat + 2 * c]);
    }
}
// Teardrop for a horizontal hole; peak towards 2D +X = world -Z after
// rotate([0, 90, 0]) (the box prints upside down)
module teardrop2d(d) { circle(d = d); rotate(-45) square(d / 2); }
// Extrude a convex 2D child by h with a printable round-over of radius r on
// the bed side (45 deg for the first layers, then an arc) at the bottom (rb)
// and/or the top (rt) - "top" here means the face that lies on the bed when
// the part is printed upside down.
module bed_round_slabs(r, h, flip) {
    n = 6;
    k = 1 - sin(45);                            // arc starts at 45 deg
    for (i = [0:n]) let(a = 45 + 45 * i / n, dz = r * (1 - cos(a)), dr = r * (1 - sin(a)))
        translate([0, 0, flip ? h - dz - eps : dz]) linear_extrude(eps) offset(r = -dr) children();
    // 45 deg run-out down to the bed plane
    translate([0, 0, flip ? h - eps : 0]) linear_extrude(eps) offset(r = -(r * k + r * (1 - cos(45)))) children();
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
    polygon([
        [r_in, z_lip0],
        [r_g, z_lip0],
        [r_g + lip_out, z_lip0 + lip_out],          // 45 deg entry chamfer
        [r_g + lip_out, z_g0],                      // lip outer face
        [r_g, z_g0],                                // flat lip top (holds under the panel)
        [r_g, z_mid - grommet_ridge],
        [r_g + grommet_ridge, z_mid],               // sealing ridge
        [r_g, z_mid + grommet_ridge],
        [r_g, z_cs],
        [r_cone, panel_top],                        // 45 deg cone into the countersink, flush top
        [r_in + ring_lip, panel_top],
        [r_in, panel_top - ring_lip],               // inward lip that snaps over the ring
    ]);
}

// Expander ring (rigid): pressed into the grommet bore from above until flush
module ring() {
    rotate_extrude($fn = fn_round) polygon([
        [ring_in_d / 2, ring_z0],
        [ring_r0 - ring_chamfer, ring_z0],
        [ring_r0, ring_z0 + ring_chamfer],          // entry chamfer
        [ring_r1, ring_z0 + ring_h - ring_lip],     // 9 deg cone
        [ring_r1 - ring_lip, ring_z0 + ring_h],     // top chamfer under the grommet lip
        [ring_in_d / 2, ring_z0 + ring_h],
    ]);
}

module boot() {
    rotate_extrude($fn = fn_round) {
        grommet2d();
        stroke2d(meridian, wall);
        hull() {                                    // bead as a teardrop along the last leg
            translate(K5) circle(d = bead_d, $fn = 32);
            translate(K5 - bead_run * unit(K5 - K_last)) circle(d = wall, $fn = 24);
        }
    }
}

// ---------------------------------------------------------------------
//  Cap (rigid) - print head down, neck up
// ---------------------------------------------------------------------
// Disc with a printable round-over on its top edge (the head prints top-down)
module rounded_disc(d, h, r) {
    n = 6;
    rotate_extrude($fn = fn_round)
        hull() {
            square([d / 2, max(eps, h - r)]);
            for (i = [0:n]) let(a = 45 + 45 * i / n)
                translate([0, h - r * (1 - cos(a)) - eps]) square([d / 2 - r * (1 - sin(a)), eps]);
            translate([0, h - eps]) square([d / 2 - r * (1 - sin(45)) - r * (1 - cos(45)), eps]);
        }
}

module cap() {
    difference() {
        union() {
            translate([0, 0, cap_under_z]) {
                cylinder(d1 = head_d, d2 = 2 * groove_r, h = groove_lip, $fn = fn_round);  // lip
                cylinder(r = groove_r, h = groove_lip + groove_w + eps, $fn = fn_round);   // groove core
                translate([0, 0, groove_lip + groove_w])
                    rounded_disc(head_d, head_h - groove_lip - groove_w, head_fillet);
            }
            translate([0, 0, neck_z0 - eps])
                cylinder(d = neck_d, h = cap_under_z - neck_z0 + 2 * eps, $fn = fn_round);
            translate([0, 0, cap_boss_z0 + cap_boss_h - eps])
                cylinder(d1 = cap_boss_d, d2 = neck_d, h = (neck_d - cap_boss_d) / 2 + eps, $fn = fn_round);
            translate([0, 0, cap_boss_z0 + 0.4])
                cylinder(d = cap_boss_d, h = cap_boss_h - 0.4 + eps, $fn = fn_round);
            translate([0, 0, cap_boss_z0])
                cylinder(d1 = cap_boss_d - 0.8, d2 = cap_boss_d, h = 0.4 + eps, $fn = fn_round);
        }
        // keyed socket for the centre post
        translate([0, 0, cap_boss_z0 - eps]) linear_extrude(socket_depth + eps) post2d(socket_clear);
        // optional finger dish
        if (dish_depth > 0)
            translate([0, 0, cap_under_z + head_h + dish_r - dish_depth]) sphere(r = dish_r, $fn = fn_round);
    }
}

// ---------------------------------------------------------------------
//  Box (rigid) - one piece, open bottom; print upside down (panel on bed)
// ---------------------------------------------------------------------
module box() {
    difference() {
        union() {
            difference() {
                translate([0, 0, z_rim]) rounded_extrude(panel_top - z_rim, rt = box_edge_r) box_outline();
                translate([0, 0, z_rim - 1]) linear_extrude(panel_bot - z_rim + 1) cav_outline();
            }
            for (p = screw_xy) translate([p[0], p[1], z_rim]) cylinder(d = screw_boss_d, h = panel_bot - z_rim + eps);
        }
        // boot hole in the panel with a 45 deg countersink at the top
        translate([0, 0, panel_bot - 1]) cylinder(r = hole_r, h = panel_t + 2, $fn = fn_round);
        translate([0, 0, z_cs]) cylinder(r1 = hole_r, r2 = hole_r + cs_depth + 1, h = cs_depth + 1, $fn = fn_round);
        // screw holes in the bosses, from the rim
        for (p = screw_xy) translate([p[0], p[1], z_rim - 1]) cylinder(d = screw_hole_d, h = 9);
        // optional cable gland on the -X wall
        if (gland_d > 0)
            translate([box_cx - box_lx / 2 + wall_t / 2, 0, gland_z])
                rotate([0, 90, 0]) linear_extrude(wall_t * 2, center = true) teardrop2d(gland_d);
    }
}

// ---------------------------------------------------------------------
//  Lid (rigid) - bottom plate; print outer face down
// ---------------------------------------------------------------------
module lid() {
    difference() {
        translate([0, 0, z_lid_out]) rounded_extrude(lid_t, rb = lid_edge_r) box_outline();
        for (p = screw_xy) translate([p[0], p[1], z_lid_out - 1]) cylinder(d = screw_clear_d, h = lid_t + 2);
    }
    // sealing rib into the gasket, centred on the wall
    translate([0, 0, z_lid_in - eps]) linear_extrude(rib_h + eps) difference() {
        offset(r = wall_t / 2 + rib_w / 2) cav_outline();
        offset(r = wall_t / 2 - rib_w / 2) cav_outline();
    }
    // PCB standoffs
    for (p = pcb_holes) translate([p[0], p[1], z_lid_in - eps]) difference() {
        cylinder(d = standoff_d, h = standoff_h + eps);
        translate([0, 0, -0.8]) cylinder(d = screw_hole_d, h = standoff_h + 1);
    }
}

// ---------------------------------------------------------------------
//  Gasket (TPU) - flat frame covering the rim and the boss tops
// ---------------------------------------------------------------------
module gasket() {
    translate([0, 0, z_lid_in]) linear_extrude(gasket_t) difference() {
        offset(delta = -0.3) box_outline();
        difference() {
            cav_outline();
            for (p = screw_xy) translate(p) circle(d = screw_boss_d + 0.6);
        }
        for (p = screw_xy) translate(p) circle(d = screw_clear_d);
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
    cpart("darkgreen", cut) translate([pcb_dx - pcb_l / 2, -pcb_w / 2, z_pcb_bot]) cube([pcb_l, pcb_w, pcb_t]);
    cpart("white", cut) translate([-8, -9.8, -plate_h]) cube([16, 17.8, 4]);
    cpart("silver", cut) difference() {
        translate([-8, -8, -plate_h]) cube([16, 16, plate_h]);
        translate([-7.5, -7.5, -plate_h - 1]) cube([15, 15, plate_h + 0.5]);
        cylinder(d = opening_d, h = 10, center = true);
    }
    cpart("dimgray", cut) {
        translate([8, -6, -plate_h]) cube([3, 12, plate_h + pot_top_z]);
        translate([-6, 8, -plate_h]) cube([12, 3.6, plate_h + pot_top_z]);
    }
    cpart("black", cut) translate([-14.5, -3.25, -plate_h]) cube([6, 6.5, plate_h - 4.9]);
    cpart("black", cut) translate([pcb_dx - pcb_l / 2 + 0.5, -6.35, -plate_h]) cube([2.5, 12.7, 2.5]);
    cpart("white", cut) intersection() {
        translate([0, 0, pivot_z]) sphere(r = -pivot_z + 0.5, $fn = 64);
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
if (part == "boot")                  boot();
else if (part == "ring")             ring();
else if (part == "cap")              cap();
else if (part == "box")              box();
else if (part == "lid")              lid();
else if (part == "gasket")           gasket();
else if (part == "section")          cpart([0.25, 0.5, 0.9], true) boot();
else if (part == "assembly")         assembly();
else if (part == "assembly_section") assembly(true);
else if (part == "mock")             mock();
