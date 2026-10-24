# PACKET 3A: Modular arithmetic tools (fast powers, gcd, inverse) and demo_point3

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 3 (Group Theory and Modular Arithmetic core), first packet
Goal: add the modular arithmetic tools in `src/group_theory/`: fast modular exponentiation (`mod_pow`), Euclid's gcd (`euclid_gcd`), the extended gcd (`ext_gcd`) and the modular inverse (`mod_inverse`), with the small helper `is_whole_number`, the printout `show_modular`, the demo `demo_point3` and the test `test_modular`. Update PROGRESS.md, README.md and run_all_tests. One commit, then push. Point 3 is not finished yet.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `5fce09c 2C: pictures of the network and the finished demo_point2`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_3A_MODULAR.md` and `packets/MP3A_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_3A_MODULAR.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP3A_files.zip" -DestinationPath "." -Force`
2. Check that these 11 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/group_theory/demo_point3.m`
   - `src/group_theory/euclid_gcd.m`
   - `src/group_theory/ext_gcd.m`
   - `src/group_theory/is_whole_number.m`
   - `src/group_theory/mod_inverse.m`
   - `src/group_theory/mod_pow.m`
   - `src/group_theory/show_modular.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_modular.m`
3. Check the SHA-256 hash of all 11 files. All 11 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `7a09addb9c8e989564584daf4e1305702e08967bc898133bc82dcf6c39dd2fbf` |
   | `README.md` | `f28905edd73660ec3ffa96213e37f10548468735cf1218f7bf43db9306b6ae0b` |
   | `src/group_theory/demo_point3.m` | `821185c30c369297e40c28819843b07c93fdd19508fc07f3c8a5a062e1e1a7b2` |
   | `src/group_theory/euclid_gcd.m` | `1ea7d2d9ed58a338a6d5fa4e1b5cf5c7304e33cf596c4aa64ac0d8a79293c6bc` |
   | `src/group_theory/ext_gcd.m` | `61fcdefaaa73a4af444d4676c6e44159a5c0d8bb2abf66cb0cf7d7f638d9b291` |
   | `src/group_theory/is_whole_number.m` | `6abae4f2478a175112ce931c412f74435cdebf9c71996db10e3068c2a3f6fb66` |
   | `src/group_theory/mod_inverse.m` | `e8664f6edbed7712c1f35f12042bdd21dd2113d06145da1ca912a60b2732f417` |
   | `src/group_theory/mod_pow.m` | `12e7a832424d420ba0951243956ba236a372c02581336633161a444ed4daa878` |
   | `src/group_theory/show_modular.m` | `19725238b86d6267e978529f9047fec15a5b4dcf749a20e2a04cfd79e3755b7d` |
   | `tests/run_all_tests.m` | `dba97ad51311942b1a964c3aa329afa9bcff8932ae586addcb773c0b46572aea` |
   | `tests/test_modular.m` | `e9e2af908eec16b3414ec0edeeac2fdfe7e26ebd894027c1e4116554b2590712` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '7a09addb9c8e989564584daf4e1305702e08967bc898133bc82dcf6c39dd2fbf',
 'README.md': 'f28905edd73660ec3ffa96213e37f10548468735cf1218f7bf43db9306b6ae0b',
 'src/group_theory/demo_point3.m': '821185c30c369297e40c28819843b07c93fdd19508fc07f3c8a5a062e1e1a7b2',
 'src/group_theory/euclid_gcd.m': '1ea7d2d9ed58a338a6d5fa4e1b5cf5c7304e33cf596c4aa64ac0d8a79293c6bc',
 'src/group_theory/ext_gcd.m': '61fcdefaaa73a4af444d4676c6e44159a5c0d8bb2abf66cb0cf7d7f638d9b291',
 'src/group_theory/is_whole_number.m': '6abae4f2478a175112ce931c412f74435cdebf9c71996db10e3068c2a3f6fb66',
 'src/group_theory/mod_inverse.m': 'e8664f6edbed7712c1f35f12042bdd21dd2113d06145da1ca912a60b2732f417',
 'src/group_theory/mod_pow.m': '12e7a832424d420ba0951243956ba236a372c02581336633161a444ed4daa878',
 'src/group_theory/show_modular.m': '19725238b86d6267e978529f9047fec15a5b4dcf749a20e2a04cfd79e3755b7d',
 'tests/run_all_tests.m': 'dba97ad51311942b1a964c3aa329afa9bcff8932ae586addcb773c0b46572aea',
 'tests/test_modular.m': 'e9e2af908eec16b3414ec0edeeac2fdfe7e26ebd894027c1e4116554b2590712',
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
   `git add PROGRESS.md README.md src/group_theory/demo_point3.m src/group_theory/euclid_gcd.m src/group_theory/ext_gcd.m src/group_theory/is_whole_number.m src/group_theory/mod_inverse.m src/group_theory/mod_pow.m src/group_theory/show_modular.m tests/run_all_tests.m tests/test_modular.m packets/PACKET_3A_MODULAR.md`
5. Run `git status --short`. It must print exactly these 12 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_3A_MODULAR.md
A  src/group_theory/demo_point3.m
A  src/group_theory/euclid_gcd.m
A  src/group_theory/ext_gcd.m
A  src/group_theory/is_whole_number.m
A  src/group_theory/mod_inverse.m
A  src/group_theory/mod_pow.m
A  src/group_theory/show_modular.m
M  tests/run_all_tests.m
A  tests/test_modular.m
```
6. Commit with exactly this message: `3A: fast modular powers, gcd and modular inverse`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 11 of 11 match.
2. `git log -1 --oneline` shows the message `3A: fast modular powers, gcd and modular inverse`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly eight lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md` and `packets/PACKET_3A_MODULAR.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point3` and press Enter. Expected: the title `##### POINT 3 DEMO: GROUP THEORY AND MODULAR ARITHMETIC #####` and then `=== MODULAR ARITHMETIC TOOLS ===` with three parts:
   1. Fast modular exponentiation: the exponent 13 in binary `1101`, a table with 4 rows (bits 1, 1, 0, 1 and last column 5, 28, 8, 29), the line `So 5^13 mod 97 = 29.` that ends with `yes`, and a line saying 5^96 mod 97 = 1 with 7 squaring steps and 2 multiplication steps (the plain way needs 95 multiplications).
   2. Euclid's algorithm: `gcd(85, 97)` with 4 division lines ending in `So gcd(85, 97) = 1.`, and `gcd(84, 36)` with 2 division lines ending in `So gcd(84, 36) = 12.`
   3. The extended algorithm and the inverse: the line `For a = 85 and b = 97: 85 * (8) + 97 * (-7) = 1 = gcd(85, 97).`, the inverse of 85 is 8 (`Check: 85 * 8 = 680 = 7 * 97 + 1, ...`), and the line `An inverse exists only when gcd = 1. Example: 6 has no inverse modulo 9, because gcd(6, 9) = 3 and not 1.`
   and a last block `Checks:` with 5 lines that all end with `yes` (none ends with `NO`).
5. Type `disp([mod_pow(5, 13, 97), mod_inverse(85, 97), key_inverse(85)])` and press Enter. Expected: the three numbers 29, 8 and 8.
6. Type `demo_point1` and then `demo_point2` and press Enter after each. Both must still print everything as before (`demo_point2` opens its 5 figure windows again).
7. Run `git status --short` in a terminal. It must print nothing.

The planner already ran steps 2 to 5 in GNU Octave 8.4: 25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129 and 130 of 130 checks passed, and `demo_point3` printed 5 check lines that all say yes. The new functions were also compared with a separate Python program on 4500 random cases (numbers up to 2^53, moduli up to 2^50) and gave the same answers every time, including the cases that have no inverse. A test of the tests: 36 small bugs were planted one by one in the new files, and the tests caught 33 of them. The 3 that were not caught change no result (2 are the same function written another way, 1 is a self-check line in the demo that is also tested directly in test_modular).

Paste line for the agent:

`Read packets/PACKET_3A_MODULAR.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
