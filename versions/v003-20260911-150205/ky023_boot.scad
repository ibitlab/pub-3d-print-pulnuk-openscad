// =====================================================================
//  KY-023 thumb-joystick sealed (IP68) enclosure:
//  TPU bellows boot + rigid cap + hermetic box + clamp lid
// =====================================================================
//
//  Parts (all printed):
//    boot  TPU     flat gasket sheet + conical bellows + sealing bead
//    cap   PLA/PETG replaces the stock 26.8 mm bell knob; neck with a
//                  groove that the boot bead snaps into (top seal)
//    box   PETG/ASA holds the KY-023 PCB on 4 standoffs, cable gland hole
//    lid   PETG/ASA frame that clamps the boot sheet onto the box rim with
//                  4 x M3 screws; a rib on its underside presses a sealing
//                  line into the TPU sheet (bottom seal)
//
//  Sealing path: water -> cap head -> neck groove (bead, 6 % stretch)
//                     -> bellows wall -> sheet clamped under the lid rib
//                     -> box walls / floor -> cable gland.
//
//  Return-to-centre: the bellows is symmetric and printed in the exact
//  shape it has when installed (bead at groove_z), so the only equilibrium
//  is the centre. The bead sits low on the neck (short lever from the
//  pivot) and the wall loops above it (crest), which gives enough wall
//  length that the far side does not stretch up to the working tilt (see
//  the ECHO output). Stretch beyond that pulls towards the centre, never
//  away. The crest stays clear of the head, so the push button is free.
//
//  Coordinates: stick axis = Z, Z = 0 is the top of the joystick's steel
//  plate = top of the box rim = underside of the boot sheet. mm.
//
//  Check on your module with calipers: frame footprint / PCB size,
//  PCB hole grid (pcb_hole_dx/dy) and the centre post (post_w/l/h).
// =====================================================================

/* [Part] */
// What to render / export
part = "boot"; // [boot, cap, lid, box, section, assembly, assembly_section, mock]

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
// Centre post cross-section (keyed rectangle) and exposed height
post_w = 1.15;
post_l = 1.85;
post_h = 7.2;
// Pot tops relative to the plate top (mock-up only)
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

/* [Boot] */
// Flat gasket sheet thickness
flange_t = 2.0; // [1.5:0.1:3]
// Sheet is this much smaller than the box outline
sheet_inset = 0.3;
// Bellows foot radius (wall centreline)
base_r = 13.5; // [12:0.5:16]
// Vertical lift of the wall above the sheet before the first fold
lift = 0.6;
// Fold legs angle from vertical (45 = safe TPU overhang, 50 with 0.15 mm layers)
leg_deg = 45; // [40:55]
// First inward leg: rise
fold_in1 = 5.5; // [2:0.5:8]
// Outward leg of the convolution: rise
fold_out1 = 2.0; // [0.5:0.5:4]
// Crest of the top loop above the bead: radial offset and height
crest_dr = 1.7; // [1:0.1:3]
crest_dz = 2.6; // [1.5:0.1:4]
// Corner rounding of the folds (centreline radius)
fold_r = 1.0; // [0.8:0.1:2]
// Sealing bead diameter (round cross-section)
bead_d = 1.6; // [1.2:0.1:2.4]
// Radial interference of the bead in the neck groove
bead_squeeze = 0.2; // [0:0.05:0.5]
// Foot fillets between sheet and bellows wall
foot_fillet = 1.0;

/* [Cap (rigid, PLA/PETG)] */
// Neck diameter
neck_d = 8.0; // [6:0.5:12]
// Cap head underside height above the plate
cap_under_z = 17.5; // [14:0.5:26]
// Sealing groove in the neck: centre height, width, depth
groove_z = 12.0; // [10:0.5:22]
groove_w = 1.7;
groove_depth = 0.8;
// Head diameter / height / top fillet
head_d = 19.9;
head_h = 5.7;
head_fillet = 1.5;
// Socket boss around the post: diameter, start height, height
cap_boss_d = 4.4;
cap_boss_z0 = 1.5;
cap_boss_h = 3.0;
// Socket clearance per side and depth
socket_clear = 0.1;
socket_depth = 6.0;
// Finger dish: sphere radius and depth
dish_r = 30;
dish_depth = 1.0;

