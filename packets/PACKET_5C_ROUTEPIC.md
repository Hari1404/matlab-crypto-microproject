# PACKET 5C: the picture of the route in main_demo

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 5 (the whole system), third and last packet
Goal: add three files to `src/integration/`: `route_picture_options` (the colors and the title of the picture), `draw_route_picture` (draws the network with the route in an axes) and `show_route_picture` (opens a figure window and saves the PNG file `outputs/point5_route.png`). Add the test `test_route_picture`. Change `main_demo` (a new menu option 7 draws the picture of the route of the last message), `test_main_demo` and `run_all_tests`. Update PROGRESS.md and README.md. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `de5219c 5B: main_demo, the demo with typed prompts`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_5C_ROUTEPIC.md` and `packets/MP5C_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_5C_ROUTEPIC.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP5C_files.zip" -DestinationPath "." -Force`
2. Check that these 9 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/integration/draw_route_picture.m`
   - `src/integration/main_demo.m` (this one already existed and is now replaced)
   - `src/integration/route_picture_options.m`
   - `src/integration/show_route_picture.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_main_demo.m` (this one already existed and is now replaced)
   - `tests/test_route_picture.m`
3. Check the SHA-256 hash of all 9 files. All 9 must match exactly:

   | File | SHA-256 |
   | --- | --- |
| `PROGRESS.md` | `f6ff2f2536837b4f69cdbbf26fd8d94491939fd516777ad0b26c71df7164b38c` |
| `README.md` | `9f20e66ce599a684f291252a58d025e81399694fed6363d231bc2f62386008e6` |
| `src/integration/draw_route_picture.m` | `8ed90f021439a66d1c12aeb7b8795cc39e0fafa8b1646b12405c21d6e0a717fa` |
| `src/integration/main_demo.m` | `bbeb17d6b639cba9da6af609d06890643a80b3f07d064af322f8b0028fd22ea6` |
| `src/integration/route_picture_options.m` | `21313869aed177ff4b96b7f75f6436ad3347f89fb0be766b40ba0d69ebfa0652` |
| `src/integration/show_route_picture.m` | `c2ba743350b081ddf6f2bed377f3b7ae3ef9a839ade8603543e7a7c8155d76d7` |
| `tests/run_all_tests.m` | `c636a16dba7add86f2210040d02d1ddca7f00ba3e36daa7c9a3317e63acdcf36` |
| `tests/test_main_demo.m` | `c2af8e76ceb72ab1adbb1a10e58c1558c6da68600df324c4ea8ab50710958283` |
| `tests/test_route_picture.m` | `35844cd5654f9a8b5995c688372b886b390c7739692030f82ad34d4eed884402` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`). Run it exactly as it is written, do not shorten it:

