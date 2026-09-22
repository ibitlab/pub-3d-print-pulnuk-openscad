// =====================================================================
//  KY-023 thumb-joystick dust boot (TPU) + rigid replacement cap
// =====================================================================
//
//  Why a replacement cap: the stock KY-023 knob is a 26.8 mm bell that
//  already overhangs the 16 mm frame and the 26 mm PCB, so no gaiter fits
//  under it.  The boot below lives inside the cap-head footprint instead:
//
//      square stretch skirt on the 16 mm steel frame
//        -> solid square-to-round base ("shelf") on the top plate
//        -> one deep rounded fold, 0.8 mm wall (2 x 0.4 mm perimeters)
//        -> floating collar around the dia 8 neck of the printed cap
//
//  Return-to-centre is guaranteed by geometry, not by softness:
//    * the collar clears the neck radially so NOTHING touches the stick
//      inside the +/- deadband_deg cone -> zero preload, friction or bias
//      at rest; only beyond ~7 deg does the neck drag the collar;
//    * the collar top sits head_gap below the cap head, so pushing the
//      stick (button) never loads the boot;
//    * printed shape == installed shape (only the skirt is stretched, and
//      that stretch is axisymmetric and never reaches the stick).
//
//  Coordinates: Z = 0 is the top surface of the joystick's steel top
//  plate, Z up, stick axis = Z axis, gimbal pivot at Z = pivot_z.
//  Everything is in millimetres.
//
//  Before printing, check with calipers on your module:
//    frame_w   (square steel frame width, nominal 16.0)
//    post_w / post_l / post_h (centre post of the stick, knob pulled off)
//    opening_d (round hole in the top plate, only for clearance checks)
//  Print the "test_ring" part first (2 min) to confirm the skirt fit.
// =====================================================================

/* [Part] */
// What to render / export
part = "boot"; // [boot, cap, test_ring, section, assembly, assembly_section, mock]

/* [Printing] */
// Fold-zone wall = 2 perimeters x 0.4 mm nozzle
wall = 0.8; // [0.6:0.1:1.2]
// Skirt / base wall (3-4 perimeters)
cuff_wall = 1.4; // [1.0:0.1:2.0]
// Segments per revolution for exported geometry
fn_round = 144; // [48:12:240]

/* [Joystick module (measure with calipers)] */
// Square steel frame / top plate width
frame_w = 16.0; // [13:0.1:18]
// Top plate height above the PCB (mock-up only)
plate_h = 12.2;
// Round opening in the top plate
opening_d = 11.0; // [9:0.5:13]
// Gimbal centre relative to the plate top (negative = below)
pivot_z = -6.7; // [-8:0.1:-4]
// Centre post cross-section (rectangular, keyed) and exposed height
post_w = 1.15;
post_l = 1.85;
post_h = 7.2;
// Potentiometer tops relative to the plate top (mock-up only)
pot_top_z = -1.0;
// Working tilt of the stick (each axis)
tilt_deg = 25; // [15:35]
// Tilt used for clearance checks (mechanical stop)
tilt_check_deg = 30; // [20:35]
// Half-angle of the cone in which the boot must not touch the stick
deadband_deg = 5; // [2:10]
// Stick push-down (button) travel
push_travel = 1.5; // [0.5:0.1:2.5]

/* [Boot] */
// Skirt stretch on the frame (pocket = frame_w - this)
cuff_interference = 0.6; // [0.2:0.1:1.2]
// Skirt engagement below the plate top (pots limit it on two sides)
skirt_depth = 2.0; // [1:0.5:4]
// Bottom lead-in chamfer of the pocket
lead_in = 0.4;
// Inner corner radius of the pocket (frame bend radius + tolerance)
skirt_corner_r = 1.0;
// Height of the solid base above the plate
base_h = 2.0; // [1.5:0.1:3]
// Inner / outer radius of the base top ring (fold root sits between them)
shelf_in_r = 8.8;
shelf_out_r = 9.8;
// Fold legs angle from vertical (45 = safe TPU overhang limit)
wall_angle = 45; // [40:60]
// Rise of the short outward leg before the crest
rise_out = 1.0; // [0.5:0.1:2]
// Crest arc radius (wall centreline)
crest_r = 1.6; // [1.2:0.1:2.5]
// Valley arc radius into the collar (wall centreline)
valley_r = 1.4; // [1.0:0.1:2.5]
// Radial collar clearance to the neck; 0 = auto from deadband_deg
collar_clear = 0; // [0:0.1:3]
// Extra clearance added to the auto value (print tolerance)
collar_extra = 0.2;
// Axial gap between collar top and cap head (push travel + cocking)
head_gap = 2.0; // [1.5:0.1:3]

