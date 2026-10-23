# PACKET 1A: Sets and text conversion

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 1 (Sets, Relations and Functions)
Goal: add the sets of the system (users, plaintext, ciphertext, keys), the conversion between text and symbols, a demo, and the first test. Update PROGRESS.md. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `297cb32 0A: project start (rules, progress, README, folders, setup_project)`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_1A_SETS.md` and `packets/MP1A_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_1A_SETS.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP1A_files.zip" -DestinationPath "." -Force`
2. Check that these 9 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `src/sets_relations_functions/define_sets.m`
   - `src/sets_relations_functions/demo_point1.m`
   - `src/sets_relations_functions/show_sets.m`
   - `src/sets_relations_functions/symbols_to_text.m`
   - `src/sets_relations_functions/text_to_symbols.m`
   - `tests/run_all_tests.m`
   - `tests/summarize_checks.m`
   - `tests/test_sets.m`
3. Check the SHA-256 hash of all 9 files. All 9 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `02f5d33fd125def5332db59266c713cf3b0ffef237797d1a64a209b1ccbdfd17` |
   | `src/sets_relations_functions/define_sets.m` | `2d5aeb90ba25528255e88eb631c6ac377fdf95e476af40a880a7876ca0ed98ae` |
   | `src/sets_relations_functions/demo_point1.m` | `5e0bc7315c4f1cbd27427824773e3109cd3dc943d745b9f7d27f9062e8500517` |
   | `src/sets_relations_functions/show_sets.m` | `c5da618348674d3066fd676c634bc6f94942bce66b08cbf3da80fa1501cae404` |
   | `src/sets_relations_functions/symbols_to_text.m` | `e4907fdf3e39416848c49cbc77251fa03cc16827044e69adf802c1334d935920` |
   | `src/sets_relations_functions/text_to_symbols.m` | `62ec517fe40c807aa2efa3c54e6211f45c04e3704cce0a58bf24558e029a26df` |
   | `tests/run_all_tests.m` | `ebd83311a4a8fc523b51c266c704f8e9753fe3c0cb1715e106a86214b59aad17` |
   | `tests/summarize_checks.m` | `040500c30d4a88a0da8cda4227a540fb940dd7fdc4510c8a8b17516c62824bfb` |
   | `tests/test_sets.m` | `c256e2d9e945c0b26f7c63c9cd6b9b2ad147b0bcddb1048ffae8a32a977f0d4d` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '02f5d33fd125def5332db59266c713cf3b0ffef237797d1a64a209b1ccbdfd17',
 'src/sets_relations_functions/define_sets.m': '2d5aeb90ba25528255e88eb631c6ac377fdf95e476af40a880a7876ca0ed98ae',
 'src/sets_relations_functions/demo_point1.m': '5e0bc7315c4f1cbd27427824773e3109cd3dc943d745b9f7d27f9062e8500517',
 'src/sets_relations_functions/show_sets.m': 'c5da618348674d3066fd676c634bc6f94942bce66b08cbf3da80fa1501cae404',
 'src/sets_relations_functions/symbols_to_text.m': 'e4907fdf3e39416848c49cbc77251fa03cc16827044e69adf802c1334d935920',
 'src/sets_relations_functions/text_to_symbols.m': '62ec517fe40c807aa2efa3c54e6211f45c04e3704cce0a58bf24558e029a26df',
 'tests/run_all_tests.m': 'ebd83311a4a8fc523b51c266c704f8e9753fe3c0cb1715e106a86214b59aad17',
 'tests/summarize_checks.m': '040500c30d4a88a0da8cda4227a540fb940dd7fdc4510c8a8b17516c62824bfb',
 'tests/test_sets.m': 'c256e2d9e945c0b26f7c63c9cd6b9b2ad147b0bcddb1048ffae8a32a977f0d4d',
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
   `git add PROGRESS.md src/sets_relations_functions/define_sets.m src/sets_relations_functions/demo_point1.m src/sets_relations_functions/show_sets.m src/sets_relations_functions/symbols_to_text.m src/sets_relations_functions/text_to_symbols.m tests/run_all_tests.m tests/summarize_checks.m tests/test_sets.m packets/PACKET_1A_SETS.md`
5. Run `git status --short`. It must print exactly these 10 lines and nothing else:
```
M  PROGRESS.md
A  packets/PACKET_1A_SETS.md
A  src/sets_relations_functions/define_sets.m
A  src/sets_relations_functions/demo_point1.m
A  src/sets_relations_functions/show_sets.m
A  src/sets_relations_functions/symbols_to_text.m
A  src/sets_relations_functions/text_to_symbols.m
A  tests/run_all_tests.m
A  tests/summarize_checks.m
A  tests/test_sets.m
```
6. Commit with exactly this message: `1A: sets, symbols and text conversion`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 9 of 9 match.
2. `git log -1 --oneline` shows the message `1A: sets, symbols and text conversion`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly two lines: `packets/PACKET_0A_START.md` and `packets/PACKET_1A_SETS.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point1` and press Enter. Expected: the sets are printed (6 users, P with 95 symbols, C with 96 values, K with 96 keys), then the message `Hello Bob` becomes `[41 70 77 77 80 1 35 80 67]` and comes back as `Hello Bob`, with `Same as before?  : yes`.

The planner already ran steps 2 to 4 in GNU Octave 8.4: 25 of 25 passed.

Paste line for the agent:

`Read packets/PACKET_1A_SETS.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
