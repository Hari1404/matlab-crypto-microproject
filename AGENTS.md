# MP — agent rules

You execute written packets. You do not design.

1. Do exactly what the packet says, in the order written. Nothing more.
2. Read only the files the packet names. Do not scan or explore the repo.
3. Copy content files verbatim. Do not rewrite, improve, or rename.
4. Do not propose alternatives. Do not ask which option to choose.
5. Do not add features, toolboxes or dependencies that are not in the packet. Base MATLAB only.
6. If a step is unclear, a file is missing, a command fails, or the result differs from "expected": STOP. Report the exact error. Do nothing else.
7. Never put secrets (tokens, passwords) in any file.
8. When finished, reply only: "DONE <packet id>" and the result of the packet's done-checks. Maximum 5 lines. No summary, no explanation.
9. MATLAB checks: if `matlab` works on the command line, run the packet's check with `matlab -batch "<command>"` and report its real output. If it does not, write "MATLAB check skipped, owner will run it". Never say a MATLAB check passed when it was not run.
10. Git: the commit message starts with the packet id. Push to main only. Never force push, never rebase.
11. Never commit the zip files in the packets folder.
