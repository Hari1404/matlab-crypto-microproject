# Prompt for the next Claude session (status at CP-05)

Attach the LATEST zip (matlab-crypto-microproject_CHECKPOINT_05.zip), read CHECKPOINT.md, install Octave
(apt-get update first), and run the baseline: octave --no-gui --eval "run('handoff/collect_checks.m')".
It must say TOTAL: 1196 of 1196. If not, STOP and tell the owner.

STATUS
- All code, tests, the report (28 pages), flowcharts and slides are finished, including packet 2D (directed graph).
- Nothing is left to code. Do NOT redesign.
- Open items are the OWNER's: push to GitHub (GitHub stops at 7B); the real MATLAB run (run_all_tests,
  demo_point2, demo_point2d, main_demo option 7); replace the PNGs in docs/report_figures/ with the MATLAB ones,
  delete the "Note on these figures" paragraph (Section 5.8), rebuild with python3 handoff/build_report.py.
- If the owner sends MATLAB failures: fix the .m file, add a test, rerun the baseline, update CHECKPOINT.md.
- Optional, small: one line about directed graphs on the graph slide of docs/Crypto_Microproject_Presentation.pptx
  (use the pptx skill). Not done in CP-05.
- To draw figures in Octave: apt-get install gnuplot-nox ghostscript fonts-freefont-otf fonts-freefont-ttf, then
  graphics_toolkit('gnuplot') before the test or demo.
