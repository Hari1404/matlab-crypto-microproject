# PACKET 6A2: fix for MATLAB (a matrix as operand of &&)

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 6 (a fix between 6A and the next packet)
Goal: the first real MATLAB run stopped in `test_modular` because `show_cyclic` (line 83) uses `all(...)` of a matrix as an operand of `&&`. Octave accepts that, MATLAB does not. Replace it with `all(all(...))` in `src/group_theory/show_cyclic.m` and in the same check of `tests/test_group.m` (line 252), and add the rule to `PROGRESS.md`. Three files change, no new file. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `4dbdc1e 6A: the verification of the shared key, the decryption and the graph`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_6A2_FIXES.md` and `packets/MP6A2_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_6A2_FIXES.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP6A2_files.zip" -DestinationPath "." -Force`
2. Check that these 3 files exist at these paths (all three already existed and are now replaced):
   - `PROGRESS.md`
   - `src/group_theory/show_cyclic.m`
   - `tests/test_group.m`
3. Check the SHA-256 hash of all 3 files. All 3 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `4fb6f36d7aab250724f0b1b7cbf0ef50b21645628b9e13083853c7c5e5db6ea7` |
   | `src/group_theory/show_cyclic.m` | `a773525911d45f185109b76c30e769379143c82e5851c9b35c65da9eb1e9229c` |
   | `tests/test_group.m` | `06e0326469c3ee52d422fca33bb1acb307950182772ef1945d9d8bd0ba5fdbf5` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`). Run it exactly as it is written, do not shorten it:

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '4fb6f36d7aab250724f0b1b7cbf0ef50b21645628b9e13083853c7c5e5db6ea7',
 'src/group_theory/show_cyclic.m': 'a773525911d45f185109b76c30e769379143c82e5851c9b35c65da9eb1e9229c',
 'tests/test_group.m': '06e0326469c3ee52d422fca33bb1acb307950182772ef1945d9d8bd0ba5fdbf5',
}
ok = True
for f, h in files.items():
    actual = hashlib.sha256(open(f, 'rb').read()).hexdigest()
    same = (actual == h)
    ok = ok and same
    print(f, same)
print('ALL_MATCH:', ok)
"
```

   If the last line is not `ALL_MATCH: True`, stop.
4. Stage only these paths, with this exact command:
   `git add PROGRESS.md src/group_theory/show_cyclic.m tests/test_group.m packets/PACKET_6A2_FIXES.md`
5. Run `git status --short`. It must print exactly these 4 lines and nothing else:
```
M  PROGRESS.md
A  packets/PACKET_6A2_FIXES.md
M  src/group_theory/show_cyclic.m
M  tests/test_group.m
```
6. Commit with exactly this message: `6A2: fix && with a matrix operand, found by the first MATLAB run`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 3 of 3 match.
2. `git log -1 --oneline` shows the message `6A2: fix && with a matrix operand, found by the first MATLAB run`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly sixteen lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md`, `packets/PACKET_4A_DH.md`, `packets/PACKET_4B_ENCRYPT.md`, `packets/PACKET_5A_SYSTEM.md`, `packets/PACKET_5B_MAINDEMO.md`, `packets/PACKET_5C_ROUTEPIC.md`, `packets/PACKET_6A2_FIXES.md`, `packets/PACKET_6A_VERIFY.md`. No zip file is listed.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`. Also paste the output of the hash command of step 3.

## Owner check in MATLAB (MATLAB Online is fine)

1. Set the current folder to the repo folder (after `git pull`, or upload a new zip of the repo).
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. It runs all 14 test files and must end with `ALL TESTS PASSED`. The first run stopped at `test_modular`; it must now pass with `test_modular: 130 of 130 checks passed` and `test_group: 131 of 131 checks passed`. The last file is `test_verification: 32 of 32 checks passed`.
4. Type `demo_point6` and press Enter. Expected: three tables (6, 6 and 9 rows) whose rows all end with `yes`, then `In all: 21 of 21 checks agree.`
5. Send the planner the last 15 lines of `run_all_tests` and any red error text.

The planner ran the 11 test files that draw no picture in GNU Octave 8.4 with a strict check on every operand of `&&` and `||` (the way MATLAB checks them): all passed (770 checks) and no other bad operand was found. The `&&` and `||` lines of the picture code and of `test_route_picture` were read by hand (all operands are single values). `test_route_picture` and the picture part of `main_demo` have still not run in MATLAB: that is what step 3 shows.

Paste line for the agent:

`Read packets/{PN} and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