/* [Box and lid (rigid)] */
// Wall thickness
wall_t = 2.5; // [2:0.5:4]
// Cavity size (PCB + clearance; extra length on -X for the gland nut)
cav_x = 43.0;
cav_y = 32.0;
// Cavity / outer corner radii
cav_r = 2.0;
box_r = 5.0;
// PCB centre offset from the box centre towards +X (leaves a cable bay on -X)
pcb_bay = 3.0;
// Floor thickness and clearance under the PCB (pins)
floor_t = 2.0;
floor_clear = 3.7;
// PCB standoffs: diameter and screw hole (M3 self-tapping)
standoff_d = 6.0;
screw_hole_d = 2.6;
// Lid screw bosses hanging from the rim: diameter, height, clearance hole
screw_boss_d = 6.0;
screw_boss_h = 9.5;
screw_clear_d = 3.4;
// Cable gland hole on the -X wall (12.5 = PG7, 0 = none, pot the cable)
gland_d = 12.5; // [0:0.5:16]
// Round-over of the box bottom edge and of the lid top edge
box_edge_r = 2.5; // [0:0.5:4]
lid_edge_r = 1.2; // [0:0.2:2]
// Lid thickness
lid_t = 2.5; // [2:0.5:4]
// Lid opening clearance around the bellows foot
lid_hole_clear = 1.0;
// Sealing rib on the lid underside: width and height (pressed into the TPU)
rib_w = 1.0;
rib_h = 0.5;

/* [Hidden] */
eps = 0.01;
$fn = 48;

// ---------------------------------------------------------------------
//  Derived geometry
// ---------------------------------------------------------------------
box_cx   = pcb_dx - pcb_bay;                    // box centre (stick coords)
box_lx   = cav_x + 2 * wall_t;
box_ly   = cav_y + 2 * wall_t;
box_z0   = -plate_h - pcb_t - floor_clear - floor_t;
floor_top = box_z0 + floor_t;
boss_in  = screw_boss_d / 2 + 0.8;              // boss centre from the outer edge
screw_xy = [for (sx = [-1, 1], sy = [-1, 1])
            [box_cx + sx * (box_lx / 2 - boss_in), sy * (box_ly / 2 - boss_in)]];
pcb_holes = [for (sx = [-1, 1], sy = [-1, 1])
             [pcb_dx + sx * pcb_hole_dx / 2, sy * pcb_hole_dy / 2]];
gland_z  = (floor_top + 0) / 2;
lid_hole_d = 2 * (base_r + wall / 2 + lid_hole_clear);

neck_z0  = cap_boss_z0 + cap_boss_h + (neck_d - cap_boss_d) / 2;   // 45 deg cone
groove_r = neck_d / 2 - groove_depth;
bead_rc  = groove_r - bead_squeeze + bead_d / 2;  // bead centre radius (printed)

// Bellows meridian knots (wall centreline)
K0 = [base_r, flange_t - 1.0];
K1 = [base_r, flange_t + lift];
K2 = K1 + [-fold_in1 * tan(leg_deg), fold_in1];
K3 = K2 + [fold_out1 * tan(leg_deg), fold_out1];
K5 = [bead_rc, groove_z];                              // bead
K4 = K5 + [crest_dr, crest_dz];                        // crest of the top loop
last_leg = K4 - K3;
last_leg_deg = atan2(abs(last_leg[0]), last_leg[1]);   // from vertical
crest_leg_deg = atan2(crest_dr, crest_dz);             // crest -> bead, from vertical
crest_top = K4[1] + wall / 2;

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

meridian = rounded_path([K0, K1, K2, K3, K4, K5], fold_r);
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
head_edge = [head_d / 2 * cos(tilt_deg) + cap_under_z * sin(tilt_deg),
             cap_under_z * cos(tilt_deg) - head_d / 2 * sin(tilt_deg)];

echo(str("Box ", box_lx, " x ", box_ly, " x ", -box_z0, " mm, lid hole d ", lid_hole_d,
         ", screws at ", screw_xy));
echo(str("Bellows: meridian ", meridian_len, " mm, rest chord ", rest_chord,
         ", legs ", last_leg_deg, " / ", crest_leg_deg, " deg from vertical (keep <= 50), crest top z ", crest_top));
