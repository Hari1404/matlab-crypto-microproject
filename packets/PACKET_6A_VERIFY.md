# PACKET 6A: the verification of the shared key, the decryption and the graph

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 6 (tests, figures, report and slides), first packet
Goal: add four files to `src/integration/`: `reach_by_matrix` (which vertices reach which, with matrix products), `verify_system` (21 checks of the shared key, the decryption and the graph, each made a second way), `show_verification` (prints the checks as 3 tables) and `demo_point6`. Add the test `test_verification`. Change `run_all_tests`. Update PROGRESS.md and README.md. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `c2be75e 5C: the picture of the route in main_demo`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_6A_VERIFY.md` and `packets/MP6A_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_6A_VERIFY.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP6A_files.zip" -DestinationPath "." -Force`
2. Check that these 8 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/integration/demo_point6.m`
   - `src/integration/reach_by_matrix.m`
   - `src/integration/show_verification.m`
   - `src/integration/verify_system.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_verification.m`
3. Check the SHA-256 hash of all 8 files. All 8 must match exactly:

   | File | SHA-256 |
   | --- | --- |
| `PROGRESS.md` | `6c747d433a40bb9b660a6ecd9ea1ded24e603ab7fa471d5ed70e875673dbf301` |
| `README.md` | `abc63af543cee1b09150679579bc586085c161ef434dce589a6eed4e5df63980` |
| `src/integration/demo_point6.m` | `5a336c932f3e6321a83c08b7b8bb1c15b082374e242225a6aa741d5cced6bcf8` |
| `src/integration/reach_by_matrix.m` | `a56a30e86b6985384b84591e29cff31131ec7983431a5461434cc79451d3de7c` |
| `src/integration/show_verification.m` | `dcd073b190dd87d8a9076938b4fc38b4cc254c7122c92dd387725d4c3c6e86a7` |
| `src/integration/verify_system.m` | `08ce28fa11ec56d06c28febf57b7ca9828c35fa2a821263b00a64d8749acb8ed` |
| `tests/run_all_tests.m` | `362ceefa17837ae79f9eeba23bbc0666fae8a55bc531d6223b0abf0bba3bd06f` |
| `tests/test_verification.m` | `3b584e75383ca897d9da2f87c9d0612a60112b91e53359aff356dfb25acc9056` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`). Run it exactly as it is written, do not shorten it:

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '6c747d433a40bb9b660a6ecd9ea1ded24e603ab7fa471d5ed70e875673dbf301',
 'README.md': 'abc63af543cee1b09150679579bc586085c161ef434dce589a6eed4e5df63980',
 'src/integration/demo_point6.m': '5a336c932f3e6321a83c08b7b8bb1c15b082374e242225a6aa741d5cced6bcf8',
 'src/integration/reach_by_matrix.m': 'a56a30e86b6985384b84591e29cff31131ec7983431a5461434cc79451d3de7c',
 'src/integration/show_verification.m': 'dcd073b190dd87d8a9076938b4fc38b4cc254c7122c92dd387725d4c3c6e86a7',
 'src/integration/verify_system.m': '08ce28fa11ec56d06c28febf57b7ca9828c35fa2a821263b00a64d8749acb8ed',
 'tests/run_all_tests.m': '362ceefa17837ae79f9eeba23bbc0666fae8a55bc531d6223b0abf0bba3bd06f',
 'tests/test_verification.m': '3b584e75383ca897d9da2f87c9d0612a60112b91e53359aff356dfb25acc9056',
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
   `git add PROGRESS.md README.md src/integration/demo_point6.m src/integration/reach_by_matrix.m src/integration/show_verification.m src/integration/verify_system.m tests/run_all_tests.m tests/test_verification.m packets/PACKET_6A_VERIFY.md`
