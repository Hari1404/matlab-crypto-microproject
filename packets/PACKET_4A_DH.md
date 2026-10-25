# PACKET 4A: Diffie-Hellman key exchange and demo_point4

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 4 (Diffie-Hellman and encryption), first packet
Goal: add the Diffie-Hellman key exchange in `src/diffie_hellman/`: `check_dh_setup`, `dh_public_value`, `dh_shared_key`, `dh_exchange`, `define_secrets` (the secret numbers of the 6 users), `dh_key_table`, the printout `show_dh` and the demo `demo_point4`. Add the test `test_dh`. Update PROGRESS.md, README.md and run_all_tests. One commit, then push. Point 4 is not finished yet (the encryption with the shared key comes in the next packet).

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `6d46ae3 3B: the group Z_p*, orders, generators and cyclic subgroups`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_4A_DH.md` and `packets/MP4A_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_4A_DH.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP4A_files.zip" -DestinationPath "." -Force`
2. Check that these 12 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/diffie_hellman/check_dh_setup.m`
   - `src/diffie_hellman/define_secrets.m`
   - `src/diffie_hellman/demo_point4.m`
   - `src/diffie_hellman/dh_exchange.m`
   - `src/diffie_hellman/dh_key_table.m`
   - `src/diffie_hellman/dh_public_value.m`
   - `src/diffie_hellman/dh_shared_key.m`
   - `src/diffie_hellman/show_dh.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_dh.m`
3. Check the SHA-256 hash of all 12 files. All 12 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `d6987b65d7be298def0c0999ca466e4ef93318a81c1986b499768ac6c82c2338` |
   | `README.md` | `b36f22fd8aef30fd50cd3378962aee6ab4e56f7bc718bf43e2dc08910bb3010b` |
   | `src/diffie_hellman/check_dh_setup.m` | `7ca83dcd723eb25ea86bf2ca82c28413113fd15e0b5e5c7e75534b385909f95f` |
   | `src/diffie_hellman/define_secrets.m` | `2421591175d237bd78ea1a6e8d3d60f9497372a8595d73007fc0eb002334fb68` |
   | `src/diffie_hellman/demo_point4.m` | `3bff3b46edc6b7e35cf887ce0049bdd3c293924673dff920bcd6a7db46b6861e` |
   | `src/diffie_hellman/dh_exchange.m` | `0b8c5ad9f970fe4393cca48ae0c3b1eee4b884554d4a42e6a25e4bfc93375b9d` |
   | `src/diffie_hellman/dh_key_table.m` | `e520a4f9a8aac957b7cc553b86fefd18291b9ffcfc80291599451949194b4c99` |
   | `src/diffie_hellman/dh_public_value.m` | `6f3d7b854a19eb05e84ff8bc6f961aeefdebcc33c96f160d02bda2af14946eb0` |
   | `src/diffie_hellman/dh_shared_key.m` | `16d73a0f87efe5a75f90e098e7ba67a8a2db0fffe3f63954e809dabdf887ef73` |
   | `src/diffie_hellman/show_dh.m` | `c07f735e445e9ff9e6160744341df2e73b8ecf4be75f5eb3e7dce8a23941cd0e` |
   | `tests/run_all_tests.m` | `dba1692fffff40b1d9c4defe2fd6f6c1670034d915b4d4c360901780cb63fd98` |
   | `tests/test_dh.m` | `92fc2050f35e25d848165bb91b7e0b9e51c5fd707b2de434d1f3a63d017b727a` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': 'd6987b65d7be298def0c0999ca466e4ef93318a81c1986b499768ac6c82c2338',
 'README.md': 'b36f22fd8aef30fd50cd3378962aee6ab4e56f7bc718bf43e2dc08910bb3010b',
 'src/diffie_hellman/check_dh_setup.m': '7ca83dcd723eb25ea86bf2ca82c28413113fd15e0b5e5c7e75534b385909f95f',
 'src/diffie_hellman/define_secrets.m': '2421591175d237bd78ea1a6e8d3d60f9497372a8595d73007fc0eb002334fb68',
 'src/diffie_hellman/demo_point4.m': '3bff3b46edc6b7e35cf887ce0049bdd3c293924673dff920bcd6a7db46b6861e',
 'src/diffie_hellman/dh_exchange.m': '0b8c5ad9f970fe4393cca48ae0c3b1eee4b884554d4a42e6a25e4bfc93375b9d',
 'src/diffie_hellman/dh_key_table.m': 'e520a4f9a8aac957b7cc553b86fefd18291b9ffcfc80291599451949194b4c99',
 'src/diffie_hellman/dh_public_value.m': '6f3d7b854a19eb05e84ff8bc6f961aeefdebcc33c96f160d02bda2af14946eb0',
 'src/diffie_hellman/dh_shared_key.m': '16d73a0f87efe5a75f90e098e7ba67a8a2db0fffe3f63954e809dabdf887ef73',
 'src/diffie_hellman/show_dh.m': 'c07f735e445e9ff9e6160744341df2e73b8ecf4be75f5eb3e7dce8a23941cd0e',
 'tests/run_all_tests.m': 'dba1692fffff40b1d9c4defe2fd6f6c1670034d915b4d4c360901780cb63fd98',
 'tests/test_dh.m': '92fc2050f35e25d848165bb91b7e0b9e51c5fd707b2de434d1f3a63d017b727a',
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
   `git add PROGRESS.md README.md src/diffie_hellman/check_dh_setup.m src/diffie_hellman/define_secrets.m src/diffie_hellman/demo_point4.m src/diffie_hellman/dh_exchange.m src/diffie_hellman/dh_key_table.m src/diffie_hellman/dh_public_value.m src/diffie_hellman/dh_shared_key.m src/diffie_hellman/show_dh.m tests/run_all_tests.m tests/test_dh.m packets/PACKET_4A_DH.md`
5. Run `git status --short`. It must print exactly these 13 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_4A_DH.md
A  src/diffie_hellman/check_dh_setup.m
A  src/diffie_hellman/define_secrets.m
A  src/diffie_hellman/demo_point4.m
A  src/diffie_hellman/dh_exchange.m
A  src/diffie_hellman/dh_key_table.m
A  src/diffie_hellman/dh_public_value.m
A  src/diffie_hellman/dh_shared_key.m
A  src/diffie_hellman/show_dh.m
M  tests/run_all_tests.m
A  tests/test_dh.m
```
6. Commit with exactly this message: `4A: Diffie-Hellman key exchange`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 12 of 12 match.
2. `git log -1 --oneline` shows the message `4A: Diffie-Hellman key exchange`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly ten lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md` and `packets/PACKET_4A_DH.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then 71 lines starting with PASS, then `test_dh: 71 of 71 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point4` and press Enter. Expected: the title `##### POINT 4 DEMO: DIFFIE-HELLMAN KEY EXCHANGE AND ENCRYPTION #####` and then `=== DIFFIE-HELLMAN KEY EXCHANGE ===` with three parts:
   1. Alice and Bob: Alice picks a = 6 and sends A = 8 (`5^6 mod 97 = 8`), Bob picks b = 15 and sends B = 46 (`5^15 mod 97 = 46`), Alice computes `46^6 mod 97 = 85`, Bob computes `8^15 mod 97 = 85`, and the line `Both keys are the same: yes. The key is 85, a number from 1 to 96, ...`; then `Here a*b = 90, a*b mod 96 = 90, and 5^90 mod 97 = 85.`
   2. A table of the 6 users with their secret numbers (6, 15, 23, 41, 58, 77) and public values (8, 46, 82, 80, 44, 23).
   3. A 6 x 6 table of keys. The row of Alice is `-  85  12  89  33  18` and the row of Grace is `18  28  60  41  72  -`. The line `The table is symmetric, so two users always get the same key: yes`.
   and a last block `Checks:` with 7 lines that all end with `yes` (none ends with `NO`).
5. Type `disp([dh_public_value(6, 97, 5), dh_public_value(15, 97, 5), dh_exchange(6, 15, 97, 5).key])` and press Enter. Expected: the three numbers 8, 46 and 85.
6. Type `demo_point1`, then `demo_point2`, then `demo_point3`, and press Enter after each. All three must still print everything as before (`demo_point2` opens its 5 figure windows again, and `demo_point3` has 3 `Checks:` blocks with 18 lines that all end with `yes`).
7. Run `git status --short` in a terminal. It must print nothing.

The planner already ran steps 2 to 5 in GNU Octave 8.4: 25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129, 130 of 130, 131 of 131 and 71 of 71 checks passed, and `demo_point4` printed 7 check lines that all say yes. The new functions were also compared with a separate Python program on 1920 exchanges (primes up to 2^26, random secret numbers) and gave the same public values, keys and exponents every time. A test of the tests: 32 small bugs were planted one by one in the new files, and the tests caught 28 of them. The 4 that were not caught change no result (2 are range limits that is_generator refuses anyway, 2 are lines that always say yes when the code is right and are tested directly in test_dh).

Paste line for the agent:

`Read packets/PACKET_4A_DH.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
