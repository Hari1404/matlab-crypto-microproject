# Report figures - STAND-INS, not MATLAB screenshots

The 3 files point2d_*.png (directed graph) are different: they were written by the real function
`save_digraph_pictures` (so by the real `draw_digraph`) in GNU Octave 8.4 with the gnuplot toolkit.
They are Octave renders, not MATLAB screenshots; `demo_point2d` in MATLAB writes the same file names.

The other 6 PNG files were drawn by `handoff/make_figures.py` (matplotlib), not by MATLAB.
The places, colors, line widths, line styles and titles come from the real code
(`graph_layout`, `picture_options`, `route_picture_options`), read out by
`handoff/export_figure_data.m` in GNU Octave. The drawing itself copies `draw_network`.

| File | Made in MATLAB by |
|---|---|
| point2_network.png | demo_point2 (picture 1) |
| point2_shortest_path.png | demo_point2 (picture 2) |
| point2_cycle.png | demo_point2 (picture 3) |
| point2_weak_points.png | demo_point2 (picture 4) |
| point2_split.png | demo_point2 (picture 5) |
| point5_route.png | main_demo, send Alice to Grace, option 7 |
| point2d_digraph.png | demo_point2d (picture 1) |
| point2d_path.png | demo_point2d (picture 2) |
| point2d_strong.png | demo_point2d (picture 3) |

To replace them with the real pictures: run those commands in MATLAB, copy the PNG files from
`outputs/` over these files (same names), delete the paragraph that starts with
"Note on these figures" in Section 5.8 of `docs/report/Technical_Report.md`, and run
`python3 handoff/build_report.py`.
