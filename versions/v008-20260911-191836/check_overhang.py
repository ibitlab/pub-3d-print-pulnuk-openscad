#!/usr/bin/env python3
"""Printability check for an axisymmetric binary STL printed along +Z.

Cuts the mesh with the half-plane y = 0, x >= 0 to get the (r, z) profile,
slices it every DZ and verifies that every solid interval of a slice rests on
the slice below (allowing an overhang of MAX_DEG). Reports islands (material
starting in the air) and overhangs. Exit code 1 if anything is found.

usage: check_overhang.py file.stl [max_overhang_deg] [flip]
       flip = the part is printed upside down (checks along -Z)
"""
import math
import struct
import sys

DZ = 0.1


def load_stl(path):
    data = open(path, "rb").read()
    n = struct.unpack("<I", data[80:84])[0]
    tris = []
    for i in range(n):
        v = struct.unpack("<12f", data[84 + i * 50: 84 + i * 50 + 48])
        tris.append(((v[3], v[4], v[5]), (v[6], v[7], v[8]), (v[9], v[10], v[11])))
    return tris


def profile_segments(tris):
    """Intersect triangles with the plane y = 0, keep x >= 0: list of ((x, z), (x, z))."""
    segs = []
    for tri in tris:
        pts = []
        for a, b in ((tri[0], tri[1]), (tri[1], tri[2]), (tri[2], tri[0])):
            if (a[1] < 0) != (b[1] < 0):
                t = a[1] / (a[1] - b[1])
                pts.append((a[0] + t * (b[0] - a[0]), a[2] + t * (b[2] - a[2])))
        if len(pts) == 2 and max(pts[0][0], pts[1][0]) >= 0:
            segs.append((pts[0], pts[1]))
    return segs


def intervals_at(segs, z):
    xs = []
    for (x0, z0), (x1, z1) in segs:
        if (z0 <= z < z1) or (z1 <= z < z0):
            xs.append(x0 + (z - z0) / (z1 - z0) * (x1 - x0))
    xs = sorted(x for x in xs if x >= -1e-6)
    if len(xs) % 2:                      # solid across the axis: x = 0 is a boundary
        xs.insert(0, 0.0)
    return [(xs[i], xs[i + 1]) for i in range(0, len(xs) - 1, 2)]


def main():
    path = sys.argv[1]
    max_deg = float(sys.argv[2]) if len(sys.argv) > 2 else 45.0
    flip = len(sys.argv) > 3 and sys.argv[3] == "flip"
    tol = DZ * math.tan(math.radians(max_deg)) + 0.02
    segs = profile_segments(load_stl(path))
    if flip:
        segs = [((a[0], -a[1]), (b[0], -b[1])) for a, b in segs]
    zmin = min(min(p[0][1], p[1][1]) for p in segs)
    zmax = max(max(p[0][1], p[1][1]) for p in segs)
    problems = []
    prev = None
    z = zmin + DZ / 2
    while z < zmax:
        cur = intervals_at(segs, z)
        if prev is not None:
            for a, b in cur:
                supported = any(a - tol <= d and b + tol >= c for c, d in prev)
                if not supported:
                    problems.append((z, a, b, "island"))
                    continue
                # overhang: how far the interval reaches beyond every interval below
                reach = min(max(c - a, b - d, 0) for c, d in prev)
                if reach > tol:
                    problems.append((z, a, b, "overhang %.0f deg" % math.degrees(math.atan2(reach, DZ))))
        prev = cur
        z += DZ
    print("%s: z %.2f..%.2f, print height %.2f mm, %d slices" %
          (path, zmin, zmax, zmax - zmin, int((zmax - zmin) / DZ)))
    if problems:
        last = None
        for z, a, b, kind in problems:
            if last is None or z - last > DZ * 1.5 or kind != last_kind:
                print("  %s at z %.2f (print height %.2f) r %.2f..%.2f" % (kind, z, z - zmin, a, b))
            last, last_kind = z, kind
        print("  FAIL: %d slices" % len(problems))
        sys.exit(1)
    print("  OK: every slice rests on the one below (<= %.0f deg)" % max_deg)


if __name__ == "__main__":
    main()
