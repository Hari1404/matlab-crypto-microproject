# PACKET 5B: the typed demo, main_demo

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 5 (the whole system), second packet
Goal: add four files to `src/integration/`: `main_demo` (the demo with typed prompts: a menu, choose the sender, the receiver and the text, the message travels along the route, break and repair channels), and its helpers `read_answer`, `pick_user` and `show_route`. Add the test `test_main_demo`. Change `run_all_tests`. Update PROGRESS.md and README.md. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `158e98b 5A: the secure network, keys on the channels and messages along the paths`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_5B_MAINDEMO.md` and `packets/MP5B_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_5B_MAINDEMO.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP5B_files.zip" -DestinationPath "." -Force`
2. Check that these 8 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/integration/main_demo.m`
   - `src/integration/pick_user.m`
   - `src/integration/read_answer.m`
   - `src/integration/show_route.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_main_demo.m`
3. Check the SHA-256 hash of all 8 files. All 8 must match exactly:

   | File | SHA-256 |
   | --- | --- |
| `PROGRESS.md` | `f2c1bfe9fd805a329d6a7f285e6b62eb4f39335e8d9fffcbc8435c1798925dbd` |
| `README.md` | `ef8aa18c489dc43cd07818452f78cae3c23f2e471de89d76d32d3d699620aaa8` |
| `src/integration/main_demo.m` | `cfa9dfb14a739d40e01fbaab1b7606958474f87b6495d35bcca67b7e49b083ca` |
| `src/integration/pick_user.m` | `66d83e1af4118d0d473030fa38f47f37e0ea62e120c2ca28f47019fca5666a1f` |
| `src/integration/read_answer.m` | `4328ecc72b2da921d714393d37822910309655e0ee4eae3cb595b04890bc99ec` |
| `src/integration/show_route.m` | `bfb05cccfbec8b27b88baa5a8ba06f976b947f166936048df868085a82f5fb76` |
| `tests/run_all_tests.m` | `d47bcb1aa24f94ee5bf577af274c0742a0865821fccde4de824573a6d9bf02f5` |
| `tests/test_main_demo.m` | `3c3ea0de595336421d05ca5269ca80c91cfdcb5508660e676d643b27cb285467` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': 'f2c1bfe9fd805a329d6a7f285e6b62eb4f39335e8d9fffcbc8435c1798925dbd',
 'README.md': 'ef8aa18c489dc43cd07818452f78cae3c23f2e471de89d76d32d3d699620aaa8',
 'src/integration/main_demo.m': 'cfa9dfb14a739d40e01fbaab1b7606958474f87b6495d35bcca67b7e49b083ca',
 'src/integration/pick_user.m': '66d83e1af4118d0d473030fa38f47f37e0ea62e120c2ca28f47019fca5666a1f',
 'src/integration/read_answer.m': '4328ecc72b2da921d714393d37822910309655e0ee4eae3cb595b04890bc99ec',
 'src/integration/show_route.m': 'bfb05cccfbec8b27b88baa5a8ba06f976b947f166936048df868085a82f5fb76',
 'tests/run_all_tests.m': 'd47bcb1aa24f94ee5bf577af274c0742a0865821fccde4de824573a6d9bf02f5',
 'tests/test_main_demo.m': '3c3ea0de595336421d05ca5269ca80c91cfdcb5508660e676d643b27cb285467',
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
   `git add PROGRESS.md README.md src/integration/main_demo.m src/integration/pick_user.m src/integration/read_answer.m src/integration/show_route.m tests/run_all_tests.m tests/test_main_demo.m packets/PACKET_5B_MAINDEMO.md`
5. Run `git status --short`. It must print exactly these 9 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_5B_MAINDEMO.md
A  src/integration/main_demo.m
A  src/integration/pick_user.m
A  src/integration/read_answer.m
A  src/integration/show_route.m
M  tests/run_all_tests.m
A  tests/test_main_demo.m
```
6. Commit with exactly this message: `5B: main_demo, the demo with typed prompts`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 8 of 8 match.
2. `git log -1 --oneline` shows the message `5B: main_demo, the demo with typed prompts`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly thirteen lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md`, `packets/PACKET_4A_DH.md`, `packets/PACKET_4B_ENCRYPT.md`, `packets/PACKET_5A_SYSTEM.md` and `packets/PACKET_5B_MAINDEMO.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then 71 lines starting with PASS, then `test_dh: 71 of 71 checks passed`, then 101 lines starting with PASS, then `test_encryption: 101 of 101 checks passed`, then 69 lines starting with PASS, then `test_system: 69 of 69 checks passed`, then 59 lines starting with PASS, then `test_main_demo: 59 of 59 checks passed`. Then the last line `ALL TESTS PASSED`.
4. Type `main_demo` and press Enter. The title `##### MAIN DEMO: THE SECURE NETWORK #####`, the users and a menu with 7 lines appear, and it asks `Your choice: `. Answer the prompts like this (type the text, then press Enter):
   - `1` (send a message), then `Alice`, then `Grace`, then `Hello Grace, the meeting is at 5 pm.` Expected: `The shortest route is Alice - Bob - Dave - Frank - Grace (4 channels).` and `Grace gets: Hello Grace, the meeting is at 5 pm.`. The menu comes back.
   - `4` (break a channel), then `Dave`, then `Frank`. Expected: `The channel Dave - Frank is broken.`.
   - `1`, then `Alice`, then `Grace`, then `Are you there?` Expected: `There is no route from Alice to Grace in the network now, so the message cannot be sent.`.
   - `5` (repair all channels). Expected: `1 channel repaired. The network is whole again.`.
   - `0` (quit). Expected: `Messages sent: 2. Messages that arrived: 1.` and `Goodbye.`
5. Type `main_demo({'1', 'Alice', 'Grace', 'Hi', '0'})` and press Enter. It prints the same kind of text without asking anything (the answers are given in the braces). Expected: `Grace gets: Hi` and `Messages sent: 1. Messages that arrived: 1.`
6. Type `demo_point5` and press Enter. It must still print one `Checks:` block of 7 lines that all end with `yes` (none ends with `NO`).
7. Run `git status --short` in a terminal. It must print nothing.

The planner already ran steps 2 to 5 in GNU Octave 8.4: the 12 test files passed (25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129, 130 of 130, 131 of 131, 71 of 71, 101 of 101, 69 of 69, 59 of 59 checks, `test_main_demo` has 59 checks with scripted answers, no keyboard) and the typed session of owner step 4 was run with scripted answers and gave the texts above. There is no new maths in 5B (only prompts and printing; the keys and the route come from 5A), so no Python cross-check was made. No mutation test was run on the new code.

Paste line for the agent:

`Read packets/PACKET_5B_MAINDEMO.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