5. Run `git status --short`. It must print exactly these 9 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_6A_VERIFY.md
A  src/integration/demo_point6.m
A  src/integration/reach_by_matrix.m
A  src/integration/show_verification.m
A  src/integration/verify_system.m
M  tests/run_all_tests.m
A  tests/test_verification.m
```
6. Commit with exactly this message: `6A: the verification of the shared key, the decryption and the graph`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 8 of 8 match.
2. `git log -1 --oneline` shows the message `6A: the verification of the shared key, the decryption and the graph`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly fifteen lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md`, `packets/PACKET_4A_DH.md`, `packets/PACKET_4B_ENCRYPT.md`, `packets/PACKET_5A_SYSTEM.md`, `packets/PACKET_5B_MAINDEMO.md`, `packets/PACKET_5C_ROUTEPIC.md` and `packets/PACKET_6A_VERIFY.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`. Also paste the output of the hash command of step 3.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then 71 lines starting with PASS, then `test_dh: 71 of 71 checks passed`, then 101 lines starting with PASS, then `test_encryption: 101 of 101 checks passed`, then 69 lines starting with PASS, then `test_system: 69 of 69 checks passed`, then 59 lines starting with PASS, then `test_main_demo: 59 of 59 checks passed`, then 64 lines starting with PASS, then `test_route_picture: 64 of 64 checks passed`, then 32 lines starting with PASS, then `test_verification: 32 of 32 checks passed`. Then the last line `ALL TESTS PASSED`. No figure window may stay open after it.
4. Type `demo_point6` and press Enter. It takes a few seconds and opens no window. Expected: the title `=== VERIFICATION: THE KEY, THE DECRYPTION AND THE GRAPH ===`, then three tables (`1. The shared key`, `2. Encryption and decryption`, `3. The graph`) with 6, 6 and 9 rows. Every row ends with `yes` (none ends with `NO`). Then `In all: 21 of 21 checks agree.` and `The same checks after the channel Dave - Frank is removed (2 groups: {Alice, Bob, Carol, Dave}  {Frank, Grace}):` and `  21 of 21 checks agree.`
5. Type `V = verify_system(); size(V), all(cell2mat(V(:, 4)))` and press Enter. Expected: `ans =` and the numbers `21 4`, then `ans =` and `1`.
6. Type `Y = define_system(); Y.D.public(2) = mod(Y.D.public(2), 90) + 2; show_verification(Y)` and press Enter. This gives Bob a wrong public value on purpose, so the checks must notice it. Expected: `NO` at the end of 7 rows (rows 1, 2, 4, 5 and 6 of the first table and rows 1 and 4 of the second table) and `In all: 14 of 21 checks agree.` and `  14 of 21 checks agree.`
7. Type `demo_point5` and press Enter. It must still print one `Checks:` block of 7 lines that all end with `yes` (none ends with `NO`).
8. Run `git status --short` in a terminal. It must print nothing (the verification writes no files).

The planner already ran steps 2 to 6 in GNU Octave 8.4: the 11 test files that draw no picture passed after the last change (25 of 25, 51 of 51, 50 of 50, 51 of 51, 130 of 130, 131 of 131, 71 of 71, 101 of 101, 69 of 69, 59 of 59, 32 of 32 checks; `test_verification` has 32 checks, with no window and nothing written into `outputs/`). The 3 test files that draw pictures (`test_graph_analysis`, `test_graph_pictures`, `test_route_picture`: 120 of 120, 129 of 129, 64 of 64 checks) could not draw in the planner's Octave and were not run again; 6A does not change them, and they passed in the full run of all 14 test files made before the last change to `test_verification` (it had 31 checks then), and `demo_point6` printed the texts above in a few seconds. The checks were tested by breaking the code on purpose (mutation test, `verify/mutation_test_result.txt` in the planner's folder): 20 of 21 bugs put into the old code of Points 1 to 5 were found by `verify_system` (13 as a NO row, 7 as a stop with an error); the one that was not found: removing a channel on one side only is outside the 21 checks of `verify_system` (it never removes a channel itself), and `test_graph_analysis` finds it. 16 of 30 bugs put into the new code (the checks switched off one by one, and other wrong versions of the new files) were found by `test_verification`; not found: row 3 (the key is in the key set) cannot say NO: `dh_shared_key` and the encryption stop with an error first, so it is only a safety check; not found: row 8 (the cipher by hand) only says NO when the cipher code is wrong; the old-code bug 3 (encrypt +1) turned it to NO; not found: row 9 (every wrong key fails) never said NO: `decrypt_symbols` already refuses a wrong key, and no simple bug in the old code gives the text back with a wrong key; the check is sound but was never seen to say NO; not found: row 12 (cipher numbers are in C) only says NO when `route_message` is wrong; the old-code bug 21 (a cipher number outside C) turned it to NO; not found: row 13 (A is symmetric, no loop) cannot say NO: `check_system` stops with an error first for such a matrix, so it is only a safety check; not found: row 14 (matrix and edge list) only says NO when the graph code is wrong; old-code bug 18 turned it to NO; not found: row 15 (matrix and list) only says NO when the graph code is wrong; old-code bug 17 turned it to NO; not found: row 16 (finite distances = reach) only says NO when `distance_matrix` is wrong; old-code bug 20 turned it to NO; not found: row 17 (distances = matrix powers) only says NO when the graph code is wrong; old-code bugs 12 and 20 turned it to NO; not found: row 18 (shortest paths) only says NO when the graph code is wrong; old-code bug 20 turned it to NO; not found: row 19 (groups) only says NO when `connected_components` is wrong; old-code bug 9 turned it to NO; not found: row 20 (bridges) only says NO when `bridge_channels` is wrong; old-code bug 10 turned it to NO; not found: row 21 (cut users) only says NO when `cut_users` is wrong; old-code bug 11 turned it to NO; not found: this wrong version gives the same yes or no answers (the counts only grow, they never become 0 or overflow for 6 users), so it is not really a bug. There is no new cipher or key maths in 6A: the 21 checks only look at what Points 1 to 5 already do, each a second way.

Paste line for the agent:

`Read packets/PACKET_6A_VERIFY.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
