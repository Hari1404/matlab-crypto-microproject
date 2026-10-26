#!/usr/bin/env python3
"""Draw the 6 STAND-IN figures of the network into docs/report_figures/.

Run from the project folder:
    octave --no-gui --eval "addpath('handoff'); export_figure_data('/tmp/figure_data.json')"
    python3 handoff/make_figures.py /tmp/figure_data.json

The places, colors, line widths, line styles and titles are NOT chosen here: they are read from
the JSON file that export_figure_data.m writes by running the real code (graph_layout,
picture_options, route_picture_options). This script only does what draw_network.m does with
them (lines first, circles of radius 0.6, bold names, edge labels e1, e2, ... at the middle of
each edge pushed 0.3 to the upper side, bold title, equal axes, no axis lines).

These pictures are matplotlib stand-ins, NOT screenshots of MATLAB figures. The owner replaces
them with the real PNG files of demo_point2 and main_demo (option 7), same file names.
"""
import json
import math
import os
import sys

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Circle

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTDIR = os.path.join(ROOT, 'docs', 'report_figures')
EDGE_OF_CIRCLE = (0.1, 0.2, 0.45)   # draw_network: 'EdgeColor', [0.1 0.2 0.45]
LABEL_GRAY = (0.25, 0.25, 0.25)     # draw_network: edge label color
FACE = 'white'                      # figure Color [1 1 1]
DPI = 150
WIDTH_PX = 900                      # figure Position width in show_route_picture / save_network_pictures
PX_PER_IN = 96.0                    # MATLAB screen pixels per inch


def draw_one(data, pic, outfile):
    users = data['users']
    edges = data['edges']
    xy = data['xy']
    radius = data['radius']
    n = len(users)
    m = len(edges)

    xs = [p[0] for p in xy]
    ys = [p[1] for p in xy]
    xlim = (min(xs) - 1.1, max(xs) + 1.1)       # h.xlim in draw_network
    ylim = (min(ys) - 1.1, max(ys) + 1.1)       # h.ylim in draw_network
    shape = (ylim[1] - ylim[0]) / (xlim[1] - xlim[0])
    height_px = min(900, max(300, round(864 * shape / 0.86) + 10))   # same rule as save_network_pictures

    fig = plt.figure(figsize=(WIDTH_PX / PX_PER_IN, height_px / PX_PER_IN), dpi=DPI, facecolor=FACE)
    ax = fig.add_axes([0.02, 0.02, 0.96, 0.86])
    ax.set_xlim(*xlim)
    ax.set_ylim(*ylim)
    ax.set_aspect('equal', adjustable='box', anchor='C')
    ax.axis('off')

    # lines first, so the circles cover their ends
    for e in range(m):
        i, j = edges[e][0] - 1, edges[e][1] - 1
        # MATLAB line widths are in points (1/72 in), matplotlib too
        ax.plot([xy[i][0], xy[j][0]], [xy[i][1], xy[j][1]],
                color=tuple(pic['edge_color'][e]),
                linewidth=pic['edge_width'][e],
                linestyle=pic['edge_style'][e],
                solid_capstyle='butt', zorder=1)

    for v in range(n):
        ax.add_patch(Circle((xy[v][0], xy[v][1]), radius,
                            facecolor=tuple(pic['vertex_color'][v]),
                            edgecolor=EDGE_OF_CIRCLE, linewidth=0.8, zorder=2))
        ax.text(xy[v][0], xy[v][1], users[v], ha='center', va='center',
                fontsize=11, fontweight='bold', zorder=3)

    for e in range(m):
        i, j = edges[e][0] - 1, edges[e][1] - 1
        dx, dy = xy[j][0] - xy[i][0], xy[j][1] - xy[i][1]
        nrm = math.hypot(dx, dy)
        nx, ny = -dy / nrm, dx / nrm
        # draw_network: use the normal that points up (for a vertical edge, the one that points right)
        if ny < -1e-12 or (abs(ny) <= 1e-12 and nx < 0):
            nx, ny = -nx, -ny
        mx = (xy[i][0] + xy[j][0]) / 2 + 0.3 * nx
        my = (xy[i][1] + xy[j][1]) / 2 + 0.3 * ny
        ax.text(mx, my, 'e%d' % (e + 1), ha='center', va='center',
                fontsize=9, color=LABEL_GRAY, zorder=3)

    ax.set_title(pic['title'], fontsize=13, fontweight='bold')
    fig.savefig(outfile, dpi=DPI, facecolor=FACE)
    plt.close(fig)


def main():
    if len(sys.argv) != 2:
        sys.exit('usage: python3 handoff/make_figures.py figure_data.json')
    with open(sys.argv[1]) as f:
        data = json.load(f)
    os.makedirs(OUTDIR, exist_ok=True)
    for pic in data['pictures']:
        out = os.path.join(OUTDIR, pic['name'] + '.png')
        draw_one(data, pic, out)
        print('wrote', os.path.relpath(out, ROOT), '|', pic['title'])


if __name__ == '__main__':
    main()
