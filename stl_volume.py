#!/usr/bin/env python3
"""Volume, surface and mean thickness of binary STLs.

The volume comes from the divergence theorem over the triangles, so it is
signed: a correctly oriented solid is positive, and a boolean that was supposed
to come out empty reads ~0. For such a residue the number that means something
is not the volume but the mean thickness 2 * V / A - compare it with the layer
height. A 2 um film is boolean tolerance; a 0.4 mm ring is a real feature that
will print as a loose piece of plastic.

usage: stl_volume.py file.stl [file.stl ...]
"""
import struct
import sys


def load(path):
    d = open(path, "rb").read()
    n = struct.unpack("<I", d[80:84])[0]
    return [struct.unpack("<9f", d[84 + i * 50 + 12: 84 + i * 50 + 48]) for i in range(n)]


def measure(tris):
    vol = area = 0.0
    for t in tris:
        p, q, r = t[0:3], t[3:6], t[6:9]
        vol += (p[0] * (q[1] * r[2] - r[1] * q[2])
                - p[1] * (q[0] * r[2] - r[0] * q[2])
                + p[2] * (q[0] * r[1] - r[0] * q[1])) / 6.0
        u = (q[0] - p[0], q[1] - p[1], q[2] - p[2])
        v = (r[0] - p[0], r[1] - p[1], r[2] - p[2])
        c = (u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0])
        area += (c[0] ** 2 + c[1] ** 2 + c[2] ** 2) ** 0.5 / 2
    return vol, area


def main():
    for path in sys.argv[1:]:
        name = path.split("/")[-1]
        # an empty result is written as no file at all, which for a boolean that
        # was supposed to come out empty is the cleanest possible pass
        try:
            tris = load(path)
        except FileNotFoundError:
            print("%12.4f mm3  %s (nothing exported)" % (0.0, name))
            continue
        if not tris:
            print("%12.4f mm3  %s (empty)" % (0.0, name))
            continue
        vol, area = measure(tris)
        pts = [(t[i], t[i + 1], t[i + 2]) for t in tris for i in (0, 3, 6)]
        box = tuple(max(p[k] for p in pts) - min(p[k] for p in pts) for k in (0, 1, 2))
        thick = 2 * abs(vol) / area if area > 1e-9 else 0.0
        print("%12.4f mm3  %s: %d tris, %.1f mm2, mean thickness %.4f mm, "
              "box %.1f x %.1f x %.1f" % (vol, name, len(tris), area, thick, *box))


if __name__ == "__main__":
    main()
