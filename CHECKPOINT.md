# CHECKPOINT - read this first

This file is the hand-off between work sessions. Several Claude instances (and the owner)
work on this project one after another. Each one reads this file, does the next open task,
updates this file, and makes a new zip.

**The repo is this folder** (`matlab-crypto-microproject/`). It is the same project as
https://github.com/Hari1404/matlab-crypto-microproject. GitHub has the same content as this
folder since the push of 2026-10-26 (see "GitHub status" below).

## Current checkpoint: CP-03   (zip name: matlab-crypto-microproject_CHECKPOINT_03.zip)

## What is finished (do not redo)
- Code, Points 0-5 and 7, the verification of Point 6 (verify_system, verify_rsa), the
  5 flowcharts (docs/flowcharts/) and the 11-slide deck (docs/Crypto_Microproject_Presentation.pptx).
- Real test result in GNU Octave 8.4 (CP-01): **1094 of 1094 checks pass, 0 FAIL lines**
  in 14 test files (test_sets 25, test_relations 51, test_cipher 50, test_graph 51,
  test_modular 130, test_group 131, test_dh 71, test_encryption 101, test_system 69,
  test_verification 32, test_rsa 109, test_rsa_users 188, test_rsa_verification 27,
  test_main_demo 59).
- NOT run by Claude (they draw figures, and headless Octave cannot): test_graph_analysis,
  test_graph_pictures, test_route_picture. A full MATLAB run of the FINAL code is NOT confirmed:
  the only recorded MATLAB run is packet 6A2 (R2026b, early tests, one fix). The owner's
  "all tests passed" referred to the Octave run above. Treat MATLAB as still to be run.

## Open tasks (in this order; tick them off when done)
- [x] CP-01  Hand-off file, check script (handoff/collect_checks.m), baseline verified.
- [x] CP-02  Technical report: docs/Technical_Report.docx (+ .pdf copy), 24 pages, built from
             docs/report/Technical_Report.md by `python3 handoff/build_report.py`.
             EDIT THE MARKDOWN, THEN REBUILD. Never edit the docx by hand.
- [x] CP-03  Report figures: 6 stand-in PNGs in docs/report_figures/ (same names as the MATLAB
             files), inserted as Figures 6-11 in Section 5.7 with an honest "Note on these
             figures" paragraph. Report rebuilt: 26 pages. The pictures stay STAND-INS until the
             owner replaces them (see docs/report_figures/README.md).
- [ ] CP-04  Directed graphs: the proposal mentions them, the code is undirected only.
             OWNER MUST DECIDE: (a) add a small directed-graph packet (2D), or
             (b) keep undirected and say why in the report (channels are two-way: R1 is
             symmetric). Until the owner decides, the report uses (b) wording in one
             short subsection that is easy to change.
- [ ] CP-05  Final pass: README.md and PROGRESS.md updated (Point 6 ticked, report listed),
             report re-read against the code, final zip.
- [x] OWNER  Push this zip's content to GitHub (it had 7C, 6B and the report; GitHub stopped at 7B). Done on 2026-10-26: pushed to main in 2 commits (7C code and tests; then the docs, the report and the hand-off files). The file `octave-workspace` from the zip was NOT pushed (it is an Octave session dump, not project content).
- [ ] OWNER  On the demo laptop in MATLAB (R2026b): setup_project, run_all_tests (must end with ALL TESTS PASSED), demo_point2, main_demo (option 7),
             then copy the real PNGs from outputs/ over docs/report_figures/ (same file names), delete the
             "Note on these figures" paragraph in Section 5.7 of the markdown, and run handoff/build_report.py.

## How to continue (for the next instance)
1. Unzip, read this file, then PROGRESS.md "Locked decisions" if you touch any code.
2. Do ONLY the first open task above. Do not redesign.
3. Check the code still passes (no MATLAB here; use Octave):
   ```
   apt-get update -qq && apt-get install -y -qq --no-install-recommends octave   # apt-get update first, or it fails with 404
   octave --no-gui --eval "run('handoff/collect_checks.m')"      % expect TOTAL: 1094 of 1094
   ```
   Rebuilding the report needs: pandoc, python3-docx, libreoffice-writer AND libreoffice-math
   (without it the equations are blank in the PDF), poppler-utils. Then:
   `python3 handoff/build_report.py`   (builds the docx, renders the PDF, fills the contents page numbers).
   Stand-in figures (only if the layout or colors in the code change):
   `octave --no-gui --eval "addpath('handoff'); export_figure_data('/tmp/figure_data.json')"` then
   `python3 handoff/make_figures.py /tmp/figure_data.json`, then rebuild the report.
   Headless Octave cannot draw figures (error: ft_text_renderer / no graphics toolkits).
   That is the sandbox, not a bug. Never say a MATLAB check passed when it was not run.
