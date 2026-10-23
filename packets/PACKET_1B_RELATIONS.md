# PACKET 1B: Relations

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 1 (Sets, Relations and Functions)
Goal: add the relations of the system (who can talk to whom, who owns which key), the checks for their properties, a function check, the tests, and an updated demo. Update PROGRESS.md. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `7665e2e 1A: sets, symbols and text conversion`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_1B_RELATIONS.md` and `packets/MP1B_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_1B_RELATIONS.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP1B_files.zip" -DestinationPath "." -Force`
2. Check that these 9 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `src/sets_relations_functions/define_relations.m`
   - `src/sets_relations_functions/demo_point1.m` (this one already existed and is now replaced)
   - `src/sets_relations_functions/function_properties.m`
   - `src/sets_relations_functions/pairs_to_matrix.m`
   - `src/sets_relations_functions/relation_properties.m`
   - `src/sets_relations_functions/show_relations.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_relations.m`
3. Check the SHA-256 hash of all 9 files. All 9 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `f1d0f7b9dbc0a22cf22e6af17d11a42098d711ecfc756978b293718b20d7b375` |
   | `src/sets_relations_functions/define_relations.m` | `8026fdf9c290a02f887e9279c336c8d899573a1eed51857df04e1fe317a1b983` |
   | `src/sets_relations_functions/demo_point1.m` | `e7e6688b6b0441dcde6f609378d6323856f60395b8cc503d7276be163624b9fc` |
   | `src/sets_relations_functions/function_properties.m` | `6555888ae47c92d7c2048caa9ad789c7c9a0d7e4b9dc112169381f3058ed4469` |
   | `src/sets_relations_functions/pairs_to_matrix.m` | `1fa45b5db7b717a58883673e3f29686179e5ee0d28ee51a8b94e7f2004f9b64c` |
   | `src/sets_relations_functions/relation_properties.m` | `d98086af64298bf03d1664234a77d37941df743c66f775e14c2339ea9399b4ce` |
   | `src/sets_relations_functions/show_relations.m` | `fced367076794f8600f5d14e90890f51f5ac37d003ddfcbc6da2c58dbf71303f` |
   | `tests/run_all_tests.m` | `33eb513bf334ad847333e0f27da65ce87329a55ebf58f00ebefe3c3716f68ff6` |
   | `tests/test_relations.m` | `e21d1c60a7a621aeb2493ddbccfc91c063c6acb6628158d5ba63d12ffd793e96` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': 'f1d0f7b9dbc0a22cf22e6af17d11a42098d711ecfc756978b293718b20d7b375',
 'src/sets_relations_functions/define_relations.m': '8026fdf9c290a02f887e9279c336c8d899573a1eed51857df04e1fe317a1b983',
 'src/sets_relations_functions/demo_point1.m': 'e7e6688b6b0441dcde6f609378d6323856f60395b8cc503d7276be163624b9fc',
 'src/sets_relations_functions/function_properties.m': '6555888ae47c92d7c2048caa9ad789c7c9a0d7e4b9dc112169381f3058ed4469',
 'src/sets_relations_functions/pairs_to_matrix.m': '1fa45b5db7b717a58883673e3f29686179e5ee0d28ee51a8b94e7f2004f9b64c',
 'src/sets_relations_functions/relation_properties.m': 'd98086af64298bf03d1664234a77d37941df743c66f775e14c2339ea9399b4ce',
 'src/sets_relations_functions/show_relations.m': 'fced367076794f8600f5d14e90890f51f5ac37d003ddfcbc6da2c58dbf71303f',
 'tests/run_all_tests.m': '33eb513bf334ad847333e0f27da65ce87329a55ebf58f00ebefe3c3716f68ff6',
 'tests/test_relations.m': 'e21d1c60a7a621aeb2493ddbccfc91c063c6acb6628158d5ba63d12ffd793e96',
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
   `git add PROGRESS.md src/sets_relations_functions/define_relations.m src/sets_relations_functions/demo_point1.m src/sets_relations_functions/function_properties.m src/sets_relations_functions/pairs_to_matrix.m src/sets_relations_functions/relation_properties.m src/sets_relations_functions/show_relations.m tests/run_all_tests.m tests/test_relations.m packets/PACKET_1B_RELATIONS.md`
5. Run `git status --short`. It must print exactly these 10 lines and nothing else:
```
M  PROGRESS.md
A  packets/PACKET_1B_RELATIONS.md
A  src/sets_relations_functions/define_relations.m
M  src/sets_relations_functions/demo_point1.m
A  src/sets_relations_functions/function_properties.m
A  src/sets_relations_functions/pairs_to_matrix.m
A  src/sets_relations_functions/relation_properties.m
A  src/sets_relations_functions/show_relations.m
M  tests/run_all_tests.m
A  tests/test_relations.m
```
6. Commit with exactly this message: `1B: relations and function check`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 9 of 9 match.
2. `git log -1 --oneline` shows the message `1B: relations and function check`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly three lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md` and `packets/PACKET_1B_RELATIONS.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point1` and press Enter. Expected: the sets and the `Hello Bob` conversion as before, then RELATION 1 (6 channels, 12 ordered pairs, a 6 by 6 matrix, and the properties: reflexive no, symmetric yes, antisymmetric no, transitive no with the example `Dave can talk to Bob and Bob can talk to Alice, but Dave cannot talk to Alice.`, equivalence no), then RELATION 2 (6 pairs from Alice 6 to Grace 58, function yes, one-to-one yes, onto no with `6 of 96 keys are owned`).

The planner already ran steps 2 to 4 in GNU Octave 8.4: 25 of 25 and 51 of 51 passed.

Paste line for the agent:

`Read packets/PACKET_1B_RELATIONS.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
