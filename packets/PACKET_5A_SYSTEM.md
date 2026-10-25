# PACKET 5A: the secure network, keys on the channels and messages along the paths

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 5 (the whole system), first packet
Goal: add the folder content of `src/integration/`: `define_system` (the network of Point 2 with the Diffie-Hellman key of every channel), `check_system`, `channel_key`, `route_message` (a message along the shortest path, hop by hop, every hop with the key of its channel), the printout `show_system` and the demo `demo_point5`. Add the test `test_system`. Change `run_all_tests`. Update PROGRESS.md and README.md. One commit, then push. Do not touch `src/integration/.gitkeep`.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `2ded38a 4B: encryption with the shared key and the eavesdropper`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_5A_SYSTEM.md` and `packets/MP5A_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_5A_SYSTEM.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP5A_files.zip" -DestinationPath "." -Force`
2. Check that these 10 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/integration/channel_key.m`
   - `src/integration/check_system.m`
   - `src/integration/define_system.m`
   - `src/integration/demo_point5.m`
   - `src/integration/route_message.m`
   - `src/integration/show_system.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_system.m`
3. Check the SHA-256 hash of all 10 files. All 10 must match exactly:

   | File | SHA-256 |
   | --- | --- |
| `PROGRESS.md` | `a3fb45ea94ac04cced2fad67153e11c49f0ec86784113b3f7b73da7dde8960e9` |
| `README.md` | `7ae11a27f5ec20ca15148eeb51701b4d87f9264f2a68dd3872b30f280642304b` |
| `src/integration/channel_key.m` | `5b4d7d3ac8a59f41d958f33851e6acc83ef8d718cf9868dde12ac3c6754834f3` |
| `src/integration/check_system.m` | `e58f537b42e930c22efb632248044cb8e1f55175ed38da6664fb50c141e68012` |
| `src/integration/define_system.m` | `bf413540093f9efedc9aa0caf5fc70d477da92026fa48c9a835e1ba5e74c02c3` |
| `src/integration/demo_point5.m` | `29c129c2cd67ed59511f6bbca2363b7d48dd369765ee6e75e17f27d7b5b4c38e` |
| `src/integration/route_message.m` | `5e556a330298ab9c125668f295303d79729071ebe9eb841f69021c5cb70a8403` |
| `src/integration/show_system.m` | `52b0243e4e7a04f62806719e0d387bd5523a14006afc40fc7896ca4fd07f145f` |
| `tests/run_all_tests.m` | `0855311b2a243ef5d5b8426896bb463308e0b72ae0c879ae6a6c122a03d7da33` |
| `tests/test_system.m` | `318df7205ce76b2a3d8a0af940470cc897b73307a58e96db8c31ff419e199d97` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': 'a3fb45ea94ac04cced2fad67153e11c49f0ec86784113b3f7b73da7dde8960e9',
 'README.md': '7ae11a27f5ec20ca15148eeb51701b4d87f9264f2a68dd3872b30f280642304b',
 'src/integration/channel_key.m': '5b4d7d3ac8a59f41d958f33851e6acc83ef8d718cf9868dde12ac3c6754834f3',
 'src/integration/check_system.m': 'e58f537b42e930c22efb632248044cb8e1f55175ed38da6664fb50c141e68012',
 'src/integration/define_system.m': 'bf413540093f9efedc9aa0caf5fc70d477da92026fa48c9a835e1ba5e74c02c3',
 'src/integration/demo_point5.m': '29c129c2cd67ed59511f6bbca2363b7d48dd369765ee6e75e17f27d7b5b4c38e',
 'src/integration/route_message.m': '5e556a330298ab9c125668f295303d79729071ebe9eb841f69021c5cb70a8403',
 'src/integration/show_system.m': '52b0243e4e7a04f62806719e0d387bd5523a14006afc40fc7896ca4fd07f145f',
 'tests/run_all_tests.m': '0855311b2a243ef5d5b8426896bb463308e0b72ae0c879ae6a6c122a03d7da33',
 'tests/test_system.m': '318df7205ce76b2a3d8a0af940470cc897b73307a58e96db8c31ff419e199d97',
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
   `git add PROGRESS.md README.md src/integration/channel_key.m src/integration/check_system.m src/integration/define_system.m src/integration/demo_point5.m src/integration/route_message.m src/integration/show_system.m tests/run_all_tests.m tests/test_system.m packets/PACKET_5A_SYSTEM.md`
5. Run `git status --short`. It must print exactly these 11 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_5A_SYSTEM.md
A  src/integration/channel_key.m
A  src/integration/check_system.m
A  src/integration/define_system.m
A  src/integration/demo_point5.m
A  src/integration/route_message.m
A  src/integration/show_system.m
M  tests/run_all_tests.m
A  tests/test_system.m
```
6. Commit with exactly this message: `5A: the secure network, keys on the channels and messages along the paths`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 10 of 10 match.
2. `git log -1 --oneline` shows the message `5A: the secure network, keys on the channels and messages along the paths`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly twelve lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md`, `packets/PACKET_4A_DH.md`, `packets/PACKET_4B_ENCRYPT.md` and `packets/PACKET_5A_SYSTEM.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then 71 lines starting with PASS, then `test_dh: 71 of 71 checks passed`, then 101 lines starting with PASS, then `test_encryption: 101 of 101 checks passed`, then 69 lines starting with PASS, then `test_system: 69 of 69 checks passed`. Then the last line `ALL TESTS PASSED`.
4. Type `demo_point5` and press Enter. Expected: the title `##### POINT 5 DEMO: THE SECURE NETWORK #####` and then the part `=== THE SECURE NETWORK ===` with 5 numbered parts. `Bob and Carol have no channel` is the first pair without a channel. Part 3 has `The shortest route is Alice - Bob - Dave - Frank - Grace (4 channels).`, `The users who can read the message: Alice, Bob, Dave, Frank, Grace.` and `Carol is not on the route and cannot read it.`. Part 5 has `The channel Dave - Frank is removed` and `Messages that still arrive: 14 of 30.`. At the end one `Checks:` block of 7 lines that all end with `yes` (none ends with `NO`).
5. Type `Y = define_system(); R = route_message('Hello', 1, 6, Y); disp(R.keys); disp(R.received)` and press Enter. Expected: the four numbers 85, 42, 32 and 72 and then `Hello`.
6. Type `demo_point1`, then `demo_point2`, then `demo_point3`, then `demo_point4`, and press Enter after each. All four must still print everything as before (`demo_point2` opens its 5 figure windows again, `demo_point3` has 3 `Checks:` blocks and `demo_point4` has 3 `Checks:` blocks, all lines end with `yes`).
7. Run `git status --short` in a terminal. It must print nothing.

The planner already ran steps 2 to 5 in GNU Octave 8.4: the 11 test files passed (25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129, 130 of 130, 131 of 131, 71 of 71, 101 of 101, 69 of 69 checks) and `demo_point5` printed 7 check lines that all say yes. `route_message` was also compared with a separate Python program on 100 cases (primes from 97 to 293, the secret numbers of the 6 users, random generators, texts, senders and receivers, with and without the channel Dave - Frank) and gave the same keys and ciphertext numbers on every hop every time. No mutation test was run on the new code.

Paste line for the agent:

`Read packets/PACKET_5A_SYSTEM.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
