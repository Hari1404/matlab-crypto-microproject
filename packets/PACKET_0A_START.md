# PACKET 0A: Project start

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 0 (Start)
Goal: put the agent rules, the progress file, the README, the folder layout and the setup script into the repo in one commit and push it.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. This folder must be the clone of `https://github.com/Hari1404/matlab-crypto-microproject.git`. Run `git remote -v` and confirm origin is that URL. If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log --oneline`. It must show only one commit, `Initial commit`. If there is anything else, stop and report it.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_0A_START.md` and `packets/MP0A_files.zip` must exist in this folder.

## Steps

1. Extract `packets/MP0A_files.zip` into the repository root (the folder that contains `.git`). Any method is fine (`tar -xf`, PowerShell `Expand-Archive`, or `python -m zipfile -e`). When asked, overwrite the existing `README.md`.
2. Check that these 14 files now exist at these paths:
   - `README.md`
   - `.gitignore`
   - `AGENTS.md`
   - `PROGRESS.md`
   - `setup_project.m`
   - `src/sets_relations_functions/.gitkeep`
   - `src/graph_network/.gitkeep`
   - `src/group_theory/.gitkeep`
   - `src/diffie_hellman/.gitkeep`
   - `src/encryption/.gitkeep`
   - `src/integration/.gitkeep`
   - `tests/.gitkeep`
   - `outputs/.gitkeep`
   - `docs/.gitkeep`
3. Check the SHA-256 hash of the five real files (any method, for example python `hashlib`). All five must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `.gitignore` | `f95ed9077622ffb0a4fa0fd206636d136c3deaac6fed10955135d69b0fc0e6aa` |
   | `README.md` | `fc20462eb89f7edca77220c14c3836221ced3be342dc1fb4b0440a97290a7c1d` |
   | `AGENTS.md` | `25f7d3c958ca7a30f8c0a0430f4caad1c56cf372f3a47a27ebcb84cf081884a6` |
   | `PROGRESS.md` | `8cc68809649a5fc5a21218659bed56611c9aa1380d3eb02069724dcaa9e67bc0` |
   | `setup_project.m` | `efc4e1c5df7833fbcbac24f224b8b8547661baec16bca10fc4465c68a309eaf1` |

   The nine `.gitkeep` files must be empty (0 bytes).
4. Stage only these paths: `git add README.md .gitignore AGENTS.md PROGRESS.md setup_project.m src tests outputs docs packets/PACKET_0A_START.md`
5. Run `git status`. Confirm that only the files above are staged and that `packets/MP0A_files.zip` is not staged.
6. Commit with exactly this message: `0A: project start (rules, progress, README, folders, setup_project)`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 5 of 5 match.
2. `.gitkeep` files: 9 of 9 exist and are empty.
3. `git log -1 --oneline` shows the message `0A: project start (rules, progress, README, folders, setup_project)`.
4. `git status -sb` shows `main...origin/main` with no `ahead` and no `behind`.
5. `git ls-files packets` prints only `packets/PACKET_0A_START.md`. The zip is not tracked.
6. If `matlab` is available on the command line, run `matlab -batch "setup_project"`. It must print `Project paths added.` and no error. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (after the agent reports)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected output: `Project paths added. Project folder: ...` with no error.
3. Open the repo page on GitHub and refresh. You should see the README with the status list of points, `PROGRESS.md`, `AGENTS.md` and the folders.

Paste line for the agent:

`Read packets/PACKET_0A_START.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