4. Update THIS file: tick the task, add a line to the log, change "Current checkpoint".
5. Zip the whole folder as `matlab-crypto-microproject_CHECKPOINT_<NN>.zip` (next number)
   and present it. Never put secrets in any file. Do not commit zip files into packets/.

## Code rules (only if you change code; full list in PROGRESS.md)
- Base MATLAB only, must also run in GNU Octave, plain ASCII in .m files, single-quoted text.
- Both sides of && and || must be one true/false value (use all(all(M)), isempty, isscalar).
- One function per file, file name = function name; tests are functions that print PASS/FAIL
  through summarize_checks and are added to tests/run_all_tests.m.
- Tests never write into outputs/.

## Report facts the next instance needs
- Report file: docs/Technical_Report.docx (source: docs/report/Technical_Report.md). Section layout is Claude's choice (the repo has no
  template): Abstract, 1 Introduction, 2 Mathematical background, 3 System design,
  4 Implementation (algorithms), 5 Results and verification, 6 Security analysis and
  limitations, 7 Conclusion, References, Appendix (how to run, file list).
  If the owner's guide gives a different layout, re-order the sections; the text is reusable.
- Team (6): Santanu Barua, M Hariharan, Kushi Pathak, P Abdul Wasim, Someshwar A,
  Adithya Sampath Kumar. Alliance University, Alliance College of Engineering and Design.
- Key numbers: p = 97, g = 5, 6 users, 6 channels, Alice-Bob DH key 85, channel keys
  85 12 42 90 32 72; RSA p = 61, q = 53, e = 17, n = 3233, d = 2753.
- Demo output text used for the report was captured from the real code (Octave) in CP-01.

## Figures (honest-labelling rule)
Claude cannot run the MATLAB figure code in its sandbox. Any picture Claude draws itself
(matplotlib) is a STAND-IN with the same layout and colours as draw_network. It must be
saved under docs/report_figures/ with the same base name as the MATLAB file
(point2_network.png, point2_shortest_path.png, point2_cycle.png, point2_weak_points.png,
point2_split.png, point5_route.png), and the report must not claim it is a MATLAB screenshot
until the owner has replaced it with the real PNG.

## GitHub status
GitHub (main) had packets up to 7B. On 2026-10-26 the rest of this folder was pushed: 7C
(src/rsa/verify_rsa.m, show_rsa_verification.m, tests/test_rsa_verification.m, demo_point7 and
run_all_tests changes), 6B (docs/flowcharts, docs/Crypto_Microproject_Presentation.pptx), the
report (docs/report, docs/Technical_Report.docx and .pdf, docs/report_figures), handoff/, this
file, and the README/PROGRESS updates. Not pushed: `octave-workspace` (session dump).
A Claude session can push only when the owner has given that session push access to the repo;
otherwise the owner pushes.

## Log
- CP-01: cloned the GitHub repo and compared it with the uploaded zip (zip is ahead by
  7C, 6B). Installed Octave 8.4 in the sandbox, ran 14 test files: 1094 of 1094 pass.
  Added CHECKPOINT.md and handoff/collect_checks.m. No code in src/ or tests/ was changed.
- CP-02: wrote the report (7 sections, abstract, references [1]-[7], Appendix A how to run,
  Appendix B function list generated from the real file names; 9 tables, 5 flowchart figures).
  All numbers come from the code, PROGRESS.md and demo output captured in Octave (keys, tables,
  verification counts, RSA values were cross-checked). Added handoff/build_report.py. Visual check
  of every page done in the rendered PDF. Known and accepted: LibreOffice shows 'mod' and 'gcd'
  in italics inside equations (Word shows them upright); the docx validator reports only
  pandoc-origin schema warnings (styles, numbering, settings, math), the same as plain pandoc output.
  The 'Table 9' list and the line counts (116 files, 4,647 lines; tests 20 files, 3,654 lines)
  must be refreshed if code files are added.
- CP-03: re-ran the baseline in Octave 8.4 first: 1094 of 1094, 0 FAIL lines (src/ and tests/ unchanged
  from CP-02, checked with diff). Added handoff/export_figure_data.m (runs the real graph_layout,
  picture_options and route_picture_options in Octave and writes the drawing data as JSON) and
  handoff/make_figures.py (draws the 6 pictures like draw_network). The data agrees with the code:
  bridges e5 Dave-Frank and e6 Frank-Grace, cut users Dave and Frank, cycle Alice-Bob-Dave-Carol,
  removing Dave-Frank gives {Alice,Bob,Carol,Dave} and {Frank,Grace}, route keys 85, 42, 32, 72.
  Section 5.7 now has Figures 6-11; the report has 26 pages and the contents page numbers were
  refreshed. libreoffice-math had to be installed again for the PDF equations. The file and line
  counts in Tables 2 and 9 are unchanged (handoff/ is not counted). Next open task: CP-04.
