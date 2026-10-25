# PACKET 3B: The group Z_p* (primes, group rules, orders, generators, cyclic subgroups) and the finished demo_point3

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 3 (Group Theory and Modular Arithmetic core), second and last packet
Goal: add the group Z_p* (the numbers 1 to p-1 with multiplication mod p) in `src/group_theory/`: `is_prime_number`, `prime_factors`, `group_table`, `check_group` (the group rules), `element_order`, `is_generator`, `find_generators`, `cyclic_subgroup`, and the printouts `show_group` and `show_cyclic`. `demo_point3` now shows the modular arithmetic tools, the group rules and the orders, generators and cyclic subgroups. Add the test `test_group`. Update PROGRESS.md, README.md and run_all_tests. One commit, then push. This finishes Point 3.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `55864e7 3A: fast modular powers, gcd and modular inverse`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_3B_GROUP.md` and `packets/MP3B_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_3B_GROUP.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP3B_files.zip" -DestinationPath "." -Force`
2. Check that these 16 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/group_theory/check_group.m`
   - `src/group_theory/cyclic_subgroup.m`
   - `src/group_theory/demo_point3.m` (this one already existed and is now replaced)
   - `src/group_theory/element_order.m`
   - `src/group_theory/find_generators.m`
   - `src/group_theory/group_table.m`
   - `src/group_theory/is_generator.m`
   - `src/group_theory/is_prime_number.m`
   - `src/group_theory/prime_factors.m`
   - `src/group_theory/show_cyclic.m`
   - `src/group_theory/show_group.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_group.m`
   - `tests/test_modular.m` (this one already existed and is now replaced)
3. Check the SHA-256 hash of all 16 files. All 16 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `4cfa2b4b7be7d5f4662bf41f3673bff4bd0a0674cb1579447c54363953cee928` |
   | `README.md` | `8cf4c428d29cb343d5c8ef8308129fda67f933c38e134b51acac1a1dbca798a0` |
   | `src/group_theory/check_group.m` | `b4d56aa2fdf0ee31860df2326cef58d953a9484de2587e7b591def92d6acf201` |
   | `src/group_theory/cyclic_subgroup.m` | `bb03c38d1001edb5880e704e462876e00c984295214ca7239d52468ac777ecc7` |
   | `src/group_theory/demo_point3.m` | `eb2bdd496b7bab68a9b1cf49eed60c3f919cccf19bf174435ceed5c661eadff5` |
   | `src/group_theory/element_order.m` | `a624fe9f948c2b815623e83058894413808e9cdc3a86dfa5cf8c8f00aa467847` |
   | `src/group_theory/find_generators.m` | `da00960408bebcd4b9fd50ec0017ab26ea312ba3d93fb64126b48a679cf024c1` |
   | `src/group_theory/group_table.m` | `ecbc850c43eabe17790058b6d49d92bbc1e16baa9db94c50c384573654660d95` |
   | `src/group_theory/is_generator.m` | `f1ac2a8a75069f86ee11a83ef0bf6c4e21d1f200276f533ed8f841cfe8c64e30` |
   | `src/group_theory/is_prime_number.m` | `d1c3a429606b5a8de249b126a87d1d2567f44544968e8b81507d88793d2b9383` |
   | `src/group_theory/prime_factors.m` | `d4f9d74e8d97cee03ffebd0a52770d2071408c497e7c5a6ce4dbd9bb73c3df68` |
   | `src/group_theory/show_cyclic.m` | `896bd48f4fbaac551a52bcec988fe790811cb6d59cd644620b45100abe0913c4` |
   | `src/group_theory/show_group.m` | `9caca6fb1d24526849368aa64105521aae4fc26d480a4c358240f6ebe1d07353` |
   | `tests/run_all_tests.m` | `0f0ab1b103a9cc34f4365fbf8779aa19ce92f03d3f676758d2f18d265092eebb` |
   | `tests/test_group.m` | `39c0d515aa847b69ad13cea9deaa9fe653458a077d7905c55d05e6cde2b91652` |
   | `tests/test_modular.m` | `a73e4f926fe1ba0ab83fdb2082d91457598a53440b1cf458c2097a68877d3d27` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '4cfa2b4b7be7d5f4662bf41f3673bff4bd0a0674cb1579447c54363953cee928',
 'README.md': '8cf4c428d29cb343d5c8ef8308129fda67f933c38e134b51acac1a1dbca798a0',
 'src/group_theory/check_group.m': 'b4d56aa2fdf0ee31860df2326cef58d953a9484de2587e7b591def92d6acf201',
 'src/group_theory/cyclic_subgroup.m': 'bb03c38d1001edb5880e704e462876e00c984295214ca7239d52468ac777ecc7',
 'src/group_theory/demo_point3.m': 'eb2bdd496b7bab68a9b1cf49eed60c3f919cccf19bf174435ceed5c661eadff5',
 'src/group_theory/element_order.m': 'a624fe9f948c2b815623e83058894413808e9cdc3a86dfa5cf8c8f00aa467847',
 'src/group_theory/find_generators.m': 'da00960408bebcd4b9fd50ec0017ab26ea312ba3d93fb64126b48a679cf024c1',
 'src/group_theory/group_table.m': 'ecbc850c43eabe17790058b6d49d92bbc1e16baa9db94c50c384573654660d95',
 'src/group_theory/is_generator.m': 'f1ac2a8a75069f86ee11a83ef0bf6c4e21d1f200276f533ed8f841cfe8c64e30',
 'src/group_theory/is_prime_number.m': 'd1c3a429606b5a8de249b126a87d1d2567f44544968e8b81507d88793d2b9383',
 'src/group_theory/prime_factors.m': 'd4f9d74e8d97cee03ffebd0a52770d2071408c497e7c5a6ce4dbd9bb73c3df68',
 'src/group_theory/show_cyclic.m': '896bd48f4fbaac551a52bcec988fe790811cb6d59cd644620b45100abe0913c4',
 'src/group_theory/show_group.m': '9caca6fb1d24526849368aa64105521aae4fc26d480a4c358240f6ebe1d07353',
 'tests/run_all_tests.m': '0f0ab1b103a9cc34f4365fbf8779aa19ce92f03d3f676758d2f18d265092eebb',
 'tests/test_group.m': '39c0d515aa847b69ad13cea9deaa9fe653458a077d7905c55d05e6cde2b91652',
 'tests/test_modular.m': 'a73e4f926fe1ba0ab83fdb2082d91457598a53440b1cf458c2097a68877d3d27',
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
   `git add PROGRESS.md README.md src/group_theory/check_group.m src/group_theory/cyclic_subgroup.m src/group_theory/demo_point3.m src/group_theory/element_order.m src/group_theory/find_generators.m src/group_theory/group_table.m src/group_theory/is_generator.m src/group_theory/is_prime_number.m src/group_theory/prime_factors.m src/group_theory/show_cyclic.m src/group_theory/show_group.m tests/run_all_tests.m tests/test_group.m tests/test_modular.m packets/PACKET_3B_GROUP.md`
5. Run `git status --short`. It must print exactly these 17 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_3B_GROUP.md
A  src/group_theory/check_group.m
A  src/group_theory/cyclic_subgroup.m
M  src/group_theory/demo_point3.m
A  src/group_theory/element_order.m
A  src/group_theory/find_generators.m
A  src/group_theory/group_table.m
A  src/group_theory/is_generator.m
A  src/group_theory/is_prime_number.m
A  src/group_theory/prime_factors.m
A  src/group_theory/show_cyclic.m
A  src/group_theory/show_group.m
M  tests/run_all_tests.m
A  tests/test_group.m
M  tests/test_modular.m
```
6. Commit with exactly this message: `3B: the group Z_p*, orders, generators and cyclic subgroups`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 16 of 16 match.
2. `git log -1 --oneline` shows the message `3B: the group Z_p*, orders, generators and cyclic subgroups`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly nine lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md` and `packets/PACKET_3B_GROUP.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point3` and press Enter (it may take a few seconds). Expected: the same text as in 3A (the title, `=== MODULAR ARITHMETIC TOOLS ===` and its `Checks:` block with 5 lines ending with `yes`), and then two new parts:
   1. `=== THE GROUP Z_p* (THE NUMBERS 1 TO p-1 WITH MULTIPLICATION MOD p) ===`: the line `Here p = 97. Is p prime? yes. The group has p - 1 = 96 elements, and 96 = 2^5 * 3.`; the 6 x 6 multiplication table mod 7 (row 2 is `2  4  6  1  3  5`); the inverses `1 -> 1, 2 -> 4, 3 -> 5, 4 -> 2, 5 -> 3, 6 -> 6`; the line about the numbers 1 to 5 mod 6 that ends with `Closed? NO. That is why p must be prime.`; the 5 group rules of Z_97* (closure, identity, inverses, associativity with `884736 triples`, commutativity) that all end with `yes`; the line `So Z_97* is an abelian (commutative) group with 96 elements.`; and a `Checks:` block with 6 lines that end with `yes`.
   2. `=== ORDERS, GENERATORS AND CYCLIC SUBGROUPS OF Z_p* ===`: the orders of 5 (96), 2 (48), 96 (2) and 1 (1); a table of orders (12 rows from order 1 to order 96; order 3 has 2 numbers, the smallest is 35; order 96 has 32 numbers, the smallest is 5); `There are 32 generators. The smallest is 5.` followed by the list; the powers of 5 (`1 5 25 28 43 21 8 40 6 30 53 71, ...`); `So Z_97* is a cyclic group: it has a generator.`; 4 small subgroups (of 2, 3, 4 and 6 elements); and a `Checks:` block with 7 lines that end with `yes`.
   In total the demo has 18 check lines in 3 `Checks:` blocks, all ending with `yes`, none ending with `NO`.
5. Type `disp([element_order(5, 97), is_generator(5, 97), numel(find_generators(97))])` and press Enter. Expected: the three numbers 96, 1 and 32 (5 has order 96, 5 is a generator, and Z_97* has 32 generators).
6. Type `demo_point1` and then `demo_point2` and press Enter after each. Both must still print everything as before (`demo_point2` opens its 5 figure windows again).
7. Run `git status --short` in a terminal. It must print nothing.

The planner already ran steps 2 to 5 in GNU Octave 8.4: 25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129, 130 of 130 and 131 of 131 checks passed, and `demo_point3` printed 18 check lines that all say yes. The new functions were also compared with a separate Python program on 9067 cases (every number of every prime up to 300, random primes up to 2^26, and the primality and prime factors of 550 numbers up to 2^32) and gave the same answers every time. A test of the tests: 49 small bugs were planted one by one in the new files, and the tests caught 47 of them. The 2 that were not caught change no result (one is a size limit that mod_pow enforces anyway, the other prints the symmetric table of Z_7* transposed, which looks the same).

Paste line for the agent:

`Read packets/PACKET_3B_GROUP.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