/* [Cap (rigid, PLA/PETG)] */
// Neck diameter the collar floats around
neck_d = 8.0; // [6:0.5:12]
// Cap head underside height above the plate
cap_under_z = 14.0; // [11:0.5:18]
// Head diameter / height
head_d = 19.9;
head_h = 5.7;
// Socket boss around the post
boss_d = 4.4;
boss_z0 = 1.5;
boss_h = 3.0;
// Socket clearance per side and depth
socket_clear = 0.1;
socket_depth = 6.0;
// Finger dish on the head top: sphere radius and depth
dish_r = 30;
dish_depth = 1.0;
// Head top edge fillet
head_fillet = 1.5;

/* [Hidden] */
eps = 0.01;
$fn = 48;

// ---------------------------------------------------------------------
//  Derived geometry
// ---------------------------------------------------------------------
pocket_w  = frame_w - cuff_interference;     // printed skirt pocket
outer_w   = pocket_w + 2 * cuff_wall;        // skirt outside
collar_top = cap_under_z - head_gap;
clear_auto = (collar_top - 1 - pivot_z) * sin(deadband_deg) + collar_extra;
clr       = collar_clear > 0 ? collar_clear : clear_auto;
r_collar  = neck_d / 2 + clr + wall / 2;     // collar wall centreline
neck_z0   = boss_z0 + boss_h + (neck_d - boss_d) / 2;  // 45 deg cone

// Fold meridian (wall centreline), from the base top to the collar top.
a  = wall_angle;
sa = sin(a);
ca = cos(a);
r_root = (shelf_in_r + shelf_out_r) / 2;
P1 = [r_root, base_h];
P2 = P1 + [rise_out * sa / ca, rise_out];            // end of outward leg
C1 = P2 + crest_r * [-ca, sa];                       // crest centre
P3 = C1 + crest_r * [ca, sa];                        // start of inward leg
P4x = r_collar + valley_r * (1 - ca);
t_in = (P3[0] - P4x) / sa;                           // inward leg length
P4 = P3 + t_in * [-sa, ca];                          // start of valley arc
C2 = P4 + valley_r * [ca, sa];                       // valley centre
P5 = C2 + [-valley_r, 0];                            // collar bottom
n1 = 16; n2 = 8;
crest_pts  = [for (i = [0:n1]) let(th = -a + 2 * a * i / n1) C1 + crest_r * [cos(th), sin(th)]];
valley_pts = [for (i = [0:n2]) let(th = 180 + a - a * i / n2) C2 + valley_r * [cos(th), sin(th)]];
meridian = concat([[r_root, base_h - 0.6]], [P1], crest_pts, valley_pts, [[r_collar, collar_top]]);

meridian_len = rise_out / ca + crest_r * 2 * a * PI / 180 + t_in
             + valley_r * a * PI / 180 + (collar_top - P5[1]);
rest_chord = norm([r_collar, P5[1]] - P1);

// Point (r, z) fixed to the stick, after tilting the stick by ang about the pivot
function tilt_pt(p, ang) = [p[0] * cos(ang) + (p[1] - pivot_z) * sin(ang),
                            -p[0] * sin(ang) + (p[1] - pivot_z) * cos(ang) + pivot_z];
// Inner face of the base at height z (0..base_h), side midpoint
function base_inner_r(z) = pocket_w / 2 + (shelf_in_r - pocket_w / 2) * max(0, min(1, z / base_h));

neck_corner = tilt_pt([neck_d / 2, neck_z0], tilt_check_deg);
boss_corner = tilt_pt([boss_d / 2, boss_z0], tilt_check_deg);
collar_shift = (collar_top - 1 - pivot_z) * sin(tilt_deg);
engage_deg = asin(clr / (collar_top - 1 - pivot_z));

echo(str("Boot: skirt pocket ", pocket_w, " sq, outside ", outer_w, " sq, height ", -skirt_depth, "..", collar_top));
echo(str("Collar: ID ", 2 * (r_collar - wall / 2), " OD ", 2 * (r_collar + wall / 2),
         " Z ", P5[1], "..", collar_top, "  clearance ", clr, " -> first contact at ", engage_deg, " deg"));
echo(str("Fold: crest outer r ", C1[0] + crest_r + wall / 2, " at Z ", C1[1],
         ", meridian ", meridian_len, " mm, rest chord ", rest_chord, " mm"));
echo(str("At ", tilt_deg, " deg the neck drags the collar ", collar_shift - clr, " mm sideways"));
echo(str("Clearance check at ", tilt_check_deg, " deg: neck corner r ", neck_corner[0], " z ", neck_corner[1],
         " vs base inner r ", base_inner_r(neck_corner[1]),
         "; boss corner r ", boss_corner[0], " z ", boss_corner[1], " vs opening r ", opening_d / 2));
if (collar_top - P5[1] < 1.0)
    echo("WARNING: collar shorter than 1 mm - raise cap_under_z or reduce crest_r/valley_r");
if (t_in < 0)
    echo("WARNING: collar wider than the crest - reduce neck_d or increase shelf radii");

