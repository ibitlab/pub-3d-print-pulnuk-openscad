#!/usr/bin/env python3
"""Mesh sanity check for a binary STL: is it one closed, manifold solid?

Vertices are welded on a TOL grid first, the way a slicer welds them, and every
edge must then be used by exactly two triangles. Fewer means a hole, more means
two surfaces meeting along a line - typically a sliver pinched off by a boolean
between two descriptions of the same surface. Loose extra shells are reported
the same way: they slice into stray unsupported walls.

usage: check_mesh.py file.stl [parts=N]
       parts=N = the part is legitimately N separate bodies (default 1)
"""
import struct
import sys
from collections import defaultdict

TOL = 1e-4   # weld grid, mm: well over float32 noise, well under a print layer


def load_stl(path):
    data = open(path, "rb").read()
    n = struct.unpack("<I", data[80:84])[0]
    return [struct.unpack("<9f", data[84 + i * 50 + 12: 84 + i * 50 + 48]) for i in range(n)]


def main():
    path = sys.argv[1]
    parts = next((int(a[6:]) for a in sys.argv[2:] if a.startswith("parts=")), 1)
    tris = load_stl(path)
    key = lambda p: (round(p[0] / TOL), round(p[1] / TOL), round(p[2] / TOL))

    edges = defaultdict(list)
    live = []
    for i, v in enumerate(tris):
        k = [key(v[0:3]), key(v[3:6]), key(v[6:9])]
        if len(set(k)) < 3:          # collapses on the weld grid: carries no surface
            continue
        live.append(i)
        for a, b in ((k[0], k[1]), (k[1], k[2]), (k[2], k[0])):
            edges[tuple(sorted((a, b)))].append(i)
    degenerate = len(tris) - len(live)

    # connected components over triangles that share an edge
    parent = list(range(len(tris)))
    def find(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i
    for tt in edges.values():
        for t in tt[1:]:
            parent[find(tt[0])] = find(t)
    shells = len({find(i) for i in live})

    open_e = [e for e, tt in edges.items() if len(tt) < 2]
    extra_e = [e for e, tt in edges.items() if len(tt) > 2]
    print("%s: %d triangles (%d degenerate), %d edges, %d shells" %
          (path, len(tris), degenerate, len(edges), shells))
    bad = False
    for name, bucket in (("open (hole)", open_e), ("non-manifold", extra_e)):
        if bucket:
            bad = True
            print("  %d %s edges, e.g." % (len(bucket), name))
            for a, b in bucket[:3]:
                print("    (%.2f %.2f %.2f) - (%.2f %.2f %.2f)" %
                      (a[0] * TOL, a[1] * TOL, a[2] * TOL, b[0] * TOL, b[1] * TOL, b[2] * TOL))
    if shells > parts:
        bad = True
        print("  FAIL: %d separate shells, expected %d" % (shells, parts))
    if bad:
        sys.exit(1)
    print("  OK: closed manifold solid")


if __name__ == "__main__":
    main()