echo(str("At ", tilt_deg, " deg: bead shifts ", lat, " mm, far/near chords ", chord_at(tilt_deg),
         " -> far-side stretch ", stretch_at(tilt_deg), " % (no stretch up to ", no_stretch_deg,
         " deg, ", stretch_at(20), " % at 20 deg); head edge at r ", head_edge[0], " z ", head_edge[1],
         " (lid top z ", flange_t + lid_t, ")"));
echo(str("Bead: ID ", 2 * (bead_rc - bead_d / 2), " on groove d ", 2 * groove_r,
         " (", (groove_r / (bead_rc - bead_d / 2) - 1) * 100, " % squeeze), passes neck d ", neck_d,
         " (", (neck_d / 2 / (bead_rc - bead_d / 2) - 1) * 100, " % stretch)"));
if (last_leg_deg > 50) echo("WARNING: last bellows leg too flat to print - raise groove_z / cap_under_z or lower fold_out1");
if (crest_top + push_travel + 0.8 > cap_under_z) echo("WARNING: crest too close to the cap head - raise cap_under_z");
if (crest_leg_deg > 50) echo("WARNING: crest leg too flat - increase crest_dz or reduce crest_dr");

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
// Teardrop for a horizontal hole, peak towards -X of the 2D shape
module teardrop2d(d) { circle(d = d); rotate(135) square(d / 2); }
// Extrude a convex 2D child by h with rounded bottom (fb) and top (ft) edges
module rounded_extrude(h, fb = 0, ft = 0) {
    n = 6;
    hull() {
        if (fb > 0) for (i = [0:n]) let(a = 90 * i / n)
            translate([0, 0, fb * (1 - cos(a))]) linear_extrude(eps)
                offset(r = -fb * (1 - sin(a))) children();
        translate([0, 0, fb]) linear_extrude(max(eps, h - fb - ft)) children();
        if (ft > 0) for (i = [0:n]) let(a = 90 * i / n)
            translate([0, 0, h - ft + ft * sin(a) - eps]) linear_extrude(eps)
                offset(r = -ft * (1 - cos(a))) children();
    }
}

// ---------------------------------------------------------------------
//  Boot (TPU) - print sheet down, bellows up, no supports
// ---------------------------------------------------------------------
module boot() {
    // gasket sheet with the clamp screw holes and the bellows opening
    linear_extrude(flange_t) difference() {
        offset(delta = -sheet_inset) box_outline();
        circle(r = base_r - wall / 2, $fn = fn_round);
        for (p = screw_xy) translate(p) circle(d = screw_clear_d);
    }
    rotate_extrude($fn = fn_round) {
        stroke2d(meridian, wall);
        translate(K5) circle(d = bead_d, $fn = 32);
        // 45 deg fillets at the foot, inside and outside
        translate([base_r + wall / 2 - eps, flange_t - eps])
            polygon([[0, 0], [foot_fillet, 0], [0, foot_fillet]]);
        translate([base_r - wall / 2 + eps, flange_t - eps])
            polygon([[0, 0], [-foot_fillet, 0], [0, foot_fillet]]);
    }
}

// ---------------------------------------------------------------------
//  Cap (rigid) - print head down, neck up
// ---------------------------------------------------------------------
module rounded_disc(d, h, r) {
    rotate_extrude($fn = fn_round)
        hull() {
            square([d / 2 - r, h]);
            square([d / 2, h - r]);
            translate([d / 2 - r, h - r]) circle(r = r);
        }
}

module cap() {
    difference() {
        union() {
            translate([0, 0, cap_under_z]) rounded_disc(head_d, head_h, head_fillet);
            translate([0, 0, neck_z0 - eps])
                cylinder(d = neck_d, h = cap_under_z - neck_z0 + 2 * eps, $fn = fn_round);
            translate([0, 0, cap_boss_z0 + cap_boss_h - eps])
                cylinder(d1 = cap_boss_d, d2 = neck_d, h = (neck_d - cap_boss_d) / 2 + eps, $fn = fn_round);
            translate([0, 0, cap_boss_z0 + 0.4])
                cylinder(d = cap_boss_d, h = cap_boss_h - 0.4 + eps, $fn = fn_round);
            translate([0, 0, cap_boss_z0])
                cylinder(d1 = cap_boss_d - 0.8, d2 = cap_boss_d, h = 0.4 + eps, $fn = fn_round);
        }
        // sealing groove for the boot bead
        translate([0, 0, groove_z - groove_w / 2]) difference() {
            cylinder(d = neck_d + 1, h = groove_w, $fn = fn_round);
            translate([0, 0, -1]) cylinder(r = groove_r, h = groove_w + 2, $fn = fn_round);
        }
        // keyed socket for the centre post
        translate([0, 0, cap_boss_z0 - eps])
            linear_extrude(socket_depth + eps)
                square([post_w + 2 * socket_clear, post_l + 2 * socket_clear], center = true);
        // finger dish
        translate([0, 0, cap_under_z + head_h + dish_r - dish_depth]) sphere(r = dish_r, $fn = fn_round);
    }
}