// ---------------------------------------------------------------------
//  2D helpers
// ---------------------------------------------------------------------
module rsq(s, r) { offset(r = r) square(s - 2 * r, center = true); }
module slab(z, h = eps) { translate([0, 0, z]) linear_extrude(h) children(); }

// Stroke a polyline with a round pen -> uniform normal thickness w
module stroke2d(pts, w) {
    for (i = [0:len(pts) - 2])
        hull() {
            translate(pts[i])     circle(d = w, $fn = 24);
            translate(pts[i + 1]) circle(d = w, $fn = 24);
        }
}

// ---------------------------------------------------------------------
//  Boot
// ---------------------------------------------------------------------
module base() {
    difference() {
        union() {
            translate([0, 0, -skirt_depth])
                linear_extrude(skirt_depth + eps) rsq(outer_w, skirt_corner_r + cuff_wall);
            hull() {
                slab(0) rsq(outer_w, skirt_corner_r + cuff_wall);
                slab(base_h - eps) circle(r = shelf_out_r, $fn = fn_round);
            }
        }
        // pocket that stretches over the steel frame
        translate([0, 0, -skirt_depth - 1])
            linear_extrude(skirt_depth + 1) rsq(pocket_w, skirt_corner_r);
        // lead-in chamfer at the pocket mouth
        hull() {
            slab(-skirt_depth - eps) rsq(pocket_w + 2 * lead_in, skirt_corner_r + lead_in);
            slab(-skirt_depth + lead_in) rsq(pocket_w, skirt_corner_r);
        }
        // void above the plate, lofting square -> round shelf
        hull() {
            slab(-eps) rsq(pocket_w, skirt_corner_r);
            slab(base_h + eps) circle(r = shelf_in_r, $fn = fn_round);
        }
    }
}

module fold() {
    rotate_extrude($fn = fn_round) stroke2d(meridian, wall);
}

module boot() {
    base();
    fold();
}

// ---------------------------------------------------------------------
//  Cap (print head-down, neck up; PLA/PETG)
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
            translate([0, 0, boss_z0 + boss_h - eps])
                cylinder(d1 = boss_d, d2 = neck_d, h = (neck_d - boss_d) / 2 + eps, $fn = fn_round);
            translate([0, 0, boss_z0 + 0.4])
                cylinder(d = boss_d, h = boss_h - 0.4 + eps, $fn = fn_round);
            translate([0, 0, boss_z0])
                cylinder(d1 = boss_d - 0.8, d2 = boss_d, h = 0.4 + eps, $fn = fn_round);
        }
        // keyed socket for the centre post
        translate([0, 0, boss_z0 - eps])
            linear_extrude(socket_depth + eps)
                square([post_w + 2 * socket_clear, post_l + 2 * socket_clear], center = true);
        // finger dish
        translate([0, 0, cap_under_z + head_h + dish_r - dish_depth]) sphere(r = dish_r, $fn = fn_round);
    }
}

// ---------------------------------------------------------------------
//  Simplified KY-023 mock-up (visualisation only, never exported)
// ---------------------------------------------------------------------
// Keep the y >= 0 half so the front view (rot 90,0,0) shows the cut face
module half() {
    intersection() {
        children();
        translate([-100, 0, -100]) cube([200, 200, 200]);
    }
}
// Colour a part, optionally cut in half (colour outside the cut keeps
// the cut face coloured too)
module cpart(col, cut) {
    color(col) if (cut) half() children(); else children();
}

module mock(cut = false) {
    pcb_l = 34; pcb_w = 26; pcb_t = 1.6;
    cpart("darkgreen", cut) translate([-20, -pcb_w / 2, -plate_h - pcb_t]) cube([pcb_l, pcb_w, pcb_t]);
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
    cpart("black", cut) translate([-19.5, -6.35, -plate_h - pcb_t - 2.5]) cube([2.5, 12.7, 2.5]);
    cpart("white", cut) intersection() {
        translate([0, 0, pivot_z]) sphere(r = -pivot_z + 0.5, $fn = 64);
        translate([-7, -7, -3]) cube([14, 14, 3.5]);
    }
    cpart("gold", cut) translate([-post_w / 2, -post_l / 2, 0.3]) cube([post_w, post_l, post_h - 0.3]);
}

module assembly(cut = false) {
    mock(cut);
    cpart("orange", cut) cap();
    cpart([0.25, 0.5, 0.9], cut) boot();
}

// ---------------------------------------------------------------------
//  Part selector
// ---------------------------------------------------------------------
if (part == "boot")                  boot();
else if (part == "cap")              cap();
else if (part == "test_ring")        base();
else if (part == "section")          cpart([0.25, 0.5, 0.9], true) boot();
else if (part == "assembly")         assembly();
else if (part == "assembly_section") assembly(true);
else if (part == "mock")             mock();