```
python -c "
import hashlib
files = {
 'PROGRESS.md': 'f6ff2f2536837b4f69cdbbf26fd8d94491939fd516777ad0b26c71df7164b38c',
 'README.md': '9f20e66ce599a684f291252a58d025e81399694fed6363d231bc2f62386008e6',
 'src/integration/draw_route_picture.m': '8ed90f021439a66d1c12aeb7b8795cc39e0fafa8b1646b12405c21d6e0a717fa',
 'src/integration/main_demo.m': 'bbeb17d6b639cba9da6af609d06890643a80b3f07d064af322f8b0028fd22ea6',
 'src/integration/route_picture_options.m': '21313869aed177ff4b96b7f75f6436ad3347f89fb0be766b40ba0d69ebfa0652',
 'src/integration/show_route_picture.m': 'c2ba743350b081ddf6f2bed377f3b7ae3ef9a839ade8603543e7a7c8155d76d7',
 'tests/run_all_tests.m': 'c636a16dba7add86f2210040d02d1ddca7f00ba3e36daa7c9a3317e63acdcf36',
 'tests/test_main_demo.m': 'c2af8e76ceb72ab1adbb1a10e58c1558c6da68600df324c4ea8ab50710958283',
 'tests/test_route_picture.m': '35844cd5654f9a8b5995c688372b886b390c7739692030f82ad34d4eed884402',
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
   `git add PROGRESS.md README.md src/integration/draw_route_picture.m src/integration/main_demo.m src/integration/route_picture_options.m src/integration/show_route_picture.m tests/run_all_tests.m tests/test_main_demo.m tests/test_route_picture.m packets/PACKET_5C_ROUTEPIC.md`
5. Run `git status --short`. It must print exactly these 10 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_5C_ROUTEPIC.md
A  src/integration/draw_route_picture.m
M  src/integration/main_demo.m
A  src/integration/route_picture_options.m
A  src/integration/show_route_picture.m
M  tests/run_all_tests.m
M  tests/test_main_demo.m
A  tests/test_route_picture.m
```
6. Commit with exactly this message: `5C: the picture of the route in main_demo`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 9 of 9 match.
2. `git log -1 --oneline` shows the message `5C: the picture of the route in main_demo`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly fourteen lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md`, `packets/PACKET_4A_DH.md`, `packets/PACKET_4B_ENCRYPT.md`, `packets/PACKET_5A_SYSTEM.md`, `packets/PACKET_5B_MAINDEMO.md` and `packets/PACKET_5C_ROUTEPIC.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`. Also paste the output of the hash command of step 3.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then 71 lines starting with PASS, then `test_dh: 71 of 71 checks passed`, then 101 lines starting with PASS, then `test_encryption: 101 of 101 checks passed`, then 69 lines starting with PASS, then `test_system: 69 of 69 checks passed`, then 59 lines starting with PASS, then `test_main_demo: 59 of 59 checks passed`, then 64 lines starting with PASS, then `test_route_picture: 64 of 64 checks passed`. Then the last line `ALL TESTS PASSED`. No figure window may stay open after it.
4. Type `main_demo` and press Enter. The title `##### MAIN DEMO: THE SECURE NETWORK #####`, the users and a menu with 8 lines appear, and it asks `Your choice: `. Answer the prompts like this (type the text, then press Enter):
   - `1` (send a message), then `Alice`, then `Grace`, then `Hello Grace, the meeting is at 5 pm.` Expected: `The shortest route is Alice - Bob - Dave - Frank - Grace (4 channels).` and `Grace gets: Hello Grace, the meeting is at 5 pm.`. The menu comes back.
   - `7` (the picture). Expected: `Picture: Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)` and a line that starts with `The picture is in a figure window and saved as` and ends with `point5_route.png.` A figure window opens with the 6 users and the 6 channels e1 to e6: Alice and Grace are dark green, Bob, Dave and Frank light green, Carol blue, and the 4 channels of the route (e1, e3, e5 and e6) are thick and green.
   - `4` (break a channel), then `Dave`, then `Frank`. Expected: `The channel Dave - Frank is broken.`.
   - `7`. Expected: a line that starts with `There is no route to show` and `Picture: The network now: 5 working channels, 1 broken, 2 groups of users`. The old window is replaced by a new one: the channel e5 (Dave - Frank) is dotted and gray, Alice, Bob, Carol and Dave are blue, Frank and Grace are pale green.
   - `1`, then `Alice`, then `Grace`, then `Are you there?` Expected: `There is no route from Alice to Grace in the network now, so the message cannot be sent.`.
   - `7`. Expected: `Picture: No route from Alice to Grace: they are in different groups of users`. The new window looks the same as before (e5 dotted, two colors).
   - `5` (repair all channels). Expected: `1 channel repaired. The network is whole again.`.
   - `0` (quit). Expected: `Messages sent: 2. Messages that arrived: 1.` and `Goodbye.` The last window stays open. Close it.
5. Type `main_demo({'1', 'Alice', 'Grace', 'Hi', '7', '0'}, 'off')` and press Enter. It prints the same kind of text without asking anything and without opening a window (the answers are given in the braces, the word `off` means no window). Expected: `Grace gets: Hi`, `Picture: Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)`, a line that starts with `The picture is saved as` and ends with `point5_route.png.` and `Messages sent: 1. Messages that arrived: 1.`
6. Open the file `outputs/point5_route.png` in an image viewer. It must show the picture of step 5 with the title `Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)`.
7. Type `demo_point5` and press Enter. It must still print one `Checks:` block of 7 lines that all end with `yes` (none ends with `NO`).
8. Run `git status --short` in a terminal. It must print nothing (the PNG files in `outputs/` are ignored by git).

The planner already ran steps 2 to 5 in GNU Octave 8.4: the 13 test files passed (25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129, 130 of 130, 131 of 131, 71 of 71, 101 of 101, 69 of 69, 59 of 59, 64 of 64 checks; `test_route_picture` has 64 checks with scripted answers, no keyboard, no window and nothing written into `outputs/`), the typed session of owner step 4 was run with scripted answers, once with `off` and once with the windows on, and gave the texts above (with the windows on, exactly one window was left after the three pictures, and it held the last picture). A mutation test was run on the new code: 20 of 21 mutations were caught by `test_route_picture`; the one that was not caught only changes the resolution of the PNG file. There is no new maths in 5C (only colors, titles and drawing; the route comes from 5A and the drawing from Point 2), so no Python cross-check was made.

Paste line for the agent:

`Read packets/PACKET_5C_ROUTEPIC.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