// ---------------------------------------------------------------------
//  Box (rigid) - print floor down
// ---------------------------------------------------------------------
module box() {
    difference() {
        union() {
            translate([0, 0, box_z0]) rounded_extrude(-box_z0, fb = box_edge_r) box_outline();
            // hanging screw bosses with 45 deg cones (clear of the PCB corners)
            for (p = screw_xy) translate(p) {
                translate([0, 0, -screw_boss_h]) cylinder(d = screw_boss_d, h = screw_boss_h);
                translate([0, 0, -screw_boss_h - (screw_boss_d - 0.5) / 2])
                    cylinder(d1 = 0.5, d2 = screw_boss_d, h = (screw_boss_d - 0.5) / 2 + eps);
            }
        }
        // cavity
        translate([0, 0, floor_top]) linear_extrude(-floor_top + 1) cav_outline();
        // screw holes in the bosses
        for (p = screw_xy) translate([p[0], p[1], -screw_boss_h + 1]) cylinder(d = screw_hole_d, h = screw_boss_h);
        // cable gland on the -X wall
        if (gland_d > 0)
            translate([box_cx - box_lx / 2 + wall_t / 2, 0, gland_z])
                rotate([0, 90, 0]) linear_extrude(wall_t * 2, center = true) teardrop2d(gland_d);
    }
    // PCB standoffs
    for (p = pcb_holes) translate([p[0], p[1], floor_top - eps]) difference() {
        cylinder(d = standoff_d, h = floor_clear + eps);
        translate([0, 0, -0.8]) cylinder(d = screw_hole_d, h = floor_clear + 1);
    }
}

// ---------------------------------------------------------------------
//  Lid (rigid) - print top face down so the rib prints on top
// ---------------------------------------------------------------------
module lid() {
    translate([0, 0, flange_t]) difference() {
        rounded_extrude(lid_t, ft = lid_edge_r) box_outline();
        translate([0, 0, -1]) linear_extrude(lid_t + 2) {
            circle(d = lid_hole_d, $fn = fn_round);
            for (p = screw_xy) translate(p) circle(d = screw_clear_d);
        }
    }
    // sealing rib, centred on the box wall
    translate([0, 0, flange_t - rib_h]) linear_extrude(rib_h + eps) difference() {
        offset(r = wall_t / 2 + rib_w / 2) cav_outline();
        offset(r = wall_t / 2 - rib_w / 2) cav_outline();
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
    cpart("darkgreen", cut) translate([pcb_dx - pcb_l / 2, -pcb_w / 2, -plate_h - pcb_t]) cube([pcb_l, pcb_w, pcb_t]);
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
    cpart("gold", cut) translate([-post_w / 2, -post_l / 2, 0.3]) cube([post_w, post_l, post_h - 0.3]);
}

module assembly(cut = false) {
    mock(cut);
    cpart([0.55, 0.6, 0.65], cut) box();
    cpart([0.35, 0.4, 0.45], cut) lid();
    cpart("orange", cut) cap();
    cpart([0.25, 0.5, 0.9], cut) boot();
}

// ---------------------------------------------------------------------
//  Part selector
// ---------------------------------------------------------------------
if (part == "boot")                  boot();
else if (part == "cap")              cap();
else if (part == "lid")              lid();
else if (part == "box")              box();
else if (part == "section")          cpart([0.25, 0.5, 0.9], true) boot();
else if (part == "assembly")         assembly();
else if (part == "assembly_section") assembly(true);
else if (part == "mock")             mock();
